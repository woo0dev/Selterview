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
					QuestionCard(isTailQuestionCreating: viewStore.$isTailQuestionCreating, question: viewStore.question)
						.animation(.easeIn, value: viewStore.question)
						.onTapGesture {
							viewStore.send(.stopSpeak)
							if viewStore.isTailQuestionCreating == false {
								viewStore.send(.showQuestionDetailView)
							}
						}
					AnswerView(answerText: viewStore.$answerText, isFocused: _isFocused)
						.roundedStyle(
							alignment: .topLeading,
							maxWidth: .infinity,
							minHeight: 100,
							maxHeight: .infinity,
							radius: 20,
							font: .defaultLightFont(.body),
							foregroundColor: .black,
							backgroundColor: .clear,
							borderColor: .accentTextColor
						)
						.animation(.easeIn, value: viewStore.question)
					FooterView(viewStore: viewStore)
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
					if !viewStore.isTailQuestionCreating {
						Button {
							viewStore.send(.startSpeak)
						} label: {
							Image(systemName: "speaker.wave.3")
								.symbolRenderingMode(.monochrome)
								.foregroundStyle(Color.accentTextColor)
						}
					}
				}
				.padding(30)
			}
			.onAppear {
				viewStore.send(.onAppear)
			}
			.onDisappear {
				viewStore.send(.questionSave(viewStore.question, viewStore.answerText))
				viewStore.send(.onDisappear)
				viewStore.send(.stopSpeak)
			}
			.fullScreenCover(isPresented: viewStore.$isSpeech) {
				SpeechView(isSpeech: viewStore.$isSpeech, store: self.store.scope(state: \.speechState, action: \.speechAction))
					.clearBackground()
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
			.showToastView(isShowToast: viewStore.$isShowToast, message: viewStore.$toastMessage)
		}
	}
}

private struct FooterView: View {
	let viewStore: ViewStoreOf<ProblemReducer>
	
	var body: some View {
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
}
