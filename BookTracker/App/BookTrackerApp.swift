//
//  BookTrackerApp.swift
//  BookTracker
//
//  Created by Jamorn Suttipong on 27/1/2568 BE.
//

import SwiftUI

@main
struct BookTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
