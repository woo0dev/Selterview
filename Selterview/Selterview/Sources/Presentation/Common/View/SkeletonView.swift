//
//  SkeletonView.swift
//  Selterview
//
//  Created by woo0 on 8/20/24.
//

import Foundation
import SwiftUI

struct SkeletonView: View {
	let loadingMassage: String
	let isLoading: Bool

	var body: some View {
		ZStack {
			if isLoading {
				VStack(alignment: .leading, spacing: 8) {
					Text(loadingMassage)
						.foregroundStyle(.gray.opacity(0.5))
					SkeletonBar(width: 250)
					SkeletonBar(width: 200)
					SkeletonBar(width: 150)
				}
				.padding()
				.transition(.opacity)
			}
		}
	}
}

struct SkeletonBar: View {
	@State private var isBright = true
	var width: CGFloat
	
	var body: some View {
		Rectangle()
			.frame(width: width, height: 20)
			.background(Color.gray)
			.clipShape(RoundedRectangle(cornerRadius: 4))
			.opacity(isBright ? 0.2 : 0.1)
			.animation(
				Animation.easeInOut(duration: 1.0)
					.repeatForever(autoreverses: true), value: isBright
			)
			.onAppear {
				isBright.toggle()
			}
	}
}
