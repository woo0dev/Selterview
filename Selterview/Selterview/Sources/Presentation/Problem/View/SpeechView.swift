//
//  SpeechView.swift
//  Selterview
//
//  Created by woo0 on 4/18/24.
//

import SwiftUI
import ComposableArchitecture

struct SpeechView: View {
	@Binding var isSpeech: Bool
	
	let store: StoreOf<SpeechFeature>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack {
				VStack {
					Text("답변중...")
						.font(.defaultMidiumFont(.title2))
						.foregroundStyle(.white)
						.lineSpacing(5)
						.padding(10)
					Button {
						viewStore.send(.stopSpeech)
						isSpeech = false
					} label: {
						Image(systemName: "stop.circle")
							.symbolRenderingMode(.monochrome)
							.font(.system(size: 50))
							.foregroundStyle(.white)
					}
					.padding([.bottom, .leading, .trailing])
				}
				.roundedStyle(font: .defaultMidiumFont(.title2), backgroundColor: .lightPurple)
			}
			.onAppear {
				viewStore.send(.startSpeech)
			}
		}
	}
}
