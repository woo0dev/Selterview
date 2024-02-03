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
		VStack {
			CategoryPickerView(selectedCategory: $selectedCategory)
				.onChange(of: selectedCategory, perform: { value in
					viewModel.changedCategory(value)
				})
			NavigationView {
				List(viewModel.filteredQuestions) { question in
					Text(question.title)
				}
				.listStyle(.inset)
			}
		}
		.onAppear {
			viewModel.viewOnAppear()
		}
	}
}
