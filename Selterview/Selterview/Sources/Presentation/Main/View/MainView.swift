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
					List {
						ForEach(viewStore.filteredQuestions.indices, id: \.self) { index in
							NavigationLink(destination: ProblemView(store: Store(initialState: ProblemReducer.State(questions: viewStore.filteredQuestions, questionIndex: index), reducer: {
								ProblemReducer()
							})), label: {
								Text(viewStore.filteredQuestions[index].title)
									.font(.defaultFont(.body))
							})
						}
						.onDelete { indexSet in
							for index in indexSet{
								viewStore.send(.deleteButtonTapped(viewStore.filteredQuestions[index]))
							}
						}
					}
					.listStyle(.inset)
					.overlay(Group {
						if viewStore.filteredQuestions.isEmpty {
							Text("\(viewStore.selectedCategory.rawValue)(으)로 등록된 질문이 없습니다.\n새 질문을 등록해주세요.")
								.foregroundStyle(.gray)
								.multilineTextAlignment(.center)
						}
					})
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						CategoryPickerView(selectedCategory: viewStore.$selectedCategory)
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Menu {
							Button {
								viewStore.send(.addButtonTapped)
							} label : {
								Label("새 질문 추가하기" , systemImage: "text.badge.plus")
							}
							Button {
								print("랜덤 질문 시작하기 클릭")
							} label : {
								Label("랜덤 질문 시작하기" , systemImage: "play.fill")
							}
							Button {
								viewStore.send(.settingButtonTapped)
							} label : {
								Label("설정" , systemImage: "gear")
							}
						} label: {
							Image(systemName: "ellipsis")
								.foregroundStyle(Color.accentTextColor)
						}
					}
				}
			}
			.onAppear {
				viewStore.send(.fetchQuestions)
			}
			.sheet(isPresented: viewStore.$isAddButtonTap) {
				AddQuestionView(isShowAddModal: viewStore.$isAddButtonTap, store: Store(initialState: AddReducer.State()) {
					AddReducer()
				})
				.onDisappear {
					viewStore.send(.fetchQuestions)
				}
			}
			.sheet(isPresented: viewStore.$isSettingButtonTap) {
				SettingView()
					.presentationDetents([.height(80)])
			}
			.showErrorMessage(showAlert: viewStore.$isError, message: viewStore.error?.errorDescription ?? "알 수 없는 문제가 발생했습니다.")
		}
	}
}
