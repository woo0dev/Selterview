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
}

enum Category: String {
	case all = "전체"
	case swift = "Swift"
	case ios = "iOS"
	case cs = "CS"
	case tail = "꼬리질문"
}

typealias Questions = [Question]
