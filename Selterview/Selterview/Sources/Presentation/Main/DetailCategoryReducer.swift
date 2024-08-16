//
//  DetailCategoryReducer.swift
//  Selterview
//
//  Created by woo0 on 8/15/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailCategoryReducer {
	struct State: Equatable {
		@BindingState var addQuestionTitle: String = ""
		@BindingState var isAddButtonTap: Bool = false
		@BindingState var isError: Bool = false
		@BindingState var isRandomStartButtonTap: Bool = false
		@BindingState var isShowToast: Bool = false
		@BindingState var toastMessage: String = ""
		var category: String
		var error: RealmFailure? = nil
		var questions: Questions
		
		init(category: String, questions: Questions) {
			self.category = category
			self.questions = questions
		}
	}
	
	enum Action: BindableAction, Equatable {
		case addButtonTapped
		case addQuestion(Question)
		case addQuestionCancel
		case deleteButtonTapped(Question)
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .addButtonTapped:
				state.isAddButtonTap = true
				return .none
			case .addQuestion(let question):
				do {
					try RealmManager.shared.writeQuestion(question)
					state.questions = state.questions + [question]
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionAddError))
					return .concatenate(effect)
				}
				return .none
			case .addQuestionCancel:
				state.addQuestionTitle = ""
				state.isAddButtonTap = false
				return .none
			case .deleteButtonTapped(let question):
				do {
					try RealmManager.shared.deleteQuestion(question._id)
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionDeleteError))
					return .concatenate(effect)
				}
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
	}
}
