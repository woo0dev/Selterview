//
//  QuestionView.swift
//  Selterview
//
//  Created by woo0 on 2/3/24.
//

import SwiftUI

struct QuestionView: View {
	@State var question: Question
	
	var body: some View {
		VStack {
			Text(question.title)
				.padding(10)
				.font(.system(size: 24))
		}
	}
}
