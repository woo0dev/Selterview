//
//  ToastModifier.swift
//  Selterview
//
//  Created by woo0 on 2/26/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
	@Binding var isShowToast: Bool
	@Binding var message: String
	
	func body(content: Content) -> some View {
		VStack {
			content
			if isShowToast {
				Spacer()
				HStack(spacing: 20) {
					Image(systemName: "xmark.circle.fill")
						.foregroundStyle(.red)
						.padding(.leading, 20)
					Text(message)
						.foregroundStyle(.black)
						.padding(.trailing, 20)
					Spacer()
				}
				.frame(maxWidth: .infinity, maxHeight: 50)
				.animation(.easeInOut, value: isShowToast)
				.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						isShowToast = false
					}
				}
				.roundedStyle(maxWidth: .infinity, maxHeight: 50, font: .defaultFont(.body), backgroundColor: .gray.opacity(0.2))
				.padding(20)
			}
		}
	}
}
