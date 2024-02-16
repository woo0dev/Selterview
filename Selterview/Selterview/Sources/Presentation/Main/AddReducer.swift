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
		@BindingState var selectedCategory: Category = .swift
		@BindingState var questionTitle: String = ""
		@BindingState var isError: Bool = false
		var isComplete: Bool = false
		var error: RealmFailure? = nil
		var categories: [Category] = [.swift, .ios, .cs]
	}
	
	enum Action: BindableAction, Equatable {
		case onAppear
		case addButtonTapped
		case addCompleted
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .none
			case .addButtonTapped:
				do {
					try RealmManager.shared.writeQuestion(Question(title: state.questionTitle, category: state.selectedCategory))
					let effect: Effect<Action> = .send(.addCompleted)
					return .concatenate(effect)
				} catch {
					let effect: Effect<Action> = .send(.catchError(RealmFailure.questionAddError))
					return .concatenate(effect)
				}
			case .addCompleted:
				state.isComplete = true
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
