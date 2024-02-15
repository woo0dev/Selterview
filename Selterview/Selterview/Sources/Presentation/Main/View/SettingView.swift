//
//  SettingView.swift
//  Selterview
//
//  Created by woo0 on 2/15/24.
//

import SwiftUI
import Foundation

struct SettingView: View {
	@State private var isAnswerSave = UserDefaults.standard.bool(forKey:"AnswerSave")
	var body: some View {
		Toggle(isOn: $isAnswerSave) {
			Label("작성한 답변 저장하기", systemImage: "book.closed.fill")
				.foregroundStyle(Color.accentTextColor)
		}
		.tint(.accentTextColor)
		.padding(.horizontal, 20)
		.onDisappear {
			UserDefaults.standard.set(isAnswerSave, forKey: "AnswerSave")
		}
	}
}
