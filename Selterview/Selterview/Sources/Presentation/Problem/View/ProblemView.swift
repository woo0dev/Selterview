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
			VStack {
				Text(viewStore.question.title)
					.padding(10)
					.font(.system(size: 24))
					.padding(.top, 20)
				AnswerView(answerText: viewStore.$answerText, isFocused: _isFocused)
					.frame(maxHeight: .infinity)
					.padding(.top, 20)
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
		}
	}
}
