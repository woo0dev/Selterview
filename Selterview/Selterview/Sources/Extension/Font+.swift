//
//  Font+.swift
//  Selterview
//
//  Created by woo0 on 2/18/24.
//

import SwiftUI

extension Font {
	enum Size {
		case title
		case title2
		case title3
		case body
		
		var value: CGFloat {
			switch self {
			case .title:
				return 28
			case .title2:
				return 22
			case .title3:
				return 20
			case .body:
				return 17
			}
		}
	}
	
	static func defaultLightFont(_ size: Size) -> Font {
		return .custom("GmarketSansLight", size: size.value)
	}
	
	static func defaultMidiumFont(_ size: Size) -> Font {
		return .custom("GmarketSansMedium", size: size.value)
	}
	
	static func defaultBoldFont(_ size: Size) -> Font {
		return .custom("GmarketSansBold", size: size.value)
	}
}
