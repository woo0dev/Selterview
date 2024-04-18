//
//  ClearBackgroundView.swift
//  Selterview
//
//  Created by woo0 on 4/18/24.
//

import SwiftUI

struct ClearBackgroundView: UIViewRepresentable {
	func makeUIView(context: Context) -> some UIView {
		let view = UIView()
		
		DispatchQueue.main.async {
			view.superview?.superview?.backgroundColor = .clear
		}
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) { }
}
