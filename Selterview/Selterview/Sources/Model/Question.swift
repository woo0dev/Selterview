//
//  Question.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import Foundation
import RealmSwift

final class Question: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var _id: ObjectId
	@Persisted var title: String
	@Persisted var category: Category.RawValue
	
	init(id: ObjectId, title: String, category: Category) {
		super.init()
		self._id = id
		self.title = title
		self.category = category.rawValue
	}
}

enum Category: String {
	case swift = "Swift"
	case ios = "iOS"
	case cs = "CS"
	case tail = "꼬리질문"
}

typealias Questions = [Question]
