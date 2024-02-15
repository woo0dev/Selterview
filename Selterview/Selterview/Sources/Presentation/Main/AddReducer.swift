//
//  AddReducer.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import ComposableArchitecture

@Reducer
struct AddReducer {
	struct State: Equatable {
		@BindingState var selectedCategory: Category = .swift
		@BindingState var questionTitle: String = ""
		var categories: [Category] = [.swift, .ios, .cs]
	}
	
	enum Action: BindableAction, Equatable {
		case onAppear
		case addButtonTapped
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .none
			case .addButtonTapped:
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
