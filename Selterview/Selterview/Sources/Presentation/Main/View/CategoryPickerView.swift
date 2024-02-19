//
//  CategoryPickerView.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI
import ComposableArchitecture

struct CategoryPickerView: View {
	@Binding var selectedCategory: Category
	var categories: [Category] = [.swift, .ios, .cs]
	
	var body: some View {
		Menu {
			ForEach(categories, id: \.self) { category in
				Button {
					selectedCategory = category
				} label: {
					Text(category.rawValue)
				}
			}
		} label: {
			Text(selectedCategory.rawValue)
				.font(.defaultFont(.title))
		}
		.accentColor(Color.accentTextColor)
	}
}
