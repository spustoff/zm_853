//
//  ProjectsView.swift
//  Task Maestro
//

import SwiftUI

struct ProjectsView: View {
    @StateObject private var viewModel = ProjectViewModel()
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var showAddProject = false
    @State private var selectedProject: ProjectEntity?
    @State private var showGanttChart = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Gantt Chart Button
            Button(action: { showGanttChart = true }) {
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                        .font(.system(size: 16))
                    Text("View Gantt Chart")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(Color(hex: "081567"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "FCD826"))
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            // Projects List
            ScrollView {
                VStack(spacing: 12) {
                    if viewModel.projects.isEmpty {
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 16) {
                                Image(systemName: "folder")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.4))
                                
                                Text("No projects yet")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Create a project to organize your tasks")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                    } else {
                        ForEach(viewModel.projects) { project in
                            ProjectRowView(project: project, taskCount: viewModel.tasksForProject(project).count) {
                                selectedProject = project
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            
            // Add Project Button
            GlassmorphicButton(title: "Add Project", icon: "plus.circle.fill") {
                showAddProject = true
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .onAppear {
            viewModel.loadProjects()
            taskViewModel.loadTasks()
        }
        .sheet(isPresented: $showAddProject) {
            AddProjectView(viewModel: viewModel)
        }
        .sheet(item: $selectedProject) { project in
            ProjectDetailView(project: project, viewModel: viewModel)
        }
        .sheet(isPresented: $showGanttChart) {
            GanttChartView(projects: viewModel.projects, tasks: taskViewModel.tasks)
        }
    }
}

struct ProjectRowView: View {
    let project: ProjectEntity
    let taskCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            GlassmorphicCard(opacity: 0.1) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(Color(hex: project.color))
                            .frame(width: 16, height: 16)
                        
                        Text(project.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    
                    if let description = project.projectDescription, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "FCD826"))
                            Text("\(taskCount) tasks")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        if let endDate = project.endDate {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 12))
                                Text(endDate, style: .date)
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Progress")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                            Text("\(Int(project.progress * 100))%")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        ProgressView(value: project.progress)
                            .tint(Color(hex: "FCD826"))
                    }
                }
                .padding(16)
            }
        }
    }
}
