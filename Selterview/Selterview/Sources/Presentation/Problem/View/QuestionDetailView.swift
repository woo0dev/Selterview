//
//  QuestionDetailView.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI

struct QuestionDetailView: View {
	let questionTitle: String
	
	var body: some View {
		VStack {
			Text(questionTitle)
				.roundedStyle(maxWidth: .infinity, maxHeight: .infinity, font: .title2, backgroundColor: .mainColor.opacity(0.7))
				.padding(20)
		}
	}
}
