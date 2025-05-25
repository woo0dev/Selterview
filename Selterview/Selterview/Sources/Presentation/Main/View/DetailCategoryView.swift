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
			.onAppear {
				viewStore.send(.fetchQuestions)
			}
			.showErrorMessage(showAlert: viewStore.$isError, message: viewStore.error?.errorDescription ?? "알 수 없는 문제가 발생했습니다.")
			.showToastView(isShowToast: viewStore.$isShowToast, message: viewStore.$toastMessage)
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
			if viewStore.questions.isEmpty {
				Image(systemName: "shuffle")
					.font(Font.defaultBoldFont(.title))
					.foregroundStyle(Color.accentTextColor.opacity(0.2))
					.padding(.trailing, 10)
			} else {
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
						.padding(.trailing, 10)
				}
			}
<<<<<<< HEAD
			.fullScreenCover(
				store: store.scope(
					state: \.$addQuestionState,
					action: DetailCategoryFeature.Action.addQuestionState
				)
			) { addQuestionStore in
				AddQuestionView(store: addQuestionStore)
					.background(Color(.systemGray6))
=======
			Button(action: {
				viewStore.send(.addButtonTapped)
			}, label: {
				Image(systemName: "plus")
					.font(Font.defaultBoldFont(.title))
					.foregroundStyle(Color.accentTextColor)
					.padding(.trailing, 20)
			})
		}
		.sheet(isPresented: viewStore.$isAddButtonTap) {
			AddQuestionView(questions: viewStore.$addQuestions, category: viewStore.category)
			HStack {
				Spacer()
				Button("취소") {
					viewStore.send(.addQuestionCancel)
				}
				.roundedStyle(alignment: .center, maxWidth: 150, minHeight: nil, maxHeight: 50, radius: nil, font: .defaultMidiumFont(.title3), foregroundColor: .red, backgroundColor: .clear, borderColor: .accentTextColor)
				Spacer()
				Button("추가") {
					viewStore.send(.addQuestion(viewStore.addQuestions))
				}
				.roundedStyle(alignment: .center, maxWidth: 150, minHeight: nil, maxHeight: 50, radius: nil, font: .defaultMidiumFont(.title3), foregroundColor: .blue, backgroundColor: .clear, borderColor: .accentTextColor)
				Spacer()
>>>>>>> 16b32aa37c08fccde866c1d668cc502a84234a9d
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
