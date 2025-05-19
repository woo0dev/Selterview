//
//  AddQuestionFeature.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import Foundation
import ComposableArchitecture
import Dependencies

@Reducer
struct AddQuestionFeature {
	@Dependency(\.openAIClient) var openAIClient
	@Dependency(\.webScraperClient) var webScraperClient
	
	struct State: Equatable {
		@BindingState var additionalOption: AdditionalOption = .none
		@BindingState var addQuestions: [QuestionDTO] = []
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
		case addQuestions([QuestionDTO])
		case addEmptyQuestion(Int)
		case updateQuestionTitle(Int, String)
		case deleteQuestion(Int)
		case didFinishAddingQuestions
		case addQuestionCancel
		case catchError(String)
		case binding(BindingAction<State>)
		
		case delegate(DelegateAction)
		
		enum DelegateAction: Equatable {
			case dismissRequested
		}
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
				}.cancellable(id: AddQuestionFeature.CancelID.extractTextFromURL)
				
			case .extractInterviewQuestions(let texts):
				return .run { send in
					if let questions = try await openAIClient.extractInterviewQuestions(texts) {
						await send(.didFinishExtractingQuestions(questions))
					}
				} catch: { error, send in
					await send(.catchError(error.localizedDescription))
				}.cancellable(id: AddQuestionFeature.CancelID.extractInterviewQuestions)
				
			case .didFinishExtractingQuestions(let questions):
				state.isExtracting = false
				state.addQuestions = questions.split(separator: ",").map { QuestionDTO(id: nil, title: "\($0)", category: state.category) }
				return .none
				
			case .addQuestions(let questions):
				return .run { send in
					try RealmManager.shared.writeQuestions(questions)
					await send(.didFinishAddingQuestions)
				} catch: { error, send in
					await send(.catchError(RealmFailure.questionAddError.errorDescription))
				}
				
			case .addEmptyQuestion(let index):
				state.addQuestions.insert(QuestionDTO(id: nil, title: "", category: state.category), at: index + 1)
				return .none
				
			case .updateQuestionTitle(let index, let title):
				state.addQuestions[index].title = title
				return .none
				
			case .deleteQuestion(let index):
				state.addQuestions.remove(at: index)
				return .none
				
			case .didFinishAddingQuestions:
				return .send(.delegate(.dismissRequested))
				
			case .addQuestionCancel:
				return .send(.delegate(.dismissRequested))
				
			case .delegate:
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
