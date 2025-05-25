//
//  RealmManager.swift
//  Selterview
//
//  Created by woo0 on 2/16/24.
//

import Foundation
import RealmSwift

final class RealmManager: RealmManagerProtocol {
	static let shared = RealmManager()
	
	init() {
		let config = Realm.Configuration(schemaVersion: 3)
		Realm.Configuration.defaultConfiguration = config
	}
	
	func readQuestions() throws -> [QuestionDTO]? {
		do {
			let realm = try Realm()
			let objects = realm.objects(Question.self)
			return objects.map { QuestionDTO(from: $0) }
		} catch {
			throw RealmFailure.questionsFetchError
		}
	}
	
	func writeQuestions(_ questions: [QuestionDTO]) throws {
		do {
			let realm = try Realm()
			try realm.write {
				for dto in questions {
					if !dto.title.isEmpty { realm.add(try dto.toRealmObject()) }
				}
			}
		} catch {
			throw RealmFailure.questionAddError
		}
	}
	
	func updateQuestion(_ question: QuestionDTO, _ answer: String) throws {
		do {
			let realm = try Realm()
			try realm.write {
				var updatedQuestionDTO = question
				updatedQuestionDTO.answer = answer
				let questionObject = try updatedQuestionDTO.toRealmObject()
				realm.create(Question.self, value: questionObject, update: .modified)
			}
		} catch {
			throw RealmFailure.questionUpdateError
		}
	}
	
	func deleteQuestion(_ id: String) throws {
		do {
			let realm = try Realm()
			guard let objectId = try? ObjectId(string: id) else {
				throw RealmFailure.questionDeleteError
			}
			try realm.write {
				guard let question = realm.object(ofType: Question.self, forPrimaryKey: objectId) else {
					throw RealmFailure.questionDeleteError
				}
				realm.delete(question)
			}
		} catch {
			throw RealmFailure.questionDeleteError
		}
	}
}

protocol RealmManagerProtocol {
	func readQuestions() throws -> [QuestionDTO]?
	func writeQuestions(_ questions: [QuestionDTO]) throws
	func updateQuestion(_ question: QuestionDTO, _ answer: String) throws
	func deleteQuestion(_ id: String) throws
}

enum RealmFailure: Error, Equatable {
	case realmCreationError
	case questionsFetchError
	case questionsEmpty
	case questionAddError
	case questionUpdateError
	case questionDeleteError
	case invalidObjectId
}

extension RealmFailure: LocalizedError {
	var errorDescription: String {
		switch self {
		case .realmCreationError:
			return "저장소 접속에 실패했습니다."
		case .questionsFetchError:
			return "질문을 불러올 수 없습니다."
		case .questionsEmpty:
			return "질문이 존재하지 않습니다."
		case .questionAddError:
			return "질문 생성에 실패했습니다."
		case .questionUpdateError:
			return "답변 저장을 실패했습니다."
		case .questionDeleteError:
			return "질문 삭제에 실패했습니다."
		case .invalidObjectId:
			return "잘못된 질문입니다."
		}
	}
}
