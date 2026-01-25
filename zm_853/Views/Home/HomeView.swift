//
//  HomeView.swift
//  Task Maestro
//

import SwiftUI

struct HomeView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var projectViewModel = ProjectViewModel()
    @State private var showEducationalTip = false
    @State private var currentTip: EducationalTipEntity?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Welcome Section
                GlassmorphicCard(opacity: 0.15) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome Back!")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Let's make today productive")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                loadRandomTip()
                                showEducationalTip = true
                            }) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(hex: "FCD826"))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(Color.white.opacity(0.1))
                                    )
                            }
                        }
                    }
                    .padding(20)
                }
                .padding(.horizontal, 20)
                
                // Quick Stats
                HStack(spacing: 12) {
                    StatCard(
                        value: "\(taskViewModel.tasks.filter { $0.status == "pending" }.count)",
                        label: "Pending",
                        icon: "clock.fill",
                        color: Color(hex: "FCD826")
                    )
                    
                    StatCard(
                        value: "\(taskViewModel.tasks.filter { $0.status == "in_progress" }.count)",
                        label: "In Progress",
                        icon: "arrow.clockwise",
                        color: Color(hex: "4CAF50")
                    )
                    
                    StatCard(
                        value: "\(taskViewModel.tasks.filter { $0.status == "completed" }.count)",
                        label: "Completed",
                        icon: "checkmark.circle.fill",
                        color: Color(hex: "2196F3")
                    )
                }
                .padding(.horizontal, 20)
                
                // Recent Projects
                if !projectViewModel.projects.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Active Projects")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(projectViewModel.projects.prefix(3)) { project in
                                    ProjectCard(project: project)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                // Today's Tasks
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's Tasks")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    if taskViewModel.tasks.filter({ $0.status != "completed" }).isEmpty {
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "FCD826"))
                                
                                Text("All caught up!")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("You have no pending tasks")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(30)
                        }
                        .padding(.horizontal, 20)
                    } else {
                        ForEach(taskViewModel.tasks.filter { $0.status != "completed" }.prefix(5)) { task in
                            TaskRowView(task: task, viewModel: taskViewModel)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
        .onAppear {
            taskViewModel.loadTasks()
            projectViewModel.loadProjects()
        }
        .sheet(isPresented: $showEducationalTip) {
            if let tip = currentTip {
                EducationalTipDetailView(tip: tip)
            }
        }
    }
    
    private func loadRandomTip() {
        let tips = DataService.shared.fetchAllEducationalTips().filter { !$0.isRead }
        currentTip = tips.randomElement()
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        GlassmorphicCard(opacity: 0.1) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
    }
}

struct ProjectCard: View {
    let project: ProjectEntity
    
    var body: some View {
        GlassmorphicCard(opacity: 0.1) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(Color(hex: project.color))
                        .frame(width: 12, height: 12)
                    
                    Text(project.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                
                ProgressView(value: project.progress)
                    .tint(Color(hex: "FCD826"))
                
                Text("\(Int(project.progress * 100))% Complete")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(16)
            .frame(width: 200)
        }
    }
}
