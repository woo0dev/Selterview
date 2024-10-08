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
		@BindingState var addQuestions: Questions
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
			self.addQuestions = [Question(title: "", category: category)]
		}
	}
	
	enum Action: BindableAction, Equatable {
		case addButtonTapped
		case addQuestion(Questions)
		case addQuestionCancel
		case deleteButtonTapped(Question)
		case fetchQuestions
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
			case .addQuestion(let questions):
				do {
					try RealmManager.shared.writeQuestions(questions)
					state.questions = state.questions + questions
					state.addQuestions = [Question(title: "", category: state.category)]
					state.isAddButtonTap = false
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionAddError))
					return .concatenate(effect)
				}
				return .none
			case .addQuestionCancel:
				state.addQuestions = [Question(title: "", category: state.category)]
				state.isAddButtonTap = false
				return .none
			case .deleteButtonTapped(let question):
				do {
					try RealmManager.shared.deleteQuestion(question._id)
					return .concatenate(.send(.fetchQuestions))
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
