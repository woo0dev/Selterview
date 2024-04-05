//
//  QuestionDetailView.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailQuestionView: View {
	
	let store: StoreOf<DetailQuestionReducer>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack {
				HStack {
					Spacer()
					Button {
						viewStore.send(.startSpeak)
					} label: {
						Image(systemName: "speaker.wave.3")
							.symbolRenderingMode(.monochrome)
							.foregroundStyle(.white)
					}
				}
				.padding([.top, .trailing], 10)
				ScrollView {
					Text(viewStore.question.title)
				}
				.padding(10)
			}
			.roundedStyle(maxWidth: .infinity, maxHeight: .infinity, font: .defaultFont(.title2), backgroundColor: .textBackgroundLightPurple)
			.onDisappear {
				viewStore.send(.stopSpeak)
			}
			.padding(20)
		}
	}
}
