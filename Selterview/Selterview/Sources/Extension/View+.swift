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
	
	func showLoadingView(isLoading: Binding<Bool>, message: String, maxWidth: CGFloat, maxHeight: CGFloat) -> some View {
		self.modifier(LoadingModifier(isLoading: isLoading, message: message, maxWidth: maxWidth, maxHeight: maxHeight))
	}
	
	func roundedStyle(maxWidth: CGFloat, maxHeight: CGFloat, radius: CGFloat?, font: Font?, backgroundColor: Color) -> some View {
		self.modifier(RoundedModifier(maxWidth: maxWidth, maxHeight: maxHeight, radius: radius, font: font, backgroundColor: backgroundColor))
	}
	
	func roundedStyle(maxWidth: CGFloat, maxHeight: CGFloat, font: Font?, backgroundColor: Color) -> some View {
		self.modifier(RoundedModifier(maxWidth: maxWidth, maxHeight: maxHeight, font: font, backgroundColor: backgroundColor))
	}
	
	func roundedStyle(maxWidth: CGFloat, maxHeight: CGFloat, radius: CGFloat?, backgroundColor: Color) -> some View {
		self.modifier(RoundedModifier(maxWidth: maxWidth, maxHeight: maxHeight, radius: radius, backgroundColor: backgroundColor))
	}
	
	func roundedStyle(maxWidth: CGFloat, maxHeight: CGFloat, backgroundColor: Color) -> some View {
		self.modifier(RoundedModifier(maxWidth: maxWidth, maxHeight: maxHeight, backgroundColor: backgroundColor))
	}
	
	func roundedStyle(alignment: Alignment?, maxWidth: CGFloat, minHeight: CGFloat?, maxHeight: CGFloat, radius: CGFloat?, font: Font?, foregroundColor: Color?, backgroundColor: Color, borderColor: Color?) -> some View {
		self.modifier(RoundedModifier(alignment: alignment, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, radius: radius, font: font, foregroundColor: foregroundColor, backgroundColor: backgroundColor, borderColor: borderColor))
	}
	
	func showToastView(isShowToast: Binding<Bool>, message: Binding<String>) -> some View {
		self.modifier(ToastModifier(isShowToast: isShowToast, message: message))
	}
	
	func clearBackground() -> some View {
		self.modifier(ClearBackgroundViewModifier())
	}
}
