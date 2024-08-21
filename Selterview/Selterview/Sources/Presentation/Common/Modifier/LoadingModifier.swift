//
//  LoadingModifier.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
	@Binding var isLoading: Bool
	
	func body(content: Content) -> some View {
		ZStack(alignment: .leading) {
			content
			if isLoading {
				SkeletonView(isLoading: isLoading)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: 150)
	}
}
