//
//  AddQuestionView.swift
//  Selterview
//
//  Created by woo0 on 8/21/24.
//

import SwiftUI

struct AddQuestionView: View {
	@Binding var questions: Questions
	var category: String
	
	var body: some View {
		WithViewStore(store, observe: \.self) { viewStore in
			VStack {
				HStack {
					Text(viewStore.category)
						.font(Font.defaultBoldFont(.title))
					Spacer()
					Button(action: {
						viewStore.send(.addQuestionCancel)
					}, label: {
						Text("취소")
					})
					Button(action: {
						viewStore.send(.addQuestions(viewStore.addQuestions))
					}, label: {
						Text("완료")
					})
				}
				.padding(.vertical, 20)
				Spacer()
				if viewStore.additionalOption == .none {
					AddOptionView(store: store)
				} else if viewStore.additionalOption == .url {
					URLAddView(store: store)
				} else {
					UserDefineAddView(store: store)
				}
				Spacer()
			}
		}
	}
}

#Preview {
	AddQuestionView(store: Store(initialState: AddQuestionFeature.State(category: ""), reducer: { AddQuestionFeature() }))
}
