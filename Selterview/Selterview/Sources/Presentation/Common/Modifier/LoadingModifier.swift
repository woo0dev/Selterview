//
//  LoadingModifier.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
	@Binding var isLoading: Bool
	
	let loadingMassage: String
	
	func body(content: Content) -> some View {
		ZStack(alignment: .leading) {
			content
			if isLoading {
				SkeletonView(loadingMassage: loadingMassage, isLoading: isLoading)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: 150)
	}
}
