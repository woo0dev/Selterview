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
			ZStack(alignment: .topTrailing) {
				VStack {
					// TODO: 질문 카드 페이징 구현(가로)
					QuestionCard(isTailQuestionCreating: viewStore.$isTailQuestionCreating, question: viewStore.question)
						.animation(.easeIn, value: viewStore.question)
						.onTapGesture {
							viewStore.send(.stopSpeak)
							if viewStore.isTailQuestionCreating == false {
								viewStore.send(.showQuestionDetailView)
							}
						}
						.gesture(
							DragGesture()
							.onEnded { value in
								viewStore.send(.stopSpeak)
								if viewStore.answerText.count > 0 {
									viewStore.send(.questionSave(viewStore.question, viewStore.answerText))
								}
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
							.font(.defaultMidiumFont(.body))
							.foregroundColor(.gray)
							.lineSpacing(5)
							.animation(.easeIn, value: viewStore.question)
					} else {
						AnswerView(answerText: viewStore.$answerText, isFocused: _isFocused)
							.frame(maxHeight: .infinity)
							.animation(.easeIn, value: viewStore.question)
					}
					HStack {
						Spacer()
						Button("꼬리질문") {
							viewStore.send(.stopSpeak)
							if viewStore.answerText.count > 0 {
								viewStore.send(.questionSave(viewStore.question, viewStore.answerText))
							}
							viewStore.send(.newTailQuestionCreateButtonTapped)
						}
						.roundedStyle(maxWidth: 150, maxHeight: 50, font: .defaultMidiumFont(.title3), backgroundColor: .buttonBackgroundColor)
						Spacer()
						Button {
							viewStore.send(.startSpeechButtonTapped)
						} label: {
							Image(systemName: "mic")
								.symbolRenderingMode(.monochrome)
						}
						.roundedStyle(maxWidth: 50, maxHeight: 50, radius: 25, backgroundColor: .textBackgroundLightPurple)
						Spacer()
						Button("다음질문") {
							viewStore.send(.stopSpeak)
							if viewStore.answerText.count > 0 {
								viewStore.send(.questionSave(viewStore.question, viewStore.answerText))
							}
							viewStore.send(.nextQuestionButtonTapped)
						}
						.roundedStyle(maxWidth: 150, maxHeight: 50, font: .defaultMidiumFont(.title3), backgroundColor: .buttonBackgroundColor)
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
					DetailQuestionView(store: Store(initialState: DetailQuestionReducer.State(question: viewStore.question), reducer: {
						DetailQuestionReducer()
					}))
				}
				HStack {
					Button {
						viewStore.send(.startSpeak)
					} label: {
						Image(systemName: "speaker.wave.3")
							.symbolRenderingMode(.monochrome)
							.foregroundStyle(.white)
					}
				}
				.padding(30)
			}
			.onAppear {
				viewStore.send(.startNetworkCheck)
			}
			.onDisappear {
				viewStore.send(.questionSave(viewStore.question, viewStore.answerText))
				viewStore.send(.stopSpeak)
				viewStore.send(.stopNetworkCheck)
			}
			.fullScreenCover(isPresented: viewStore.$isSpeech) {
				SpeechView(isSpeech: viewStore.$isSpeech, store: self.store.scope(state: \.speechState, action: \.speechAction))
					.clearBackground()
			}
			.showToastView(isShowToast: viewStore.$isShowToast, message: viewStore.$toastMessage)
		}
	}
}
