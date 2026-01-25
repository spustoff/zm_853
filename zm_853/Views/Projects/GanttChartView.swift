//
//  GanttChartView.swift
//  Task Maestro
//

import SwiftUI

struct GanttChartView: View {
    @Environment(\.presentationMode) var presentationMode
    let projects: [ProjectEntity]
    let tasks: [TaskEntity]
    @State private var selectedTimeRange: TimeRange = .month
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case quarter = "Quarter"
    }
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                    
                    Spacer()
                    
                    Text("Gantt Chart")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Spacer for alignment
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 38, height: 38)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                // Time Range Selector
                HStack(spacing: 8) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Button(action: {
                            selectedTimeRange = range
                        }) {
                            Text(range.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(selectedTimeRange == range ? Color(hex: "081567") : .white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedTimeRange == range ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 16) {
                        if projects.isEmpty {
                            GlassmorphicCard(opacity: 0.1) {
                                VStack(spacing: 16) {
                                    Image(systemName: "chart.bar.xaxis")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white.opacity(0.4))
                                    
                                    Text("No projects to display")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text("Create projects to see them in the Gantt chart")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.6))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(40)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 40)
                        } else {
                            ForEach(projects) { project in
                                GanttProjectRow(project: project, timeRange: selectedTimeRange)
                            }
                        }
                        
                        // Educational Tip
                        GlassmorphicCard(opacity: 0.15) {
                            HStack(spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "FCD826"))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Gantt Chart Tip")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("Visualize project timelines to identify dependencies and optimize resource allocation.")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.8))
                                        .lineSpacing(4)
                                }
                            }
                            .padding(16)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 12)
                }
            }
        }
    }
}

struct GanttProjectRow: View {
    let project: ProjectEntity
    let timeRange: GanttChartView.TimeRange
    
    private var timelineDuration: Int {
        switch timeRange {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        }
    }
    
    private var projectDuration: Int {
        guard let endDate = project.endDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: project.startDate, to: endDate).day ?? 0
    }
    
    private var progressWidth: CGFloat {
        let totalDays = max(projectDuration, 1)
        let progress = min(Double(totalDays) / Double(timelineDuration), 1.0)
        return CGFloat(progress)
    }
    
    var body: some View {
        GlassmorphicCard(opacity: 0.1) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(Color(hex: project.color))
                        .frame(width: 12, height: 12)
                    
                    Text(project.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(project.progress * 100))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "FCD826"))
                }
                
                // Timeline visualization
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background track
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                            .frame(height: 24)
                        
                        // Progress bar
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: project.color),
                                        Color(hex: project.color).opacity(0.6)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progressWidth, height: 24)
                        
                        // Completion indicator
                        if project.progress > 0 {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "FCD826"))
                                .frame(width: geometry.size.width * progressWidth * CGFloat(project.progress), height: 24)
                        }
                    }
                }
                .frame(height: 24)
                
                // Dates
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Start")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))
                        Text(project.startDate, style: .date)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    if let endDate = project.endDate {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("End")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.6))
                            Text(endDate, style: .date)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .padding(16)
        }
        .padding(.horizontal, 20)
    }
}
