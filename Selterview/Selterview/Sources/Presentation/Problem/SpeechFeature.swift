//
//  SpeechFeature.swift
//  Selterview
//
//  Created by woo0 on 4/18/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SpeechFeature {
	@ObservableState
	struct State: Equatable {
		var transcript: String
		
		init() {
			self.transcript = ""
		}
	}
	
	enum Action: BindableAction, Equatable {
		case startSpeech
		case stopSpeech
		case setTranscript(String)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .startSpeech:
				STTManager.shared.startTranscribing()
				return .none
			case .stopSpeech:
				STTManager.shared.stopTranscribing()
				return .concatenate(.send(.setTranscript(STTManager.shared.transcript)))
			case .setTranscript(let transcript):
				state.transcript = transcript
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
