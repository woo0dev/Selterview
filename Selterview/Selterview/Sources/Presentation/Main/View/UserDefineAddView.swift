//
//  UserDefineAddView.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct UserDefineAddView: View {
	let store: StoreOf<AddQuestionFeature>
	
	var body: some View {
		WithViewStore(store, observe: \.self) { viewStore in
			ScrollView {
				LazyVStack(spacing: 16) {
					ForEach(viewStore.addQuestions.indices, id: \.self) { index in
						HStack(spacing: 16) {
							Button {
								viewStore.send(.deleteQuestion(index))
							} label: {
								Image(systemName: "trash")
									.foregroundColor(.red)
									.font(.system(size: 24))
							}
							TextEditor(text: viewStore.binding(
								get: { $0.addQuestions[index].title },
								send: { .updateQuestionTitle(index, $0) }
							))
							.frame(minHeight: 80)
							.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.borderColor))
							Button {
								viewStore.send(.addEmptyQuestion(index))
							} label: {
								Image(systemName: "plus")
									.font(.system(size: 24))
							}
						}
						.padding(1)
					}
				}
			}
			.onAppear() {
				viewStore.send(.addFirstQuestion)
			}
		}
	}
}

#Preview {
	UserDefineAddView(store: Store(initialState: AddQuestionFeature.State(category: ""), reducer: { AddQuestionFeature() }))
}
