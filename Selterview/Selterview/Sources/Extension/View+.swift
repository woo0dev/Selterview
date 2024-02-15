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
	
	func roundedStyle(maxWidth: CGFloat, maxHeight: CGFloat, font: Font, backgroundColor: Color) -> some View {
		self.modifier(RoundedModifier(maxWidth: maxWidth, maxHeight: maxHeight, font: font, backgroundColor: backgroundColor))
	}
}
