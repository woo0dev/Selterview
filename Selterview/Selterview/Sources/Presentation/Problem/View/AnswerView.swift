//
//  AnswerView.swift
//  Selterview
//
//  Created by woo0 on 2/5/24.
//

import SwiftUI

struct AnswerView: View {
	@Binding var answerText: String
	@FocusState var isFocused: Bool
	@State var placeholderText: String = "여기에 답을 작성하면 꼬리질문을 받을 수 있습니다."
	
	var body: some View {
		// TODO: longpress wanning
		ZStack {
			if answerText.isEmpty {
				TextEditor(text: $placeholderText)
					.font(.defaultLightFont(.body))
					.lineSpacing(5)
					.disabled(true)
			}
			TextEditor(text: $answerText)
				.opacity(answerText.isEmpty ? 0.25 : 1)
				.focused($isFocused)
				.lineSpacing(5)
		}
	}
}
