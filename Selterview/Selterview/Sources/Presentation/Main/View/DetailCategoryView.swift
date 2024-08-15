//
//  DetailCategoryView.swift
//  Selterview
//
//  Created by woo0 on 8/15/24.
//

import SwiftUI
import ComposableArchitecture

struct DetailCategoryView: View {
	let store: StoreOf<DetailCategoryReducer>
	
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			VStack(alignment: .leading) {
				HeaderView(viewStore: viewStore)
				BodyView(viewStore: viewStore)
			}
		}
	}
}

private struct HeaderView: View {
	let viewStore: ViewStoreOf<DetailCategoryReducer>
	
	var body: some View {
		HStack {
			Text(viewStore.category)
				.font(Font.defaultBoldFont(.title))
				.padding(.leading, 20)
			Spacer()
			NavigationLink {
				ProblemView(store: Store(
					initialState: ProblemReducer.State(
						questions: viewStore.questions,
						questionIndex: Int.random(in: 0..<viewStore.questions.count)
					),
					reducer: { ProblemReducer() }
				))
			} label: {
				Image(systemName: "shuffle")
					.font(Font.defaultBoldFont(.title))
					.foregroundStyle(Color.accentTextColor)
					.padding(.trailing, 20)
			}
		}
	}
}

private struct BodyView: View {
	let viewStore: ViewStoreOf<DetailCategoryReducer>
	
	var body: some View {
		List {
			ForEach(viewStore.questions.indices, id: \.self) { index in
				NavigationLink {
					ProblemView(store: Store(
						initialState: ProblemReducer.State(
							questions: viewStore.questions,
							questionIndex: index
						),
						reducer: { ProblemReducer() }
					))
				} label: {
					Text(viewStore.questions[index].title)
						.font(.defaultMidiumFont(.body))
				}
			}
			.onDelete { indexSet in
				for index in indexSet {
					viewStore.send(.deleteButtonTapped(viewStore.questions[index]))
				}
			}
		}
		.listStyle(.inset)
		.overlay(Group {
			if viewStore.questions.isEmpty {
				Text("\(viewStore.category)(으)로 등록된 질문이 없습니다.\n새 질문을 등록해주세요.")
					.foregroundStyle(.gray)
					.multilineTextAlignment(.center)
					.font(.defaultMidiumFont(.body))
					.lineSpacing(5)
			}
		})
	}
}
