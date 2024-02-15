//
//  MainReducer.swift
//  Selterview
//
//  Created by woo0 on 2/7/24.
//

import ComposableArchitecture

@Reducer
struct MainReducer {
	struct State: Equatable {
		@BindingState var selectedCategory: Category = .swift
		@BindingState var isAddButtonTap: Bool = false
		@BindingState var isSettingButtonTap: Bool = false
		var questions: Questions = []
		var filteredQuestions: Questions = []
	}
	
	enum Action: BindableAction, Equatable {
		case onAppear
		case addButtonTapped
		case settingButtonTapped
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				state.filteredQuestions = state.questions.filter({ $0.category == state.selectedCategory })
				return .none
			case .addButtonTapped:
				state.isAddButtonTap = true
				return .none
			case .settingButtonTapped:
				state.isSettingButtonTap = true
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
