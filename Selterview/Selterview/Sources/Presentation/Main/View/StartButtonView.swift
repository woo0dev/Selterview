//
//  StartButtonView.swift
//  Selterview
//
//  Created by woo0 on 2/3/24.
//

import SwiftUI

struct StartButtonView: View {
	@ObservedObject var viewModel: MainViewModel
	@State var questions: [Question] = []
	
	var body: some View {
		NavigationLink(destination: ProblemView(questions: questions, question: questions.isEmpty ? Question(id: 0, title: "", category: .swift, tails: []) : questions[0], questionIndex: 0), label: {
			Text("랜덤 시작")
		})
		.onAppear {
			questions = Set(viewModel.filteredQuestions).map { $0 }
		}
	}
}
