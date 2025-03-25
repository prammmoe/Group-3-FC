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
    @State private var showOnboarding: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if showOnboarding {
                    HomeView()
                        .navigationBarBackButtonHidden(true) // Hide navigation back button
                } else {
                    OnboardingView().onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.showOnboarding = true
                            }
                        }
                    }
                }
            }
       }
       .modelContainer(for: [Borrower.self, Debt.self])
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

