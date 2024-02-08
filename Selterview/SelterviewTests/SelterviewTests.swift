//
//  SelterviewTests.swift
//  SelterviewTests
//
//  Created by woo0 on 2/2/24.
//

import ComposableArchitecture
import XCTest
@testable import Selterview

@MainActor
func testFeature() async {
	let store = TestStore(initialState: ProblemReducer.State(questions: [Question(id: 1, title: "변수와 상수에 대해서 설명해 주세요", category: .swift, tails: []), Question(id: 2, title: "Class 와 Struct의 차이를 설명해주세요", category: .swift, tails: []), Question(id: 3, title: "Swift의 복사 방법에 대해서 설명해 주세요", category: .swift, tails: []), Question(id: 4, title: "class의 성능을 향상 시킬 수 있는 방법을 설명해주세요", category: .swift, tails: []), Question(id: 5, title: "swift의 타입캐스팅에 대해서 설명해주세요", category: .swift, tails: []), Question(id: 6, title: "MVVM 패턴에 대해 설명해주세요", category: .ios, tails: []), Question(id: 7, title: "옵저버 패턴에 대해 설명해주세요", category: .ios, tails: []), Question(id: 8, title: "애플은 Swift 라는 언어를 설계할 때 MVC 를 추구하며 설계했습니다. UIKit 에서 ViewController 라는 노골적인 단어를 사용하는 것만 봐도 알 수 있죠. 왜 그렇게 했을까요?", category: .ios, tails: []), Question(id: 9, title: "스택이란 무엇인가요?", category: .cs, tails: []), Question(id: 10, title: "이진 탐색이란 무엇인가요?", category: .cs, tails: []), Question(id: 11, title: "퀵 정렬이란 무엇인가요?", category: .cs, tails: []), Question(id: 12, title: "병합 정렬이란 무엇인가요?", category: .cs, tails: [])], questionIndex: 0)) {
		ProblemReducer()
	}
	
	await store.send(.newTailQuestionCreateButtonTapped)
}
