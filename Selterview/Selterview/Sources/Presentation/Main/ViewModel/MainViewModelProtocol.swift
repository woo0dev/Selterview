//
//  MainViewModelProtocol.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import Foundation

protocol MainViewModelProtocol {
	var questions: [Question] { get set }
	func viewOnAppear()
	func changedCategory()
}
