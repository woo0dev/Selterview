//
//  DetailCategoryFeature.swift
//  Selterview
//
//  Created by woo0 on 8/15/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailCategoryFeature {
	struct State: Equatable {
		@PresentationState var addQuestionState: AddQuestionFeature.State? = nil
		@BindingState var isError: Bool = false
		@BindingState var isRandomStartButtonTap: Bool = false
		@BindingState var isShowToast: Bool = false
		@BindingState var toastMessage: String = ""
		var category: String
		var questions: [QuestionDTO]
		var error: RealmFailure? = nil
		
		init(category: String, questions: [QuestionDTO]) {
			self.category = category
			self.questions = questions
		}
	}
	
	enum Action: BindableAction, Equatable {
		case addButtonTapped
		case deleteButtonTapped(QuestionDTO)
		case fetchQuestions
		case addQuestionState(PresentationAction<AddQuestionFeature.Action>)
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.addQuestionState = AddQuestionFeature.State(category: state.category)
				return .none
			case .deleteButtonTapped(let question):
				do {
					if let id = question.id {
						try RealmManager.shared.deleteQuestion(id)
						return .concatenate(.send(.fetchQuestions))
					} else {
						return .send(.catchError(.questionDeleteError))
					}
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionDeleteError))
					return .concatenate(effect)
				}
			case .fetchQuestions:
				do {
					let questions = try RealmManager.shared.readQuestions() ?? []
					state.questions = questions.filter({ $0.category == state.category})
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionsFetchError))
					return .concatenate(effect)
				}
				return .none
			case .addQuestionState(.presented(.delegate(.dismissRequested))):
				state.addQuestionState = nil
				return .send(.fetchQuestions)
			case .addQuestionState:
				return .none
			case .catchError(let error):
				state.isError = true
				state.toastMessage = error.errorDescription ?? "알 수 없는 에러가 발생했습니다."
				state.isShowToast = true
				state.error = error
				return .none
			case .binding(_):
				return .none
			}
		}
		.ifLet(\.$addQuestionState, action: \.addQuestionState) {
			AddQuestionFeature()
		}
	}
}
