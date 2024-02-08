//
//  API_Key.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import Foundation

extension Bundle {
	var openAIAPIKey: String {
		guard let file = self.path(forResource: "API_Key", ofType: "plist") else { return "" }
		
		guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
		guard let key = resource["OpenAIAPIKey"] as? String else { fatalError("API_Key.plist에 OpenAIAPIKey를 등록해주세요.")}
		return key
	}
}
