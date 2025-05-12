//
//  URLAddView.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct URLAddView: View {
	let viewStore: ViewStoreOf<AddQuestionReducer>
	
	var body: some View {
		ZStack {
			if viewStore.isExtracting {
				ProgressView("추출 중...")
					.progressViewStyle(CircularProgressViewStyle())
			} else {
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
			}
		}
	}
}
