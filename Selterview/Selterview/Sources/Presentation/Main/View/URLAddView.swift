//
//  URLAddView.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct URLAddView: View {
	let store: StoreOf<AddQuestionFeature>
	
	var body: some View {
		WithViewStore(store, observe: \.self) { viewStore in
			ZStack {
				if viewStore.isExtracting {
					ProgressView("추출 중...")
						.progressViewStyle(CircularProgressViewStyle())
				} else if viewStore.addQuestions.isEmpty {
					VStack {
						TextField("여기에 링크를 입력해주세요.", text: viewStore.$urlString)
							.roundedStyle(backgroundColor: .backgroundLightGray.opacity(0.5))
						Button(action: {
							viewStore.send(.extractTextFromURL)
						}, label: {
							Text("변환하기")
								.tint(.accentTextColor)
						})
						.roundedStyle(backgroundColor: .white, borderColor: .borderColor)
					}
					.fixedSize(horizontal: false, vertical: true)
					.padding()
				} else {
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
				}
			}
		}
	}
}

#Preview {
	URLAddView(store: Store(initialState: AddQuestionFeature.State(category: ""), reducer: { AddQuestionFeature() }))
}
