//
//  CategoryPickerView.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI
import ComposableArchitecture

struct CategoryPickerView: View {
	@Binding var selectedCategory: String?
	var categories: [String] = []
	
	var body: some View {
		Menu {
			ForEach(categories, id: \.self) { category in
				Button {
					selectedCategory = category
				} label: {
					Text(category)
				}
			}
		} label: {
			Text(selectedCategory ?? "")
				.font(.defaultFont(.title))
		}
		.accentColor(Color.accentTextColor)
	}
}
