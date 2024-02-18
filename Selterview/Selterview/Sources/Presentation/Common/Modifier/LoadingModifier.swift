//
//  LoadingModifier.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
	@Binding var isLoading: Bool
	private let dotDelayMultiplyer = 2.0
	private let dotDelayValue = 0.20
	let message: String
	let maxWidth: CGFloat
	let maxHeight: CGFloat
	
	func body(content: Content) -> some View {
		ZStack {
			content
			if isLoading {
				VStack {
					Spacer()
					HStack {
						Spacer()
						DotView(delay: 0)
						DotView(delay: dotDelayValue)
						DotView(delay: dotDelayMultiplyer * dotDelayValue)
						Spacer()
					}
					.padding(.bottom, 20)
					Text(message)
						.font(.defaultFont(.body))
						.foregroundStyle(Color.white)
					Spacer()
				}
				.background(Color.clear)
			}
		}
		.frame(maxWidth: maxWidth, maxHeight: maxHeight)
	}
}
