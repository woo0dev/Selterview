//
//  QuestionCard.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI

struct QuestionCard: View {
	@Binding var isTailQuestionCreating: Bool
	var question: QuestionDTO
	
	var body: some View {
		Text(isTailQuestionCreating ? "질문을 생성하고 있습니다." : "질문:\n\(question.title)")
			.lineSpacing(5)
			.opacity(isTailQuestionCreating ? 0.3 : 1)
			.roundedStyle(
				alignment: .topLeading,
				maxWidth: .infinity,
				minHeight: 100,
				maxHeight: 200,
				radius: 20,
				font: .defaultMidiumFont(.body),
				foregroundColor: .black,
				backgroundColor: .clear,
				borderColor: .accentTextColor
			)
			.padding(.bottom, 20)
			.showLoadingView(isLoading: $isTailQuestionCreating)
	}
}
