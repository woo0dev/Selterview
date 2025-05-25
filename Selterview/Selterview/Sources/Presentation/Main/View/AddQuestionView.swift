//
//  AddQuestionView.swift
//  Selterview
//
//  Created by woo0 on 8/21/24.
//

import SwiftUI

struct AddQuestionView: View {
	@Binding var questions: Questions
	var category: String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(category)
				.font(Font.defaultBoldFont(.title))
				.padding([.top, .leading], 20)
			ScrollView {
				VStack(alignment: .leading, spacing: 10) {
					ForEach(0..<questions.count, id: \.self) { index in
						HStack {
							TextField("질문", text: $questions[index].title)
								.roundedStyle(alignment: .leading, maxWidth: .infinity, minHeight: nil, maxHeight: 30, radius: nil, font: .defaultLightFont(.title3), foregroundColor: .gray, backgroundColor: .white, borderColor: .accentTextColor)
								.padding(questions.count - 1 > index ? EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20) : EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
							if questions.count - 1 == index {
								Button {
									if !questions[questions.count-1].title.isEmpty {
										questions.append(Question(title: "", category: category))
									}
								} label: {
									Image(systemName: "plus")
								}
								.roundedStyle(alignment: .center, maxWidth: 30, minHeight: nil, maxHeight: 30, radius: nil, font: .defaultMidiumFont(.title3), foregroundColor: .accentTextColor, backgroundColor: .white, borderColor: .accentTextColor)
								.padding(.trailing, 10)
							}
						}
					}
				}
			}
		}
	}
}
