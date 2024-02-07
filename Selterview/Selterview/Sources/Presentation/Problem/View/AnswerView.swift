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
		ZStack {
			if answerText.isEmpty {
				TextEditor(text: $placeholderText)
					.font(.body)
					.foregroundColor(.gray)
					.disabled(true)
					.padding()
			}
			TextEditor(text: $answerText)
				.font(.body)
				.opacity(answerText.isEmpty ? 0.25 : 1)
				.padding()
				.focused($isFocused)
		}
	}
}
