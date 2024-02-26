//
//  AddQuestionView.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI
import ComposableArchitecture

struct AddQuestionView: View {
	@Binding var isShowAddModal: Bool
	@FocusState var isFocused: Bool
	
	let store: StoreOf<AddReducer>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			VStack(alignment: .leading) {
				Menu {
					ForEach(viewStore.categories, id: \.self) { category in
						Button {
							viewStore.send(.changeCategory(category))
						} label: {
							Text(category)
						}
					}
				} label: {
					Text(viewStore.selectedCategory)
						.font(.defaultFont(.title))
				}
				.accentColor(Color.accentTextColor)
				.shadow(radius: 5)
				.padding(.bottom, 10)
				TextEditor(text: viewStore.$questionTitle)
					.font(.defaultFont(.body))
					.lineSpacing(5)
					.focused($isFocused)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.borderColor, lineWidth: 3)
					)
					.onTapGesture {
						viewStore.send(.disableFocus)
					}
					.onChange(of: viewStore.isFocused) {
						isFocused = $0
					}
					.onChange(of: isFocused) { isFocused in
						if isFocused {
							viewStore.send(.enableFocus)
						}
					}
				Button("추가하기") {
					viewStore.send(.addButtonTapped)
				}
				.roundedStyle(maxWidth: .infinity, maxHeight: 50, font: .defaultFont(.title3), backgroundColor: .buttonBackgroundColor)
			}
			.onAppear {
				viewStore.send(.fetchCategories)
				UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.buttonBackgroundColor)
				UISegmentedControl.appearance().backgroundColor = UIColor(Color.textBackgroundColor)
				UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
			}
			.padding(20)
			.showErrorMessage(showAlert: viewStore.$isError, message: viewStore.error?.errorDescription ?? "알 수 없는 문제가 발생했습니다.")
			.showToastView(isShowToast: viewStore.$isShowToast, message: "카테고리를 먼저 추가해주세요.")
			.onChange(of: viewStore.isComplete) { isComplete in
				if isComplete {
					isShowAddModal = false
				}
			}
		}
	}
}
