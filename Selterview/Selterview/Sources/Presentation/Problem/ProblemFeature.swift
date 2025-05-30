//
//  ProblemFeature.swift
//  Selterview
//
//  Created by woo0 on 2/7/24.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct ProblemFeature {
	@Dependency(\.openAIClient) var openAIClient
	
	struct State: Equatable {
		@BindingState var answerText: String
		@BindingState var toastMessage: String = ""
		@BindingState var isTailQuestionCreating: Bool
		@BindingState var isQuestionTap: Bool
		@BindingState var isShowToast: Bool
		@BindingState var isSpeech: Bool
		var originalIndex: Int
		var question: QuestionDTO
		var isAnswerSave: Bool = true
		var isFocusedAnswer: Bool
		var questionIndex: Int
		var questions: [QuestionDTO]
		
		var speechState: SpeechFeature.State = SpeechFeature.State()
		
		init(questions: [QuestionDTO], questionIndex: Int) {
			self.isFocusedAnswer = false
			self.questions = questions
			self.questionIndex = questionIndex
			self.answerText = questions[questionIndex].answer ?? ""
			self.originalIndex = questionIndex
			self.question = questions[questionIndex]
			self.isTailQuestionCreating = false
			self.isQuestionTap = false
			self.isShowToast = false
			self.isSpeech = false
		}
	}
	
	enum Action: BindableAction, Equatable {
		case speechAction(SpeechFeature.Action)
		case onAppear
		case onDisappear
		case previousQuestion
		case nextQuestionButtonTapped
		case newTailQuestionCreateButtonTapped
		case newTailQuestionCreated(QuestionDTO)
		case questionSave(QuestionDTO, String)
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
			SpeechFeature()
		}
		
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .speechAction:
				if state.speechState.transcript.count > 0 {
					state.answerText = state.speechState.transcript
				}
				return .none
			case .onAppear:
				state.question = state.questions[state.questionIndex]
				state.answerText = state.question.answer ?? ""
				return .none
			case .onDisappear:
				state.questionIndex = state.originalIndex
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
					return .none
				} catch {
					return .concatenate(.send(.catchError(RealmFailure.questionUpdateError.errorDescription)))
				}
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
			}
		}
	}
}
