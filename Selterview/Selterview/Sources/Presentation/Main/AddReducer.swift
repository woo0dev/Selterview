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
		@BindingState var isError: Bool = false
		var error: RealmFailure? = nil
		var categories: [Category] = [.swift, .ios, .cs]
	}
	
	enum Action: BindableAction, Equatable {
		case onAppear
		case addButtonTapped
		case enableError
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .none
			case .addButtonTapped:
				return .run { [title = state.questionTitle, category = state.selectedCategory] send in
//					RealmManager.addQuestion(<#T##self: RealmManager##RealmManager#>)
//					if let tailQuestion = try await openAIClient.fetchTailQuestion(title, answer) {
//						await send(.newTailQuestionCreated(tailQuestion))
//					}
				} catch: { error, send in
					await send(.enableError)
				}
			case .enableError:
				state.isError = true
				return .none
			case .binding(_):
				return .none
			}
		}
	}
}
