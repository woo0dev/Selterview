//
//  STTManager.swift
//  Selterview
//
//  Created by woo0 on 4/18/24.
//

import Speech
import AVFoundation

class STTManager: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
	static let shared = STTManager()
	
	private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
	private let audioEngine = AVAudioEngine()
	private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	private var recognitionTask: SFSpeechRecognitionTask?
	
	@Published var transcript = ""
	
	func startTranscribing() {
		if audioEngine.isRunning {
			audioEngine.stop()
			audioEngine.inputNode.removeTap(onBus: 0)
		}
		
		recognitionTask?.cancel()
		recognitionTask = nil
		
		let audioSession = AVAudioSession.sharedInstance()
		do {
			try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
		} catch {
			print("오디오 세션 설정 실패: \(error)")
			return
		}
		
		recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
		guard let recognitionRequest = recognitionRequest else { return }
		
		recognitionRequest.shouldReportPartialResults = true
		
		recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest) { [weak self] result, error in
			guard let strongSelf = self else { return }
			
			var isFinal = false
			
			if let result = result {
				DispatchQueue.main.async {
					strongSelf.transcript = result.bestTranscription.formattedString
				}
				isFinal = result.isFinal
			}
			
			if error != nil || isFinal {
				strongSelf.cleanup()
			}
		}
		
		let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
		audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
			recognitionRequest.append(buffer)
		}
		
		do {
			try audioEngine.start()
		} catch {
			print("오디오 엔진 시작 실패: \(error)")
			cleanup()
		}
	}
	
	func stopTranscribing() {
		recognitionTask?.cancel()
		cleanup()
	}
	
	private func cleanup() {
		if audioEngine.isRunning {
			audioEngine.stop()
			audioEngine.inputNode.removeTap(onBus: 0)
		}
		recognitionRequest?.endAudio()
		recognitionRequest = nil
		recognitionTask = nil
	}
}

extension SFSpeechRecognizer {
	static func hasAuthorizationToRecognize() async -> Bool {
		await withCheckedContinuation { continuation in
			requestAuthorization { status in
				continuation.resume(returning: status == .authorized)
			}
		}
	}
}
