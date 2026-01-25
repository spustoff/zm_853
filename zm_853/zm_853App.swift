//
//  zm_853App.swift
//  Task Maestro
//

import SwiftUI
import CoreData

@main
struct zm_853App: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    let persistenceController = PersistenceController.shared
    
    init() {
        // Seed initial data
        DataService.shared.seedSampleData()
    }
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                OnboardingView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
