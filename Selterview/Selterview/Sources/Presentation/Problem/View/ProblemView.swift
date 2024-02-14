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
							.showLoadingView(isLoading: viewStore.$isTailQuestionCreating, message: "질문을 생성하고 있어요. 조금만 기다려 주세요.")
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
					viewStore.send(.disableAnswerFocus)
				}
				.onChange(of: viewStore.isFocusedAnswer) {
					isFocused = $0
				}
				.onChange(of: isFocused) { isFocused in
					if isFocused {
						viewStore.send(.enableAnswerFocus)
					}
				}
				.showErrorMessage(showAlert: viewStore.$isError, message: "꼬리 질문을 생성하지 못했습니다.\n잠시후 다시 시도해주세요.")
					.onAppear { viewStore.send(.disableError) }
			}
		}
	}
}
