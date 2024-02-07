//
//  ProblemReducer.swift
//  Selterview
//
//  Created by woo0 on 2/7/24.
//

import ComposableArchitecture

@Reducer
struct ProblemReducer {
	struct State: Equatable {
		@BindingState var answerText: String
		var questionIndex: Int
		var questions: [Question]
		var question: Question
		
		init(questions: [Question], questionIndex: Int) {
			self.questions = questions
			self.questionIndex = questionIndex
			self.answerText = ""
			self.question = questions[questionIndex]
		}
	}
	
	enum Action: BindableAction, Equatable {
		case nextQuestionButtonTapped
		case newTailQuestionCreateButtonTapped
		case binding(BindingAction<State>)
	}
	
	struct Environment { }
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .nextQuestionButtonTapped:
				if state.questionIndex + 1 >= state.questions.count {
					state.questionIndex = 0
				} else {
					state.questionIndex += 1
				}
				state.question = state.questions[state.questionIndex]
				return .none
			case .newTailQuestionCreateButtonTapped:
				print("꼬리질문 버튼 터치")
				// TODO: chatGPT 연동 작업
				return .none
			case .binding(\.$answerText):
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
