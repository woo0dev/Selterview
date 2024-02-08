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
					Text("질문을 생성하고 있어요. 조금만 기다려 주세요.")
					Spacer()
				}
				.background(Color.clear)
			}
		}
	}
}
