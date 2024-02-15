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
			.frame(maxWidth: 20, maxHeight: 20)
			.scaleEffect(scale)
			.foregroundStyle(Color.white)
			.animation(.easeInOut(duration: 0.6).repeatForever().delay(delay))
			.onAppear {
				withAnimation {
					self.scale = 1
				}
			}
	}
}
