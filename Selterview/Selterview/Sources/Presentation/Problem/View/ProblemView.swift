//
//  ProblemView.swift
//  Selterview
//
//  Created by woo0 on 2/3/24.
//

import SwiftUI

struct ProblemView: View {
	@State var questions: [Question]
	@State var answerText: String = ""
	var questionStartIndex: Int
	
 	var body: some View {
		VStack {
			QuestionView(question: questions[questionStartIndex])
			AnswerView(answerText: $answerText)
		}
		.navigationBarTitle("\(questions[questionStartIndex].category.rawValue)", displayMode: .inline)
	}
}
