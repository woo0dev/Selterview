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
	@Persisted var category: String
	@Persisted var answer: String?
	
	convenience init(title: String, category: String) {
		self.init()
		self._id = ObjectId.generate()
		self.title = title
		self.category = category
		self.answer = nil
	}
}

typealias Questions = [Question]
