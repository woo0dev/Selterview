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
	private(set) var realm: Realm?
	
	private init() {
		openRealm()
	}
	
	func openRealm() {
		do {
			let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
				if oldSchemaVersion > 1 {
					// Do something, usually updating the schema's variables here
				}
			})

			Realm.Configuration.defaultConfiguration = config

			realm = try Realm()
		} catch {
			print("저장소에 문제가 발생했습니다.", error)
		}
	}
	
	func readQuestions() throws -> Questions? {
		guard let questions: Questions = realm?.objects(Question.self).map({ $0 }) else { throw RealmFailure.questionsFetchError }
		if questions.isEmpty {
			throw RealmFailure.questionsEmpty
		}
		return questions
	}
	
	func writeQuestion(_ question: Question) throws {
		do {
			try realm?.write {
				realm?.add(question, update: .modified)
			}
		} catch {
			throw RealmFailure.questionAddError
		}
	}
	
	func deleteQuestion(_ question: Question) throws {
		do {
			try realm?.write {
				realm?.delete(question)
			}
		} catch {
			throw RealmFailure.questionDeleteError
		}
	}
}

protocol RealmManagerProtocol {
	func readQuestions() throws -> Questions?
	func writeQuestion(_ question: Question) throws
	func deleteQuestion(_ question: Question) throws
}

enum RealmFailure: Error, Equatable {
	case realmCreationError
	case questionsFetchError
	case questionsEmpty
	case questionAddError
	case questionDeleteError
}

extension RealmFailure: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .realmCreationError:
			return "저장소 접속에 실패했습니다."
		case .questionsFetchError:
			return "질문을 불러올 수 없습니다."
		case .questionsEmpty:
			return "질문이 존재하지 않습니다."
		case .questionAddError:
			return "질문 생성에 실패했습니다."
		case .questionDeleteError:
			return "질문 삭제에 실패했습니다."
		}
	}
}
