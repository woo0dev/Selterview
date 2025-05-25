//
//  AddQuestionView.swift
//  Selterview
//
//  Created by woo0 on 8/21/24.
//

import SwiftUI
import ComposableArchitecture

struct AddQuestionView: View {
	let store: StoreOf<AddQuestionFeature>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack {
				HStack {
					Text(viewStore.category)
						.font(Font.defaultBoldFont(.title))
						.padding(.vertical, 20)
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
				Spacer()
				if viewStore.additionalOption == .none {
					AddOptionView(viewStore: viewStore)
				} else if viewStore.additionalOption == .url {
					URLAddView(viewStore: viewStore)
				} else {
					UserDefineAddView(viewStore: viewStore)
				}
				Spacer()
			}
		}
		.padding(.horizontal, 20)
	}
}
