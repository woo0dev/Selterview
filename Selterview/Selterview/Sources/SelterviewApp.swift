//
//  SelterviewApp.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct SelterviewApp: App {
    var body: some Scene {
        WindowGroup {
			MainView(store: Store(initialState: MainFeature.State()) {
				MainFeature()
			})
        }
    }
}
