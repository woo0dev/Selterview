//
//  ProblemView.swift
//  Selterview
//
//  Created by woo0 on 2/3/24.
//

import SwiftUI
import ComposableArchitecture

struct ProblemView: View {
	@FocusState var isFocused: Bool
	
	let store: StoreOf<ProblemReducer>
	
 	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			ZStack {
				VStack {
					ScrollView() {
						Text(viewStore.isTailQuestionCreating ? "" : viewStore.question.title)
							.font(.system(size: 24))
							.showLoadingView(isLoading: viewStore.$isTailQuestionCreating)
					}
					.frame(maxWidth: .infinity, maxHeight: 150)
					.padding(10)
					AnswerView(answerText: viewStore.$answerText, isFocused: _isFocused)
						.frame(maxHeight: .infinity)
					HStack {
						Spacer()
						Button("꼬리질문") {
							viewStore.send(.newTailQuestionCreateButtonTapped)
						}
						.buttonStyle(RoundedButtonStyle())
						Spacer()
						Button("다음질문") {
							viewStore.send(.nextQuestionButtonTapped)
						}
						.buttonStyle(RoundedButtonStyle())
						Spacer()
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.padding(20)
				.navigationBarTitle("\(viewStore.question.category.rawValue)", displayMode: .inline)
				.onTapGesture {
					isFocused = false
				}
				.showErrorMessage(showAlert: viewStore.$isError, message: "꼬리 질문을 생성하지 못했습니다.\n잠시후 다시 시도해주세요.")
					.onAppear { viewStore.send(.disableError) }
			}
		}
	}
}
