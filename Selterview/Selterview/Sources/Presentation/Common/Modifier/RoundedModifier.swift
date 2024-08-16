//
//  RoundedView.swift
//  Selterview
//
//  Created by woo0 on 2/14/24.
//

import SwiftUI

struct RoundedModifier: ViewModifier {
	var alignment: Alignment?
	var maxWidth: CGFloat
	var minHeight: CGFloat?
	var maxHeight: CGFloat
	var radius: CGFloat?
	var font: Font?
	var foregroundColor: Color?
	var backgroundColor: Color
	var borderColor: Color?
	
	func body(content: Content) -> some View {
		ZStack {
			RoundedRectangle(cornerRadius: radius ?? 10, style: .continuous)
				.fill(backgroundColor)
				.frame(maxWidth: maxWidth, minHeight: minHeight ?? 0, maxHeight: maxHeight, alignment: alignment ?? .center)
				.shadow(radius: 5)
				.overlay(
					RoundedRectangle(cornerRadius: radius ?? 10)
						.stroke(borderColor ?? Color.clear, lineWidth: 1)
				)
			content
				.frame(maxWidth: maxWidth, minHeight: minHeight ?? 0, maxHeight: maxHeight, alignment: alignment ?? .center)
				.font(font ?? .title)
				.foregroundStyle(foregroundColor ?? .white)
				.lineSpacing(5)
				.padding(10)
		}
	}
}
