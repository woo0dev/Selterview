//
//  ProblemView.swift
//  Selterview
//
//  Created by woo0 on 2/3/24.
//

import SwiftUI

struct ProblemView: View {
	@FocusState var isFocused: Bool
	@State var answerText: String = ""
	@State var questions: [Question]
	@State var question: Question
	@State var questionState: QuestionState = .ing
	@State var questionIndex: Int
	
 	var body: some View {
		VStack {
			QuestionView(question: questions[questionIndex])
				.padding(.top, 20)
			AnswerView(answerText: $answerText, isFocused: _isFocused)
				.frame(maxHeight: .infinity)
				.padding(.top, 20)
			HStack {
				RoundedButtonView(questionState: $questionState, state: .newTail, text: "꼬리질문")
					.padding(.leading, 10)
				RoundedButtonView(questionState: $questionState, state: .next, text: "다음문제")
					.padding(.trailing, 10)
			}
			.padding(.top, 10)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.padding(20)
		.navigationBarTitle("\(questions[questionIndex].category.rawValue)", displayMode: .inline)
		.onTapGesture {
			isFocused = false
		}
		.onChange(of: questionState, perform: { state in
			if state == .next {
				if questionIndex + 1 >= questions.count {
					questionIndex = 0
				} else {
					questionIndex += 1
				}
				questionState = .ing
				question = questions[questionIndex]
			} else if state == .newTail {
				// TODO: chatGPT 연동 작업
				questionState = .ing
			}
		})
	}
}
