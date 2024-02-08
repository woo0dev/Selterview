//
//  ErrorAlertModifier.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
	var isPresented: Binding<Bool>
	let message: String

	func body(content: Content) -> some View {
		content.alert(isPresented: isPresented) {
			Alert(title: Text("생성 실패"),
				  message: Text(message),
				  dismissButton: .cancel(Text("확인")))
		}
	}
}
