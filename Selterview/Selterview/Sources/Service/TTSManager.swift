//
//  TTSManager.swift
//  Selterview
//
//  Created by woo0 on 3/26/24.
//

import AVFoundation

class TTSManager: NSObject {
	static let shared = TTSManager()
	
	private let audioSession = AVAudioSession()
	private var synthesizer = AVSpeechSynthesizer()
	
	internal func play(_ string: String) {
		do {
			try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
			try audioSession.setActive(true)
		} catch let error {
			print(error.localizedDescription)
		}

		let utterance = AVSpeechUtterance(string: string)
		utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
		utterance.rate = 0.4
		synthesizer.delegate = self
		synthesizer.stopSpeaking(at: .immediate)
		synthesizer.speak(utterance)
	}
	
	internal func stop() {
		if synthesizer.isSpeaking {
			synthesizer.stopSpeaking(at: .immediate)
		}
		do {
			try audioSession.setActive(false, options: [])
		} catch {
			print(error.localizedDescription)
		}
	}
}

extension TTSManager: AVSpeechSynthesizerDelegate {
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		stop()
	}
}
