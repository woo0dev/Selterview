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
		Text(isTailQuestionCreating ? "" : question.title)
			.multilineTextAlignment(.center)
			.roundedStyle(maxWidth: .infinity, maxHeight: 150, font: .defaultFont(.title2), backgroundColor: .textBackgroundColor)
			.padding(.bottom, 20)
			.showLoadingView(isLoading: $isTailQuestionCreating, message: "질문을 생성하고 있어요. 조금만 기다려 주세요.", maxWidth: .infinity, maxHeight: 150)
	}
}
