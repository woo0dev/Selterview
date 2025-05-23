//
//  View+.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import SwiftUI

extension View {
	func showErrorMessage(showAlert: Binding<Bool>, message: String) -> some View {
		self.modifier(ErrorAlertModifier(isPresented: showAlert, message: message))
	}
	
	func showLoadingView(isLoading: Binding<Bool>) -> some View {
		self.modifier(LoadingModifier(isLoading: isLoading))
	}
	
	func roundedStyle(alignment: Alignment = .center, radius: CGFloat = 10, font: Font = .defaultMidiumFont(.body), foregroundColor: Color = .primary, backgroundColor: Color = .clear, borderColor: Color = .clear) -> some View {
		self.modifier(RoundedModifier(alignment: alignment, radius: radius, font: font, foregroundColor: foregroundColor, backgroundColor: backgroundColor, borderColor: borderColor))
	}
	
	func showToastView(isShowToast: Binding<Bool>, message: Binding<String>) -> some View {
		self.modifier(ToastModifier(isShowToast: isShowToast, message: message))
	}
	
	func clearBackground() -> some View {
		self.modifier(ClearBackgroundViewModifier())
	}
}
