//
//  QuestionDTO.swift
//  Selterview
//
//  Created by woo0 on 5/19/25.
//

import Foundation
import RealmSwift

struct QuestionDTO: Identifiable, Equatable, Codable {
	let id: String?
	var title: String
	var category: String
	var answer: String?
}

extension QuestionDTO {
	init(from question: Question) {
		self.id = question._id.stringValue
		self.title = question.title
		self.category = question.category
		self.answer = question.answer
	}

	func toRealmObject() throws -> Question {
		let question = Question(title: title, category: category)
		
		if let idStr = id, let objectId = try? ObjectId(string: idStr) {
			question._id = objectId
		}
		
		question.answer = answer
		return question
	}
}
