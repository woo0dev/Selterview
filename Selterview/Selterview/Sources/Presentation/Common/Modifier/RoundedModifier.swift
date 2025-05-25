//
//  RoundedView.swift
//  Selterview
//
//  Created by woo0 on 2/14/24.
//

import SwiftUI

struct RoundedModifier: ViewModifier {
	var alignment: Alignment
	var radius: CGFloat
	var font: Font
	var foregroundColor: Color
	var backgroundColor: Color
	var borderColor: Color?
	
	func body(content: Content) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: radius, style: .continuous)
				.fill(backgroundColor)
				.frame(alignment: alignment)
				.overlay(
					RoundedRectangle(cornerRadius: radius)
						.stroke(borderColor ?? Color.clear, lineWidth: 1)
				)
			content
				.frame(alignment: alignment)
				.font(font)
				.foregroundStyle(foregroundColor)
				.lineSpacing(5)
				.padding(10)
		}
	}
}
