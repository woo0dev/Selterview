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
					// TODO: 질문 카드 페이징 구현(가로)
					QuestionCard(isTailQuestionCreating: viewStore.$isTailQuestionCreating, question: viewStore.question)
						.animation(.easeIn, value: viewStore.question)
						.onTapGesture {
							viewStore.send(.showQuestionDetailView)
						}
						.gesture(DragGesture()
							.onEnded { value in
								if value.startLocation.x < value.location.x - 24 {
									viewStore.send(.previousQuestion)
								}
								if value.startLocation.x > value.location.x + 24 {
									viewStore.send(.nextQuestionButtonTapped)
								}
							}
						)
					if viewStore.isTailQuestionCreating {
						Text("여기에 답을 작성하면 꼬리질문을 받을 수 있습니다.")
							.frame(maxHeight: .infinity, alignment: .top)
							.font(.defaultFont(.body))
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
						.roundedStyle(maxWidth: 150, maxHeight: 50, font: .defaultFont(.title3), backgroundColor: .buttonBackgroundColor)
						Spacer()
						Button("다음질문") {
							viewStore.send(.nextQuestionButtonTapped)
						}
						.roundedStyle(maxWidth: 150, maxHeight: 50, font: .defaultFont(.title3), backgroundColor: .buttonBackgroundColor)
						Spacer()
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.padding(20)
				.navigationBarTitle("\(viewStore.question.category)", displayMode: .inline)
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
				.sheet(isPresented: viewStore.$isQuestionTap) {
					QuestionDetailView(questionTitle: viewStore.question.title)
				}
				.showErrorMessage(showAlert: viewStore.$isError, message: viewStore.error?.errorDescription ?? "알 수 없는 문제가 발생했습니다.")
			}
		}
	}
}
