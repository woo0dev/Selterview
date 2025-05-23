//
//  MainView.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
	let store: StoreOf<MainFeature>
	
	var body: some View {
		WithViewStore(self.store, observe: { $0 }) { viewStore in
			NavigationStack {
				VStack {
					HeaderView(viewStore: viewStore)
					BodyView(viewStore: viewStore)
						.onAppear {
							viewStore.send(.fetchCategories)
						}
						.alert("카테고리 추가", isPresented: viewStore.$isCategoryAddButtonTap) {
							TextField("카테고리 이름", text: viewStore.$addCategoryText)
							Button("취소") {
								viewStore.send(.addCategoryCancel)
							}
							Button("추가") {
								viewStore.send(.addCategory)
							}
						} message: {
							Text("카테고리 이름을 입력해 주세요.")
						}
						.showErrorMessage(showAlert: viewStore.$isError, message: viewStore.error?.errorDescription ?? "알 수 없는 문제가 발생했습니다.")
						.showToastView(isShowToast: viewStore.$isShowToast, message: viewStore.$toastMessage)
				}
				.background(Color(.systemGray6))
				.navigationDestination(for: Int.self) { index in
					DetailCategoryView(store: Store(
						initialState: DetailCategoryFeature.State(
							category: viewStore.categories[index],
							questions: viewStore.questions[viewStore.categories[index]] ?? []
						),
						reducer: { DetailCategoryFeature() }
					))
				}
			}
		}
	}
}

private struct HeaderView: View {
	let viewStore: ViewStoreOf<MainFeature>
	
	var body: some View {
		HStack {
			Text("Selterview")
				.font(Font.defaultBoldFont(.title))
			Spacer()
			Button {
				viewStore.send(.addCategoryTapped)
			} label: {
				Image(systemName: "plus")
					.foregroundStyle(Color.accentTextColor)
					.font(.system(size: 40))
			}
		}
		.padding(20)
	}
}

private struct BodyView: View {
	let viewStore: ViewStoreOf<MainFeature>
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: [GridItem(.flexible())]) {
				ForEach(viewStore.categories.indices, id: \.self) { index in
					NavigationLink(value: index) {
						VStack(alignment: .center, spacing: 10) {
							Text(viewStore.categories[index])
								.font(Font.defaultMidiumFont(.title))
							Text("\(viewStore.questions[viewStore.categories[index]]?.count ?? 0)문제")
						}
						.padding(10)
						.roundedStyle(
							alignment: .topLeading,
							radius: 20,
							font: .defaultLightFont(.body),
							foregroundColor: .primary,
							backgroundColor: Color(.systemBackground)
						)
					}
				}
			}
			.padding(.horizontal)
			Spacer()
		}
		.overlay(Group {
			if viewStore.categories.isEmpty {
				Text("등록된 카테고리가 없습니다.\n새 카테고리를 등록해주세요.")
					.foregroundStyle(.gray)
					.multilineTextAlignment(.center)
					.font(.defaultMidiumFont(.body))
					.lineSpacing(5)
			}
		})
	}
}
