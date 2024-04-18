//
//  RoundedView.swift
//  Selterview
//
//  Created by woo0 on 2/14/24.
//

import SwiftUI

struct RoundedModifier: ViewModifier {
	var maxWidth: CGFloat
	var maxHeight: CGFloat
	var radius: CGFloat?
	var font: Font?
	var backgroundColor: Color
	
	func body(content: Content) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: radius ?? 10, style: .continuous)
				.fill(backgroundColor)
				.frame(maxWidth: maxWidth, maxHeight: maxHeight)
				.shadow(radius: 5)
			content
				.frame(maxWidth: maxWidth, maxHeight: maxHeight)
				.font(font ?? .title)
				.foregroundStyle(.white)
				.padding(5)
		}
	}
}
