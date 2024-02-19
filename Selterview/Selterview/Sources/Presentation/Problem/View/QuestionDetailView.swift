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
		ScrollView {
			Text(questionTitle)
		}
		.roundedStyle(maxWidth: .infinity, maxHeight: .infinity, font: .defaultFont(.title2), backgroundColor: .textBackgroundColor)
		.padding(20)
	}
}
