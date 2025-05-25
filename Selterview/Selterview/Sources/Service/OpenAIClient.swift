//
//  OpenAIClient.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import Foundation
import ComposableArchitecture

struct OpenAIClient {
	var fetchTailQuestion: (_ question: String, _ answer: String) async throws -> QuestionDTO?
	var extractInterviewQuestions: (_ fromURL: String) async throws -> String?
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
				"model": "gpt-4o",
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
				return QuestionDTO(id: nil, title: text, category: "Tail")
			} else {
				throw ChatGPTFailure.jsonParsingError
			}
		},
		extractInterviewQuestions: { texts in
			guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { throw ChatGPTFailure.urlConvertError }
			var message = "\(texts)\n위 내용에서 최대한 많은 질문들을 추출해서 쉼표(,)를 활용해서 문자열로 만들어줘(만약 앞에 문제 번호가 있다면 번호를 제거해줘, 사족도 제거)\n만약 어떤 텍스트 앞에 숫자로 리스트되어 있다면 해당 텍스트만 쉼표(,)를 활용해서 문자열로 만들어줘. 번호 리스트가 따로 없다면 네가 판단해서 문제 같은 텍스트만 추출\n질문은 보통 마침표(.)나 물음표(?)로 끝나\n질문은 문장 단위로 되어있어\n한국어로"
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			request.setValue("Bearer \(Bundle.main.openAIAPIKey)", forHTTPHeaderField: "Authorization")
			
			let requestData = [
				"messages": [["role": "system", "content": "너는 HTML로 크롤링한 콘텐츠에서 '질문'만 정확히 추출하여 깔끔하게 가공하는 전문가야. 출력 형식은 '질문1, 질문2, 질문3, ...' 처럼 쉼표로만 구분된 하나의 문자열이야. 질문이 아닌 문장은 모두 제거해. 질문은 반드시 물음표(?)로 끝나는 문장만 인정해. 질문이 여러 줄로 나뉘었으면 하나로 자연스럽게 이어 붙여. 숫자, 기호, 태그, 줄바꿈, 목록 기호 등은 모두 무시하고 질문 텍스트만 깔끔하게 남겨."],
					["role": "user", "content": "다음 텍스트에서 질문만 추출해서 쉼표로 구분한 하나의 문자열로 만들어줘:\n\n\(texts)"]],
				"max_tokens": 2000,
				"model": "gpt-4o",
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
				return text
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
