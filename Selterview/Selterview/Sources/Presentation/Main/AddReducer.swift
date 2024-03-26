//
//  AddReducer.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddReducer {
	struct State: Equatable {
		@BindingState var selectedCategory: String
		@BindingState var questionTitle: String = ""
		@BindingState var toastMessage: String = ""
		@BindingState var isShowToast: Bool = false
		@BindingState var isError: Bool = false
		var isComplete: Bool = false
		var isFocused: Bool = false
		var error: RealmFailure? = nil
		var categories: [String] = []
	}
	
	enum Action: BindableAction, Equatable {
		case onAppear
		case changeCategory(String)
		case addButtonTapped
		case addCompleted
		case enableFocus
		case disableFocus
		case fetchCategories
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .none
			case .changeCategory(let category):
				state.selectedCategory = category
				return .none
			case .addButtonTapped:
				state.isFocused = false
				if state.selectedCategory == "카테고리 선택" {
					state.toastMessage = "카테고리를 먼저 추가해주세요."
					state.isShowToast = true
					state.isComplete = true
					return .none
				}
				do {
					try RealmManager.shared.writeQuestion(Question(title: state.questionTitle, category: state.selectedCategory))
					let effect: Effect<Action> = .send(.addCompleted)
					return .concatenate(effect)
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionAddError))
					return .concatenate(effect)
				}
			case .addCompleted:
				state.isComplete = true
				return .none
			case .enableFocus:
				state.isFocused = true
				return .none
			case .disableFocus:
				state.isFocused = false
				return .none
			case .fetchCategories:
				state.categories += UserDefaults.standard.array(forKey: "Categories") as? [String] ?? ["카테고리 선택"]
				return .none
			case .catchError(let error):
				state.isError = true
				state.error = error
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
