//
//  RoundedButtonView.swift
//  Selterview
//
//  Created by woo0 on 2/5/24.
//

import SwiftUI

struct RoundedButtonView: View {
	@Binding var questionState: QuestionState
	var state: QuestionState
	var text: String
	
	var body: some View {
		Button(action: {
			questionState = state
		}, label: {
			Text(text)
		})
		.buttonStyle(.borderedProminent)
		.controlSize(.large)
		.tint(.mainColor)
		.foregroundColor(.white)
		.font(.title3)
	}
}
