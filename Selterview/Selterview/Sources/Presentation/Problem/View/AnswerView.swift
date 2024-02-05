//
//  AnswerView.swift
//  Selterview
//
//  Created by woo0 on 2/5/24.
//

import SwiftUI

struct AnswerView: View {
	@Binding var answerText: String
	
	var body: some View {
		TextField(text: $answerText, label: {
			Text("여기에 답을 작성하면 꼬리질문을 받을 수 있습니다.")
		})
		.multilineTextAlignment(.center)
	}
}
