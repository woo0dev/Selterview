//
//  MainView.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI

struct MainView: View {
	@ObservedObject var viewModel: MainViewModel = MainViewModel()
	@State var selectedCategory: Category = .swift
	
	var body: some View {
		NavigationStack {
			VStack {
				HStack {
					CategoryPickerView(selectedCategory: $selectedCategory)
						.onChange(of: selectedCategory, perform: { value in
							viewModel.changedCategory(value)
						})
						.padding(.leading, 20)
					Spacer()
					StartButtonView(viewModel: viewModel)
						.padding(.trailing, 20)
				}
				List(viewModel.filteredQuestions.indices, id: \.self) { index in
					NavigationLink(destination: ProblemView(questions: viewModel.filteredQuestions, question: viewModel.filteredQuestions[index], questionIndex: index), label: {
						Text(viewModel.filteredQuestions[index].title)
					})
				}
				.listStyle(.inset)
			}
			.toolbar(.hidden)
		}
		.onAppear {
			viewModel.viewOnAppear()
		}
	}
}
