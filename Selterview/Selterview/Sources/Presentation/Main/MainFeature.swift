//
//  MainFeature.swift
//  Selterview
//
//  Created by woo0 on 2/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MainFeature {
	struct State: Equatable {
		@BindingState var addCategoryText: String = ""
		@BindingState var toastMessage: String = ""
		@BindingState var isCategoryAddButtonTap: Bool = false
		@BindingState var isShowToast: Bool = false
		@BindingState var isError: Bool = false
		var error: RealmFailure? = nil
		var questions: [String: [QuestionDTO]] = [:]
		var categories: [String] = []
	}
	
	enum Action: BindableAction, Equatable {
		case fetchQuestions
		case fetchCategories
		case addCategoryTapped
		case addCategory
		case addCategoryCancel
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .fetchQuestions:
				do {
					let questions = try RealmManager.shared.readQuestions() ?? []
					var filteredQuestions = state.questions
					for question in questions {
						filteredQuestions[question.category]?.append(question)
					}
					state.questions = filteredQuestions
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionsFetchError))
					return .concatenate(effect)
				}
				return .none
			case .fetchCategories:
				state.categories = UserDefaults.standard.array(forKey: "Categories") as? [String] ?? []
				for category in state.categories {
					state.questions[category] = []
				}
				return .concatenate(.send(.fetchQuestions))
			case .addCategoryTapped:
				state.isCategoryAddButtonTap = true
				return .none
			case .addCategory:
				let categories = UserDefaults.standard.array(forKey: "Categories") as? [String] ?? []
				if categories.contains(state.addCategoryText) {
					state.toastMessage = "이미 존재하는 카테고리입니다."
					state.isShowToast = true
					state.addCategoryText = ""
					return .none
				}
				UserDefaults.standard.set(categories + [state.addCategoryText], forKey: "Categories")
				state.addCategoryText = ""
				return .concatenate(.send(.fetchCategories))
			case .addCategoryCancel:
				state.addCategoryText = ""
				state.isCategoryAddButtonTap = false
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
