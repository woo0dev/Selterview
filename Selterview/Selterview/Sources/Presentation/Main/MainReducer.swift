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
		@BindingState var selectedCategory: String? = nil
		@BindingState var addCategoryText: String = ""
		@BindingState var toastMessage: String = ""
		@BindingState var isAddButtonTap: Bool = false
		@BindingState var isRandomStartButtonTap: Bool = false
		@BindingState var isSettingButtonTap: Bool = false
		@BindingState var isCategoryAddButtonTap: Bool = false
		@BindingState var isCategoryDeleteButtonTap: Bool = false
		@BindingState var isShowToast: Bool = false
		@BindingState var isError: Bool = false
		var error: RealmFailure? = nil
		var questions: Questions = []
		var filteredQuestions: Questions = []
		var categories: [String]? = nil
	}
	
	enum Action: BindableAction, Equatable {
		case fetchQuestions
		case addButtonTapped
		case deleteButtonTapped(Question)
		case randomStartButtonTapped
		case settingButtonTapped
		case fetchCategories
		case addCategoryTapped
		case addCategory
		case addCategoryCancel
		case deleteCategoryButtonTapped
		case deleteCategory
		case deleteCategoryCancle
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
					state.filteredQuestions = state.questions.filter({ $0.category == state.selectedCategory })
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionsFetchError))
					return .concatenate(effect)
				}
				return .none
			case .addButtonTapped:
				if state.categories == nil {
					state.isCategoryAddButtonTap = true
					state.toastMessage = "카테고리를 먼저 추가해주세요."
					state.isShowToast = true
				} else {
					state.isAddButtonTap = true
				}
				return .none
			case .deleteButtonTapped(let question):
				do {
					try RealmManager.shared.deleteQuestion(question._id)
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionDeleteError))
					return .concatenate(effect)
				}
				return .none
			case .randomStartButtonTapped:
				if state.filteredQuestions.isEmpty {
					let effect: Effect<Action> = .send(.catchError(.questionsEmpty))
					return .concatenate(effect)
				} else {
					state.isRandomStartButtonTap = true
				}
				return .none
			case .settingButtonTapped:
				state.isSettingButtonTap = true
				return .none
			case .fetchCategories:
				state.categories = UserDefaults.standard.array(forKey: "Categories") as? [String]
				state.selectedCategory = state.categories?.first
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
			case .deleteCategoryButtonTapped:
				state.isCategoryDeleteButtonTap = true
				return .none
			case .deleteCategory:
				guard let category = state.selectedCategory else { return .none }
				var categories = state.categories ?? []
				do {
					for question in state.filteredQuestions {
						try RealmManager.shared.deleteQuestion(question._id)
					}
				} catch {
					return .concatenate(.send(.catchError(.questionDeleteError)))
				}
				for index in categories.indices {
					if categories[index] == category {
						categories.remove(at: index)
						break
					}
				}
				UserDefaults.standard.set(categories, forKey: "Categories")
				return .concatenate(.send(.fetchCategories))
			case .deleteCategoryCancle:
				state.isCategoryDeleteButtonTap = false
				return .none
			case .catchError(let error):
				state.isError = true
				state.toastMessage = error.errorDescription ?? "알 수 없는 에러가 발생했습니다."
				state.isShowToast = true
				state.error = error
				return .none
			case .binding(\.$selectedCategory):
				state.filteredQuestions = state.questions.filter({ $0.category == state.selectedCategory })
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
