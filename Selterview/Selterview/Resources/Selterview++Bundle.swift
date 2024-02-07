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
		guard let key = resource["NMFClientId"] as? String else { fatalError("API_Key.plist에 NMFClientId를 입력해주세요.")}
		return key
	}
}
