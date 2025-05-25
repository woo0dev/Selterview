//
//  WebScraperClient.swift
//  Selterview
//
//  Created by woo0 on 5/6/25.
//

import Foundation
import ComposableArchitecture
import SwiftSoup

struct WebScraperClient {
	var extractTextFromURL: (_ urlString: String) async throws -> String?
}

extension WebScraperClient: DependencyKey {
	static let liveValue = WebScraperClient(
		extractTextFromURL: { urlString in
			guard let url = URL(string: urlString) else { throw WebScraperFailure.invalidURL }
			
			func fetchAndValidate(urlRequest: URLRequest) async throws -> Data {
				let data: Data
				let response: URLResponse
				do {
					(data, response) = try await URLSession.shared.data(for: urlRequest)
				} catch let error as URLError {
					throw WebScraperFailure.networkFailure(underlying: error)
				}
				if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
					throw WebScraperFailure.httpError(statusCode: httpResponse.statusCode)
				}
				return data
			}
			
			func fetchAndValidate(from url: URL) async throws -> Data {
				try await fetchAndValidate(urlRequest: URLRequest(url: url))
			}
			
			let pathComponents = url.pathComponents
			
			if url.host == "github.com", pathComponents.count >= 5 {
				let owner = pathComponents[1]
				let repo = pathComponents[2]
				let branch = pathComponents.count > 4 ? pathComponents[4] : "main"
				
				let rawUrlString = "https://raw.githubusercontent.com/\(owner)/\(repo)/\(branch)/README.md"
				guard let rawUrl = URL(string: rawUrlString) else { throw WebScraperFailure.invalidGitHubRawURL }
				
				let data = try await fetchAndValidate(from: rawUrl)
				
				guard let content = String(data: data, encoding: .utf8) else {
					throw WebScraperFailure.invalidResponseEncoding
				}
				
				return content
			} else {
				let data = try await fetchAndValidate(from: url)
				guard let htmlString = String(data: data, encoding: .utf8) else {
					throw WebScraperFailure.invalidResponseEncoding
				}
				
				do {
					let document = try SwiftSoup.parse(htmlString)
					let elements = try document.select("h1, h2, h3, em, strong, b, li")
					let texts = try elements.map { try $0.text() }
					return texts.joined()
				} catch {
					throw WebScraperFailure.htmlParsingFailure(underlying: error)
				}
			}
		}
	)
}

extension DependencyValues {
	var webScraperClient: WebScraperClient {
		get { self[WebScraperClient.self] }
		set { self[WebScraperClient.self] = newValue }
	}
}

enum WebScraperFailure: Error {
	case invalidURL
	case invalidGitHubRawURL
	case networkFailure(underlying: URLError)
	case httpError(statusCode: Int)
	case invalidResponseEncoding
	case htmlParsingFailure(underlying: Error)
}

extension WebScraperFailure: LocalizedError {
	var errorDescription: String {
		switch self {
		case .invalidURL:
			return "유효하지 않은 URL입니다. 주소를 다시 확인해주세요."
		case .invalidGitHubRawURL:
			return "GitHub raw 파일 URL을 생성할 수 없습니다. 저장소 경로를 확인해주세요."
		case .networkFailure(let underlying):
			return "네트워크 요청 중 오류가 발생했습니다: \(underlying.localizedDescription)"
		case .httpError(let statusCode):
			return "서버가 요청을 처리하지 못했습니다. (HTTP 상태 코드: \(statusCode))"
		case .invalidResponseEncoding:
			return "서버 응답을 텍스트로 변환할 수 없습니다. 데이터 형식을 확인해주세요."
		case .htmlParsingFailure(let underlying):
			return "HTML 문서 파싱 중 오류가 발생했습니다: \(underlying.localizedDescription)"
		}
	}
}
