//
//  AnalyticsView.swift
//  Task Maestro
//

import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var selectedPeriod: Period = .week
    
    enum Period: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case all = "All Time"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .all: return 365
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Period Selector
                HStack(spacing: 8) {
                    ForEach(Period.allCases, id: \.self) { period in
                        Button(action: {
                            selectedPeriod = period
                            viewModel.loadAnalytics(days: period.days)
                        }) {
                            Text(period.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(selectedPeriod == period ? Color(hex: "081567") : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedPeriod == period ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Key Metrics
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        MetricCard(
                            value: "\(viewModel.totalTasksCompleted)",
                            label: "Completed",
                            icon: "checkmark.circle.fill",
                            color: Color(hex: "4CAF50")
                        )
                        
                        MetricCard(
                            value: "\(Int(viewModel.totalHoursWorked))h",
                            label: "Hours Worked",
                            icon: "clock.fill",
                            color: Color(hex: "2196F3")
                        )
                    }
                    
                    HStack(spacing: 12) {
                        MetricCard(
                            value: "\(Int(viewModel.averageProductivity))%",
                            label: "Productivity",
                            icon: "chart.line.uptrend.xyaxis",
                            color: Color(hex: "FCD826")
                        )
                        
                        MetricCard(
                            value: "\(viewModel.currentStreak)",
                            label: "Day Streak",
                            icon: "flame.fill",
                            color: Color(hex: "FF9800")
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                // Productivity Chart
                GlassmorphicCard(opacity: 0.1) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Productivity Overview")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        if viewModel.analytics.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.4))
                                
                                Text("No data available")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                        } else {
                            ProductivityChart(analytics: viewModel.analytics)
                                .frame(height: 200)
                        }
                    }
                    .padding(16)
                }
                .padding(.horizontal, 20)
                
                // Task Status Distribution
                GlassmorphicCard(opacity: 0.1) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Task Distribution")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        let pending = taskViewModel.tasks.filter { $0.status == "pending" }.count
                        let inProgress = taskViewModel.tasks.filter { $0.status == "in_progress" }.count
                        let completed = taskViewModel.tasks.filter { $0.status == "completed" }.count
                        let total = max(taskViewModel.tasks.count, 1)
                        
                        VStack(spacing: 12) {
                            DistributionRow(
                                label: "Pending",
                                count: pending,
                                total: total,
                                color: Color(hex: "FCD826")
                            )
                            
                            DistributionRow(
                                label: "In Progress",
                                count: inProgress,
                                total: total,
                                color: Color(hex: "2196F3")
                            )
                            
                            DistributionRow(
                                label: "Completed",
                                count: completed,
                                total: total,
                                color: Color(hex: "4CAF50")
                            )
                        }
                    }
                    .padding(16)
                }
                .padding(.horizontal, 20)
                
                // Educational Tip
                GlassmorphicCard(opacity: 0.15) {
                    HStack(spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 24))
                            .foregroundColor(Color(hex: "FCD826"))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Analytics Insight")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Track your productivity patterns to identify peak performance times and optimize your schedule accordingly.")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                    }
                    .padding(16)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            viewModel.loadAnalytics(days: selectedPeriod.days)
            taskViewModel.loadTasks()
            DataService.shared.updateAnalytics()
        }
    }
}

struct MetricCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        GlassmorphicCard(opacity: 0.1) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
        }
    }
}

struct ProductivityChart: View {
    let analytics: [AnalyticsEntity]
    
    private var maxValue: Double {
        analytics.map { Double($0.tasksCompleted) }.max() ?? 1
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(analytics) { data in
                VStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "FCD826"),
                                    Color(hex: "FCD826").opacity(0.6)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: max(CGFloat(Double(data.tasksCompleted) / maxValue) * 150, 10))
                    
                    Text(formatDay(data.date))
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct DistributionRow: View {
    let label: String
    let count: Int
    let total: Int
    let color: Color
    
    private var percentage: Double {
        Double(count) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                
                Text("(\(Int(percentage * 100))%)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.1))
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage))
                }
            }
            .frame(height: 8)
        }
    }
}
