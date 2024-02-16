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
		@BindingState var isError: Bool = false
		var error: RealmFailure? = nil
		var questions: Questions = []
		var filteredQuestions: Questions = []
	}
	
	enum Action: BindableAction, Equatable {
		case onAppear
		case updatedQuestions(Questions)
		case addButtonTapped
		case deleteButtonTapped
		case settingButtonTapped
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .onAppear:
				return .run { send in
					if let questions = try RealmManager.shared.readQuestions() {
						await send(.updatedQuestions(questions))
					}
				} catch: { error, send in
					if let error = error as? RealmFailure { await send(.catchError(error)) }
				}
			case .updatedQuestions(let questions):
				state.questions = questions
				state.filteredQuestions = questions.filter({ $0.category == state.selectedCategory.rawValue })
				return .none
			case .addButtonTapped:
				state.isAddButtonTap = true
				return .none
			case .deleteButtonTapped:
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
