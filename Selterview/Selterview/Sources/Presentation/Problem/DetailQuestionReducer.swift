//
//  DetailQuestionReducer.swift
//  Selterview
//
//  Created by woo0 on 3/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailQuestionReducer {
	@ObservableState
	struct State: Equatable {
		var isSpeaking: Bool = false
		var question: Question
		
		init(question: Question) {
			self.question = question
		}
	}
	
	enum Action: BindableAction, Equatable {
		case startSpeak
		case stopSpeak
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .startSpeak:
				TTSManager.shared.play(state.question.title)
				return .none
			case .stopSpeak:
				TTSManager.shared.stop()
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
