//
//  Question.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import Foundation

struct Question: Identifiable, Hashable {
	var id: Int
	var title: String
	var category: Category
	var tails: [Question]
}

enum Category: String {
	case swift = "Swift"
	case ios = "iOS"
	case cs = "CS"
}
