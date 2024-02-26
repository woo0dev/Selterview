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
				// TODO: 카테고리 선택 픽커를 메뉴로 변경, 디폴트를 카테고리 선택으로. 추가 버튼 클릭 시 카테고리 선택이면 토스트메세지 출력
				Text("카테고리 선택")
					.font(.defaultFont(.title2))
				Picker("카테고리를 선택해주세요.", selection: viewStore.$selectedCategory) {
					ForEach(viewStore.categories ?? [], id: \.self) {
						Text($0)
							.font(.defaultFont(.body))
					}
				}
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
				UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.buttonBackgroundColor)
				UISegmentedControl.appearance().backgroundColor = UIColor(Color.textBackgroundColor)
				UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
			}
			.padding(20)
			.showErrorMessage(showAlert: viewStore.$isError, message: viewStore.error?.errorDescription ?? "알 수 없는 문제가 발생했습니다.")
			.onChange(of: viewStore.isComplete) { isComplete in
				if isComplete {
					isShowAddModal = false
				}
			}
		}
	}
}
