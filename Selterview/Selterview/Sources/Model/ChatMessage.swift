//
//  ChatMessage.swift
//  Selterview
//
//  Created by woo0 on 2/8/24.
//

import Foundation

struct ChatMessage: Identifiable {
	var id = UUID()
	var message: String
	var isUser: Bool
}
