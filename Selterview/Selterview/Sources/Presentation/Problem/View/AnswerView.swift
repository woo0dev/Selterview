//
//  AnswerView.swift
//  Selterview
//
//  Created by woo0 on 2/5/24.
//

import SwiftUI

struct AnswerView: View {
	@State var placeholderText: String = "여기에 답을 작성하면 꼬리질문을 받을 수 있습니다."
	@Binding var answerText: String
	@FocusState var isFocused: Bool
	
	var body: some View {
		if answerText.isEmpty {
			TextEditor(text: $placeholderText)
				.foregroundColor(.gray)
				.multilineTextAlignment(.center)
				.focused($isFocused)
		} else {
			TextEditor(text: $answerText)
				.multilineTextAlignment(.center)
				.focused($isFocused)
		}
	}
}
