//
//  RoundedButtonView.swift
//  Selterview
//
//  Created by woo0 on 2/5/24.
//

import SwiftUI

struct RoundedButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.frame(maxWidth: 150, maxHeight: 50)
			.background(Capsule().fill(Color.mainColor))
			.foregroundColor(.white)
			.controlSize(.large)
			.font(.title3)
	}
}
