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
			.frame(width: 150, height: 40)
			.background(Color.mainColor)
			.foregroundColor(.white)
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
			.font(.title3)
		
	}
}
