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
			ZStack {
				HStack(spacing: 20) {
					Button(action: {
						viewStore.send(.didSelectAddOption(.url))
					}, label: {
						ZStack {
							Circle()
								.foregroundStyle(Color(.systemBackground))
								.overlay(content: {
									Circle()
										.stroke(Color.accentTextColor, lineWidth: 2)
								})
							Text("링크로\n추가하기")
								.font(.defaultMidiumFont(.title))
								.tint(.accentTextColor)
						}
					})
					Button(action: {
						viewStore.send(.didSelectAddOption(.userDefined))
					}, label: {
						ZStack {
							Circle()
								.foregroundStyle(Color(.systemBackground))
								.overlay(content: {
									Circle()
										.stroke(Color.accentTextColor, lineWidth: 2)
								})
							Text("직접\n추가하기")
								.font(.defaultMidiumFont(.title))
								.tint(.accentTextColor)
						}
					})
				}
				.padding(20)
			}
		}
	}
}

#Preview {
	AddOptionView(store: Store(initialState: AddQuestionFeature.State(category: ""), reducer: { AddQuestionFeature() }))
}
