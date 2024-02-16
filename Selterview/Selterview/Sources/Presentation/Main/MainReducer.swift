//
//  MainReducer.swift
//  Selterview
//
//  Created by woo0 on 2/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainReducer {
	struct State: Equatable {
		@BindingState var selectedCategory: Category = .swift
		@BindingState var isAddButtonTap: Bool = false
		@BindingState var isSettingButtonTap: Bool = false
		@BindingState var isError: Bool = false
		var error: RealmFailure? = nil
		var questions: Questions = []
		var filteredQuestions: Questions = []
	}
	
	enum Action: BindableAction, Equatable {
		case fetchQuestions
		case addButtonTapped
		case deleteButtonTapped(Question)
		case settingButtonTapped
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .fetchQuestions:
				do {
					state.questions = try RealmManager.shared.readQuestions() ?? []
					state.filteredQuestions = state.questions.filter({ $0.category == state.selectedCategory.rawValue })
				} catch {
					let effect: Effect<Action> = .send(.catchError(RealmFailure.questionsFetchError))
					return .concatenate(effect)
				}
				return .none
			case .addButtonTapped:
				state.isAddButtonTap = true
				return .none
			case .deleteButtonTapped(let question):
				do {
					try RealmManager.shared.deleteQuestion(question._id)
				} catch {
					let effect: Effect<Action> = .send(.catchError(RealmFailure.questionDeleteError))
					return .concatenate(effect)
				}
				return .none
			case .settingButtonTapped:
				state.isSettingButtonTap = true
				return .none
			case .catchError(let error):
				if error == .questionsEmpty { return .none }
				state.isError = true
				state.error = error
				return .none
			case .binding(\.$selectedCategory):
				state.filteredQuestions = state.questions.filter({ $0.category == state.selectedCategory.rawValue })
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
