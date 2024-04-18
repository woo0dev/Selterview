//
//  SpeechView.swift
//  Selterview
//
//  Created by woo0 on 4/18/24.
//

import SwiftUI
import ComposableArchitecture

struct SpeechView: View {
	
	let store: StoreOf<SpeechReducer>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack {
				VStack {
					Text("답변중...")
						.font(.defaultFont(.title2))
						.foregroundStyle(.white)
						.padding(10)
					Button {
						viewStore.send(.stopSpeech)
					} label: {
						Image(systemName: "stop.circle")
							.symbolRenderingMode(.monochrome)
							.font(.system(size: 50))
							.foregroundStyle(.white)
					}
					.padding([.bottom, .leading, .trailing])
				}
				.roundedStyle(maxWidth: 150, maxHeight: 150, font: .defaultFont(.title2), backgroundColor: .lightPurple)
			}
			.onAppear {
				viewStore.send(.startSpeech)
			}
		}
	}
}
