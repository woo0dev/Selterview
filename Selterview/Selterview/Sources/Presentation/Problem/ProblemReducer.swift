//
//  ProblemReducer.swift
//  Selterview
//
//  Created by woo0 on 2/7/24.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct ProblemReducer {
	@Dependency(\.openAIClient) var openAIClient
	
	struct State: Equatable {
		@BindingState var answerText: String
		@BindingState var isTailQuestionCreating: Bool
		@BindingState var isError: Bool
		var isFocusedAnswer: Bool
		var questionIndex: Int
		var questions: Questions
		var question: Question
		
		init(questions: Questions, questionIndex: Int) {
			self.isFocusedAnswer = false
			self.questions = questions
			self.questionIndex = questionIndex
			self.answerText = ""
			self.question = questions[questionIndex]
			self.isTailQuestionCreating = false
			self.isError = false
		}
	}
	
	enum Action: BindableAction, Equatable {
		case nextQuestionButtonTapped
		case newTailQuestionCreateButtonTapped
		case newTailQuestionCreated(Question)
		case enableAnswerFocus
		case disableAnswerFocus
		case enableError
		case disableError
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .nextQuestionButtonTapped:
				if state.isTailQuestionCreating { return .none }
				state.answerText = ""
				state.isFocusedAnswer = false
				if state.questionIndex + 1 >= state.questions.count {
					state.questionIndex = 0
				} else {
					state.questionIndex += 1
				}
				state.question = state.questions[state.questionIndex]
				return .none
			case .newTailQuestionCreateButtonTapped:
				if state.isTailQuestionCreating { return .none }
				state.isTailQuestionCreating = true
				state.answerText = ""
				state.isFocusedAnswer = false
				return .run { [title = state.question.title, answer = state.answerText] send in
					if let tailQuestion = try await openAIClient.fetchTailQuestion(title, answer) {
						await send(.newTailQuestionCreated(tailQuestion))
					}
				} catch: { error, send in
					await send(.enableError)
				}
			case .newTailQuestionCreated(let tailQuestion):
				state.question = tailQuestion
				state.isTailQuestionCreating = false
				return .none
			case .enableAnswerFocus:
				state.isFocusedAnswer = true
				return .none
			case .disableAnswerFocus:
				state.isFocusedAnswer = false
				return .none
			case .enableError:
				state.isError = true
				state.isFocusedAnswer = false
				return .none
			case .disableError:
				state.isError = false
				return .none
			case .binding(\.$isError):
				return .none
			case .binding(\.$isTailQuestionCreating):
				return .none
			case .binding(\.$answerText):
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
