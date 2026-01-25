//
//  AnalyticsViewModel.swift
//  Task Maestro
//

import Foundation
import Combine

class AnalyticsViewModel: ObservableObject {
    @Published var analytics: [AnalyticsEntity] = []
    @Published var totalTasksCompleted: Int = 0
    @Published var totalHoursWorked: Double = 0
    @Published var averageProductivity: Double = 0
    @Published var currentStreak: Int = 0
    
    private let dataService = DataService.shared
    
    func loadAnalytics(days: Int = 7) {
        analytics = dataService.fetchAnalytics(days: days)
        calculateMetrics()
    }
    
    private func calculateMetrics() {
        totalTasksCompleted = analytics.reduce(0) { $0 + Int($1.tasksCompleted) }
        totalHoursWorked = analytics.reduce(0) { $0 + $1.hoursWorked }
        
        if !analytics.isEmpty {
            let totalScore = analytics.reduce(0.0) { $0 + $1.productivityScore }
            averageProductivity = totalScore / Double(analytics.count)
        }
        
        currentStreak = calculateStreak()
    }
    
    private func calculateStreak() -> Int {
        var streak = 0
        let calendar = Calendar.current
        var checkDate = Date()
        
        for _ in 0..<30 {
            let dayStart = calendar.startOfDay(for: checkDate)
            if let analyticsForDay = analytics.first(where: { calendar.isDate($0.date, inSameDayAs: dayStart) }),
               analyticsForDay.tasksCompleted > 0 {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }
        
        return streak
    }
}
