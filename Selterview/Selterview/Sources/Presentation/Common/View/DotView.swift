//
//  Dotview.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import SwiftUI

struct DotView: View {
	@State private var scale: CGFloat = 0.5
	private let delay: Double
	
	public init(delay: Double) {
		self.delay = delay
	}
	
	public var body: some View {
		Circle()
			.frame(maxWidth: 30, maxHeight: 30)
			.scaleEffect(scale)
			.foregroundColor(.mainColor)
			.animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay))
//			.animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay), value: true)
			.onAppear {
				withAnimation {
					self.scale = 1
				}
			}
	}
}
