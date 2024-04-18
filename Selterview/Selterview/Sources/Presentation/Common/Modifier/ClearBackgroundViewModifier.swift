//
//  ClearBackgroundViewModifier.swift
//  Selterview
//
//  Created by woo0 on 4/18/24.
//

import SwiftUI

struct ClearBackgroundViewModifier: ViewModifier {
	func body(content: Content) -> some View {
		if #available(iOS 16.4, *) {
			content
				.presentationBackground(.clear)
		} else {
			content
				.background(ClearBackgroundView())
		}
	}
}
