//
//  OpenAIClient.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import Foundation
import ComposableArchitecture

struct OpenAIClient {
	var fetchTailQuestion: (_ question: String, _ answer: String) async throws -> Question?
}

extension OpenAIClient: DependencyKey {
	static let liveValue = OpenAIClient(
		fetchTailQuestion: { (question, answer) in
			guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { throw ChatGPTFailure.urlConvertError }
			var message = ""
			if answer.isEmpty {
				message = "문제:\(question) 해당 문제에 대한 정답과 정답에 대한 꼬리질문을 만들어 (500토큰 이하로 사용해)"
			} else {
				message = "문제:\(question)\n답변:\(answer)\n문제와 답변을 참고해 답변에 대한 꼬리질문을 만들어 (500토큰 이하로 사용해)"
			}
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.setValue("Bearer \(Bundle.main.openAIAPIKey)", forHTTPHeaderField: "Authorization")
			
			let requestData = [
				"messages": [[ "role": "user", "content": message ]],
				"max_tokens": 500,
				"model": "gpt-3.5-turbo",
			]
			
			var networkCheckCount = 0
			NetworkCheck.shared.startMonitoring()
			
			while !NetworkCheck.shared.isConnected {
				sleep(1)
				networkCheckCount += 1
				if networkCheckCount >= 5 {
					NetworkCheck.shared.stopMonitoring()
					throw ChatGPTFailure.networkNotConnected
				}
			}
			NetworkCheck.shared.stopMonitoring()
			guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else { throw ChatGPTFailure.networkNotConnected }
			request.httpBody = jsonData
			let (response, _) = try await URLSession.shared.data(for: request)
			
			if let json = try JSONSerialization.jsonObject(with: response, options: []) as? [String: Any],
			   let choices = json["choices"] as? [[String: Any]],
			   let firstChoice = choices.first,
			   let message = firstChoice["message"] as? [String: Any],
			   let text = message["content"] as? String {
				return Question(title: text, category: "Tail")
			} else {
				throw ChatGPTFailure.jsonParsingError
			}
		})
}

extension DependencyValues {
	var openAIClient: OpenAIClient {
		get { self[OpenAIClient.self] }
		set { self[OpenAIClient.self] = newValue }
	}
}

enum ChatGPTFailure: Error {
	case urlConvertError
	case jsonParsingError
	case networkNotConnected
}

extension ChatGPTFailure: LocalizedError {
	var errorDescription: String {
		switch self {
		case .urlConvertError:
			return "꼬리 질문을 생성하지 못했습니다.\n잠시후 다시 시도해주세요."
		case .jsonParsingError:
			return "꼬리 질문을 생성하지 못했습니다.\n잠시후 다시 시도해주세요."
		case .networkNotConnected:
			return "네트워크를 연결해주세요."
		}
	}
}
