//
//  AddQuestionView.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI
import ComposableArchitecture

struct AddQuestionView: View {
	let store: StoreOf<AddReducer>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			VStack(alignment: .leading) {
				Text("카테고리 선택")
					.font(.title3.bold())
				Picker("카테고리를 선택해주세요.", selection: viewStore.$selectedCategory) {
					ForEach(viewStore.categories, id: \.self) {
						Text($0.rawValue)
					}
				}
				.pickerStyle(.segmented)
				.shadow(radius: 5)
				.padding(.bottom, 10)
				Text("예상 질문")
					.font(.title3.bold())
					.padding(.bottom, 10)
				TextEditor(text: viewStore.$questionTitle)
					.font(.body)
					.lineSpacing(5)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.borderColor, lineWidth: 3)
					)
				Button("추가하기") {
					viewStore.send(.addButtonTapped)
				}
				.roundedStyle(maxWidth: .infinity, maxHeight: 50, font: .title3, backgroundColor: .buttonBackgroundColor)
			}
			.onAppear {
				UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.buttonBackgroundColor)
				UISegmentedControl.appearance().backgroundColor = UIColor(Color.textBackgroundColor)
				UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
			}
			.padding(20)
		}
	}
}
