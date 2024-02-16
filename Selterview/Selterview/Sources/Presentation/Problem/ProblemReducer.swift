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
		@BindingState var isQuestionTap: Bool
		var error: ChatGPTFailure?
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
			self.error = nil
			self.isQuestionTap = false
		}
	}
	
	enum Action: BindableAction, Equatable {
		case previousQuestion
		case nextQuestionButtonTapped
		case newTailQuestionCreateButtonTapped
		case newTailQuestionCreated(Question)
		case enableAnswerFocus
		case disableAnswerFocus
		case catchError(ChatGPTFailure)
		case showQuestionDetailView
		case hideQuestionDetailView
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .previousQuestion:
				if state.isTailQuestionCreating { return .none }
				state.answerText = ""
				state.isFocusedAnswer = false
				if state.questionIndex - 1 >= 0 {
					state.questionIndex -= 1
				} else {
					state.questionIndex = state.questions.count - 1
				}
				state.question = state.questions[state.questionIndex]
				return .none
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
					if let error = error as? ChatGPTFailure { await send(.catchError(error)) }
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
			case .catchError(let error):
				// TODO: Error Test
				state.isError = true
				state.error = error
				state.isFocusedAnswer = false
				return .none
			case .showQuestionDetailView:
				state.isQuestionTap = true
				return .none
			case .hideQuestionDetailView:
				state.isQuestionTap = false
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
