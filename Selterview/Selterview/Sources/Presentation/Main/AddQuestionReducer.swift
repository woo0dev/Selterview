//
//  AddQuestionReducer.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddQuestionReducer {
	struct State: Equatable {
		@BindingState var additionalOption: AdditionalOption = .none
		@BindingState var addQuestions: Questions = []
		@BindingState var isAddQuestionPresented: Bool = false
		@BindingState var isError: Bool = false
		@BindingState var isShowToast: Bool = false
		@BindingState var toastMessage: String = ""
		@BindingState var urlString: String = ""
		var category: String
		var error: RealmFailure? = nil
		
		init(category: String) {
			self.category = category
		}
	}
	
	enum Action: BindableAction, Equatable {
		case test
		case didSelectAddOption(AdditionalOption)
		case addQuestions(Questions)
		case addQuestionCancel
		case catchError(RealmFailure)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .test:
				print(state.urlString)
				state.additionalOption = .userDefined
				return .none
			case .didSelectAddOption(let additionalOption):
				state.additionalOption = additionalOption
				return .none
			case .addQuestions(let questions):
				do {
					try RealmManager.shared.writeQuestions(questions)
					state.addQuestions = []
					state.isAddQuestionPresented = false
				} catch {
					let effect: Effect<Action> = .send(.catchError(.questionAddError))
					return .concatenate(effect)
				}
				return .none
			case .addQuestionCancel:
				state.addQuestions = []
				state.isAddQuestionPresented = false
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
