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
		@BindingState var toastMessage: String = ""
		@BindingState var isTailQuestionCreating: Bool
		@BindingState var isQuestionTap: Bool
		@BindingState var isShowToast: Bool
		@BindingState var isSpeech: Bool
		var question: Question
		var isAnswerSave: Bool = true
		var isFocusedAnswer: Bool
		var questionIndex: Int
		var questions: Questions
		
		var speechState: SpeechReducer.State = SpeechReducer.State()
		
		init(questions: Questions, questionIndex: Int) {
			self.isFocusedAnswer = false
			self.questions = questions
			self.questionIndex = questionIndex
			self.answerText = questions[questionIndex].answer ?? ""
			self.question = questions[questionIndex]
			self.isTailQuestionCreating = false
			self.isQuestionTap = false
			self.isShowToast = false
			self.isSpeech = false
		}
	}
	
	enum Action: BindableAction, Equatable {
		case speechAction(SpeechReducer.Action)
		case previousQuestion
		case nextQuestionButtonTapped
		case newTailQuestionCreateButtonTapped
		case newTailQuestionCreated(Question)
		case questionSave(Question, String)
		case updateQuestions
		case startSpeak
		case stopSpeak
		case startSpeechButtonTapped
		case enableAnswerFocus
		case disableAnswerFocus
		case catchError(String)
		case showQuestionDetailView
		case hideQuestionDetailView
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		Scope(state: \.speechState, action: /Action.speechAction) {
			SpeechReducer()
		}
		
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .speechAction:
				if state.speechState.transcript.count > 0 {
					state.answerText = state.speechState.transcript
				}
				return .none
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
				state.answerText = state.question.answer ?? ""
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
				state.answerText = state.question.answer ?? ""
				return .none
			case .newTailQuestionCreateButtonTapped:
				if state.isTailQuestionCreating { return .none }
				let answerText = state.answerText
				state.isTailQuestionCreating = true
				state.answerText = ""
				state.isFocusedAnswer = false
				return .run { [title = state.question.title, answer = answerText] send in
					if let tailQuestion = try await openAIClient.fetchTailQuestion(title, answer) {
						await send(.newTailQuestionCreated(tailQuestion))
					}
				} catch: { error, send in
					if let error = error as? ChatGPTFailure { await send(.catchError(error.errorDescription)) }
				}
			case .newTailQuestionCreated(let tailQuestion):
				state.question = tailQuestion
				state.isTailQuestionCreating = false
				return .none
			case .questionSave(let question, let answer):
				do {
					try RealmManager.shared.updateQuestion(question, answer)
					return .concatenate(.send(.updateQuestions))
				} catch {
					return .concatenate(.send(.catchError(RealmFailure.questionUpdateError.errorDescription)))
				}
			case .updateQuestions:
//				do {
//					state.questions = try RealmManager.shared.readQuestions()?.filter({ $0.category == state.question.category }) ?? []
//				} catch {
//					return .concatenate(.send(.catchError(RealmFailure.questionsFetchError.errorDescription)))
//				}
				return .none
			case .startSpeak:
				TTSManager.shared.play(state.question.title)
				return .none
			case .stopSpeak:
				TTSManager.shared.stop()
				return .none
			case .startSpeechButtonTapped:
				state.isSpeech = true
				return .none
			case .enableAnswerFocus:
				state.isFocusedAnswer = true
				return .none
			case .disableAnswerFocus:
				state.isFocusedAnswer = false
				return .none
			case .catchError(let error):
				state.isTailQuestionCreating = false
				state.toastMessage = error
				state.isShowToast = true
				return .none
			case .showQuestionDetailView:
				state.isQuestionTap = true
				return .none
			case .hideQuestionDetailView:
				state.isQuestionTap = false
				return .none
			case .binding(_):
				return .none
			default:
				return .none
			}
		}
	}
}
