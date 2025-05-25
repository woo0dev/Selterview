//
//  URLAddView.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct URLAddView: View {
	let viewStore: ViewStoreOf<AddQuestionFeature>
	
	var body: some View {
		ZStack {
			if viewStore.isExtracting {
				ProgressView("추출 중...")
					.progressViewStyle(CircularProgressViewStyle())
			} else if viewStore.addQuestions.isEmpty {
				VStack(spacing: 20) {
					TextField(text: viewStore.$urlString, label: {
						Text("여기에 링크를 입력해주세요.")
					})
					.roundedStyle(maxWidth: .infinity, maxHeight: 50, font: .title3, backgroundColor: .backgroundLightGray)
					Button(action: {
						viewStore.send(.extractTextFromURL)
					}, label: {
						Text("변환하기")
					})
					.roundedStyle(maxWidth: .infinity, maxHeight: 50, backgroundColor: .buttonBackgroundColor)
				}
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
