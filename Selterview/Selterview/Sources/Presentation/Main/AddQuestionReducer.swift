//
//  AddQuestionReducer.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct AddQuestionReducer {
	@Dependency(\.openAIClient) var openAIClient
	@Dependency(\.webScraperClient) var webScraperClient
	
	struct State: Equatable {
		@BindingState var additionalOption: AdditionalOption = .none
		@BindingState var addQuestions: Questions = []
		@BindingState var isAddQuestionPresented: Bool = false
		@BindingState var isExtracting: Bool = false
		@BindingState var isError: Bool = false
		@BindingState var isShowToast: Bool = false
		@BindingState var toastMessage: String = ""
		@BindingState var urlString: String = ""
		var category: String
		
		init(category: String) {
			self.category = category
		}
	}
	
	enum Action: BindableAction, Equatable {
		case didSelectAddOption(AdditionalOption)
		case extractTextFromURL
		case extractInterviewQuestions(String)
		case didFinishExtractingQuestions(String)
		case addQuestions(Questions)
		case didFinishAddingQuestions
		case addQuestionCancel
		case catchError(String)
		case binding(BindingAction<State>)
	}
	
	var body: some Reducer<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .didSelectAddOption(let additionalOption):
				state.additionalOption = additionalOption
				return .none
				
			case .extractTextFromURL:
				guard !state.isExtracting else { return .none }
				state.isExtracting = true
				return .run { [urlString = state.urlString] send in
					if let extractText = try await webScraperClient.extractTextFromURL(urlString) {
						await send(.extractInterviewQuestions(extractText))
					}
				} catch: { error, send in
					await send(.catchError(error.localizedDescription))
				}.cancellable(id: AddQuestionReducer.CancelID.extractTextFromURL)
				
			case .extractInterviewQuestions(let texts):
				return .run { send in
					if let questions = try await openAIClient.extractInterviewQuestions(texts) {
						await send(.didFinishExtractingQuestions(questions))
					}
				} catch: { error, send in
					await send(.catchError(error.localizedDescription))
				}.cancellable(id: AddQuestionReducer.CancelID.extractInterviewQuestions)
				
			case .didFinishExtractingQuestions(let questions):
				state.isExtracting = false
				state.addQuestions = questions.split(separator: ",").map { Question(title: "\($0)", category: state.category) }
				return .none
				
			case .addQuestions(let questions):
				return .run { send in
					try RealmManager.shared.writeQuestions(questions)
					await send(.didFinishAddingQuestions)
				} catch: { error, send in
					await send(.catchError(RealmFailure.questionAddError.errorDescription))
				}
				
			case .didFinishAddingQuestions:
				state.addQuestions = []
				state.isAddQuestionPresented = false
				return .none
				
			case .addQuestionCancel:
				state.addQuestions = []
				state.isAddQuestionPresented = false
				return .none
				
			case .catchError(let errorDescription):
				state.isExtracting = false
				state.isError = true
				state.toastMessage = errorDescription
				state.isShowToast = true
				return .none
				
			case .binding(_):
				return .none
			}
		}
	}
	
	enum CancelID: Hashable {
		case extractTextFromURL
		case extractInterviewQuestions
	}
}
