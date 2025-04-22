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
		VStack {
			TextField(text: viewStore.$urlString, label: {
				Text("여기에 링크를 입력해주세요.")
			})
			Button(action: {
				viewStore.send(.test)
			}, label: {
				Text("변환하기")
					.font(.defaultMidiumFont(.title3))
			})
			.tint(.accentTextColor)
			.buttonStyle(.bordered)
		}
	}
}
