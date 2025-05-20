//
//  AddOptionView.swift
//  Selterview
//
//  Created by woo0 on 4/22/25.
//

import SwiftUI
import ComposableArchitecture

struct AddOptionView: View {
	let store: StoreOf<AddQuestionFeature>
	
	var body: some View {
		WithViewStore(store, observe: \.self) { viewStore in
			GeometryReader { geometry in
				let totalPadding: CGFloat = 150
				let squareSize = max((geometry.size.width - totalPadding) / 2, 50)
				VStack {
					Spacer()
					HStack {
						Spacer()
						Button(action: {
							viewStore.send(.didSelectAddOption(.url))
						}, label: {
							Text("링크로 추가하기")
								.frame(width: squareSize, height: squareSize)
								.font(.defaultMidiumFont(.title))
						})
						.tint(.accentTextColor)
						.buttonStyle(.bordered)
						Spacer()
						Button(action: {
							viewStore.send(.didSelectAddOption(.userDefined))
						}, label: {
							Text("직접 추가하기")
								.frame(width: squareSize, height: squareSize)
								.font(.defaultMidiumFont(.title))
						})
						.tint(.accentTextColor)
						.buttonStyle(.bordered)
						Spacer()
					}
					Spacer()
				}
			}
		}
	}
}
