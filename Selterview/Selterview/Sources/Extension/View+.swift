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
	
	func showLoadingView(isLoading: Binding<Bool>, message: String) -> some View {
		self.modifier(LoadingModifier(isLoading: isLoading, message: message))
	}
}
