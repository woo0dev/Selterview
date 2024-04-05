//
//  TTSManager.swift
//  Selterview
//
//  Created by woo0 on 3/26/24.
//

import AVFoundation

class TTSManager {
	static let shared = TTSManager()
	
	private let audioSession = AVAudioSession()
	private var synthesizer = AVSpeechSynthesizer()
	
	internal func play(_ string: String) {
		do {
			try audioSession.setCategory(.playback, mode: .default, options: .duckOthers)
			try audioSession.setActive(false)
		} catch let error {
			print(error.localizedDescription)
		}

		let utterance = AVSpeechUtterance(string: string)
		utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
		utterance.rate = 0.4
		synthesizer.stopSpeaking(at: .immediate)
		synthesizer.speak(utterance)
	}
	
	internal func stop() {
		if synthesizer.isSpeaking {
			synthesizer.stopSpeaking(at: .immediate)
		}
	}
}
