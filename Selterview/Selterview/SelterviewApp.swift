//
//  SelterviewApp.swift
//  Selterview
//
//  Created by woo0 on 2/2/24.
//

import SwiftUI

@main
struct SelterviewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
