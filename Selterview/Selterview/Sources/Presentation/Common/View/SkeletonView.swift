//
//  SkeletonView.swift
//  Selterview
//
//  Created by woo0 on 8/20/24.
//

import Foundation
import SwiftUI

struct SkeletonView: View {
	let isLoading: Bool

	var body: some View {
		ZStack {
			if isLoading {
				VStack(alignment: .leading, spacing: 8) {
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

//struct SkeletonBar: View {
//	@State private var startPoint: CGFloat = -1.0
//	
//	var body: some View {
//		GeometryReader { geometry in
//			ZStack {
//				Rectangle()
//					.fill(Color.gray.opacity(0.3))
//					.cornerRadius(4)
//				LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1), Color.gray.opacity(0.3)]), startPoint: .leading, endPoint: .trailing)
//					.frame(width: 70)
//					.offset(x: startPoint * geometry.size.width)
//					.mask(
//						Rectangle()
//							.frame(width: geometry.size.width, height: geometry.size.height)
//					)
//					.animation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false), value: startPoint)
//					.onAppear {
//						self.startPoint = 1.0
//					}
//			}
//		}
//	}
//}
