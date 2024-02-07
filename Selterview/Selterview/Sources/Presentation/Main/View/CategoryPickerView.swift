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
		Picker("카테고리를 선택해주세요.", selection: $selectedCategory) {
			ForEach(categories, id: \.self) {
				Text($0.rawValue)
			}
		}
		.pickerStyle(.menu)
		.cornerRadius(15)
	}
}
