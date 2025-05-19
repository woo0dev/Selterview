//
//  SelterviewTests.swift
//  SelterviewTests
//
//  Created by woo0 on 2/2/24.
//

import ComposableArchitecture
import XCTest
@testable import Selterview

final class MainTests: XCTestCase {
	@MainActor
	func addQuestionTestFeature() async {
		let store = TestStore(initialState: MainFeature.State()) {
			MainFeature()
		}
		
		await store.send(.addButtonTapped)
	}
}
