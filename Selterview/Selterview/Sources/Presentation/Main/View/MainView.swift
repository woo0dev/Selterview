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
							NavigationLink(value: index, label: {
								Text(viewStore.filteredQuestions[index].title)
									.font(.defaultMidiumFont(.body))
									.lineSpacing(5)
							})
						}
						.onDelete { indexSet in
							for index in indexSet{
								viewStore.send(.deleteButtonTapped(viewStore.filteredQuestions[index]))
							}
						}
					}
					.navigationDestination(for: Int.self) { index in
						ProblemView(store: Store(initialState: ProblemReducer.State(questions: viewStore.filteredQuestions, questionIndex: index), reducer: {
							ProblemReducer()
						}))
					}
					.listStyle(.inset)
					.overlay(Group {
						if viewStore.filteredQuestions.isEmpty {
							if viewStore.selectedCategory == nil {
								Text("등록된 카테고리가 없습니다.\n새 카테고리를 등록해주세요.")
									.foregroundStyle(.gray)
									.multilineTextAlignment(.center)
									.font(.defaultMidiumFont(.body))
									.lineSpacing(5)
							} else {
								Text("\(viewStore.selectedCategory ?? "")(으)로 등록된 질문이 없습니다.\n새 질문을 등록해주세요.")
									.foregroundStyle(.gray)
									.multilineTextAlignment(.center)
									.font(.defaultMidiumFont(.body))
									.lineSpacing(5)
							}
						}
					})
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						if let _ = viewStore.selectedCategory {
							CategoryPickerView(selectedCategory: viewStore.$selectedCategory, categories: viewStore.categories ?? [])
						} else {
							Button {
								viewStore.send(.addCategoryTapped)
							} label: {
								Text("+")
									.padding([.leading, .trailing], 30)
							}
							.roundedStyle(maxWidth: 100, maxHeight: 40, font: .defaultMidiumFont(.title), backgroundColor: .textBackgroundLightGray)
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Menu {
							Button {
								viewStore.send(.addButtonTapped)
							} label: {
								Label("새 질문 추가하기", systemImage: "text.badge.plus")
							}
							Button {
								viewStore.send(.randomStartButtonTapped)
							} label: {
								Label("랜덤 질문 시작하기", systemImage: "play.fill")
							}
							Button {
								viewStore.send(.addCategoryTapped)
							} label : {
								Label("새 카테고리 추가하기", systemImage: "plus.rectangle")
							}
							Button {
								viewStore.send(.deleteCategoryButtonTapped)
							} label : {
								Label("현재 카테고리 삭제", systemImage: "trash")
							}
							Button {
								viewStore.send(.settingButtonTapped)
							} label: {
								Label("설정", systemImage: "gear")
							}
						} label: {
							Image(systemName: "ellipsis")
								.foregroundStyle(Color.accentTextColor)
						}
					}
				}
				.navigationDestination(isPresented: viewStore.$isRandomStartButtonTap) {
					if viewStore.filteredQuestions.isEmpty {
						EmptyView()
					} else {
						ProblemView(store: Store(initialState: ProblemReducer.State(questions: viewStore.filteredQuestions, questionIndex: Int.random(in: 0..<viewStore.filteredQuestions.count)), reducer: {
							ProblemReducer()
						   }))
					}
				}
			}
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
			.alert("카테고리 삭제", isPresented: viewStore.$isCategoryDeleteButtonTap) {
				Button("취소") {
					viewStore.send(.deleteCategoryCancle)
				}
				Button("삭제") {
					viewStore.send(.deleteCategory)
				}
			} message: {
				Text("카테고리 삭제 시 관련 질문들도 함께 삭제됩니다.\n삭제 하시겠습니까?")
			}
			.sheet(isPresented: viewStore.$isAddButtonTap) {
				AddQuestionView(isShowAddModal: viewStore.$isAddButtonTap, store: Store(initialState: AddReducer.State(selectedCategory: viewStore.selectedCategory ?? "카테고리 선택")) {
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
			.showToastView(isShowToast: viewStore.$isShowToast, message: viewStore.$toastMessage)
		}
	}
}
