//
//  Group3FcApp.swift
//  Group3Fc
//
//  Created by Filza Rizki Ramadhan on 22/03/25.
//

import SwiftUI
import SwiftData

@main
struct Group3FcApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
        .modelContainer(sharedModelContainer)
    }
}

let sharedModelContainer: ModelContainer = {
    do {
        let schema = Schema([
            Borrower.self,
            Debt.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

