//
//  MainView.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
	let store: StoreOf<MainReducer>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			NavigationStack {
				VStack {
					HStack {
						CategoryPickerView(selectedCategory: viewStore.$selectedCategory)
							.padding(.leading, 20)
						Spacer()
					}
					List(viewStore.filteredQuestions.indices, id: \.self) { index in
						NavigationLink(destination: ProblemView(store: Store(initialState: ProblemReducer.State(questions: viewStore.filteredQuestions, questionIndex: index), reducer: {
							ProblemReducer()
						})), label: {
							Text(viewStore.filteredQuestions[index].title)
						})
					}
					.listStyle(.inset)
				}
				.toolbar(.hidden)
			}
			.onAppear {
				viewStore.send(.onAppear)
			}
		}
	}
}
