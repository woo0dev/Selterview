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
					Text(viewStore.isTailQuestionCreating ? "" : viewStore.question.title)
						.multilineTextAlignment(.center)
						.padding(.bottom, 10)
						.roundedStyle(maxWidth: .infinity, maxHeight: 150, font: .title2, backgroundColor: .mainColor.opacity(0.7))
						.showLoadingView(isLoading: viewStore.$isTailQuestionCreating, message: "질문을 생성하고 있어요. 조금만 기다려 주세요.")
					if viewStore.isTailQuestionCreating {
						Text("여기에 답을 작성하면 꼬리질문을 받을 수 있습니다.")
							.frame(maxHeight: .infinity, alignment: .top)
							.font(.body)
							.foregroundColor(.gray)
					} else {
						AnswerView(answerText: viewStore.$answerText, isFocused: _isFocused)
							.frame(maxHeight: .infinity)
					}
					HStack {
						Spacer()
						Button("꼬리질문") {
							viewStore.send(.newTailQuestionCreateButtonTapped)
						}
						.roundedStyle(maxWidth: 150, maxHeight: 50, font: .title3, backgroundColor: .mainColor)
						Spacer()
						Button("다음질문") {
							viewStore.send(.nextQuestionButtonTapped)
						}
						.roundedStyle(maxWidth: 150, maxHeight: 50, font: .title3, backgroundColor: .mainColor)
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
