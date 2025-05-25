//
//  QuestionCard.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI

struct QuestionCard: View {
	@Binding var isTailQuestionCreating: Bool
	var question: Question
	
	var body: some View {
		VStack {
			if !isTailQuestionCreating {
				Text("\(question.title)")
					.lineSpacing(5)
			}
		}
		.roundedStyle(
			alignment: .topLeading,
			radius: 20,
			font: .defaultMidiumFont(.body),
			foregroundColor: .black,
			backgroundColor: .clear,
			borderColor: .accentTextColor
		)
		.showLoadingView(isLoading: $isTailQuestionCreating, loadingMassage: "질문을 생성하는 중입니다.")
	}
}
