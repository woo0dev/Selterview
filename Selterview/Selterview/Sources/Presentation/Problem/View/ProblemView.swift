//
//  ProblemView.swift
//  Selterview
//
//  Created by woo0 on 2/3/24.
//

import SwiftUI

struct ProblemView: View {
	@State var questions: [Question]
	var questionStartIndex: Int
	
 	var body: some View {
		Text(questions[questionStartIndex].title)
	}
}
