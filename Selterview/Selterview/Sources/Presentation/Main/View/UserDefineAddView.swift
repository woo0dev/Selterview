//
//  UserDefineAddView.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct UserDefineAddView: View {
	let viewStore: ViewStoreOf<AddQuestionFeature>
	
	var body: some View {
		ScrollView {
			LazyVStack(spacing: 16) {
				ForEach(viewStore.addQuestions.indices, id: \.self) { index in
					HStack {
						TextEditor(text: viewStore.binding(
							get: { $0.addQuestions[index].title },
							send: { .updateQuestionTitle(index, $0) }
						))
						.frame(minHeight: 80)
						.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
						HStack {
							Button {
								viewStore.send(.deleteQuestion(index))
							} label: {
								Image(systemName: "trash")
									.foregroundColor(.red)
							}
							Button {
								viewStore.send(.addEmptyQuestion(index))
							} label: {
								Image(systemName: "plus")
							}
						}
					}
				}
			}
		}
		.onAppear() {
			viewStore.send(.addFirstQuestion)
		}
	}
}
