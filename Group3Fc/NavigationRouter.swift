//
//  NavigationRouter.swift
//  Piutang
//
//  Created by Pramuditha Muhammad Ikhwan on 16/03/25.
//

import SwiftUI
import Combine

enum Route: Hashable {
    case home
    case addReceivable
    case detailReceivable(Int)
}

class NavigationRouter: ObservableObject {
    // Init navigation path to track the navigation route
    @Published var path = NavigationPath()
    
    // Save the reference to sheet presentation
    @Published var presentedSheet: Route?
    
    // Function to navigate to selected route
    func navigate(to route: Route) {
        path.append(route)
    }
    
    // Function to navigate back to root
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    // Function to present sheet
    func presentSheet(_ route: Route) {
        presentedSheet = route
    }
    
    // Function to dismiss sheet
    func dismissSheet() {
        presentedSheet = nil
    }
}
