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
        .modelContainer(for: [Borrower.self, Debt.self]) // Cara lebih bersih
    }
}

