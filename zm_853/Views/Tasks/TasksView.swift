//
//  TasksView.swift
//  Task Maestro
//

import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel = TaskViewModel()
    @StateObject private var projectViewModel = ProjectViewModel()
    @State private var showAddTask = false
    @State private var showFilterOptions = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("Search tasks...", text: $viewModel.searchText)
                        .foregroundColor(.white)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.applyFilters()
                        }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                
                Button(action: { showFilterOptions.toggle() }) {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "FCD826"))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            // Filter Pills
            if showFilterOptions {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TaskViewModel.TaskFilter.allCases, id: \.self) { filter in
                            FilterPill(
                                title: filter.rawValue,
                                isSelected: viewModel.selectedFilter == filter
                            ) {
                                viewModel.selectedFilter = filter
                                viewModel.applyFilters()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 12)
            }
            
            // Tasks List
            ScrollView {
                VStack(spacing: 12) {
                    if viewModel.filteredTasks.isEmpty {
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 16) {
                                Image(systemName: "tray")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white.opacity(0.4))
                                
                                Text("No tasks found")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("Create a new task to get started")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                    } else {
                        ForEach(viewModel.filteredTasks) { task in
                            TaskRowView(task: task, viewModel: viewModel)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            
            // Add Task Button
            GlassmorphicButton(title: "Add Task", icon: "plus.circle.fill") {
                showAddTask = true
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .onAppear {
            viewModel.loadTasks()
            projectViewModel.loadProjects()
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(viewModel: viewModel, projects: projectViewModel.projects)
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "081567") : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                )
        }
    }
}

struct TaskRowView: View {
    let task: TaskEntity
    let viewModel: TaskViewModel
    @State private var showDetail = false
    
    var body: some View {
        Button(action: { showDetail = true }) {
            GlassmorphicCard(opacity: 0.1) {
                HStack(spacing: 12) {
                    // Status Indicator
                    Button(action: {
                        let newStatus: TaskModel.TaskStatus = task.status == "completed" ? .pending : .completed
                        viewModel.updateTaskStatus(task: task, status: newStatus)
                    }) {
                        Image(systemName: task.status == "completed" ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundColor(task.status == "completed" ? Color(hex: "4CAF50") : .white.opacity(0.4))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(task.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        HStack(spacing: 8) {
                            if let dueDate = task.dueDate {
                                HStack(spacing: 4) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 10))
                                    Text(dueDate, style: .date)
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(.white.opacity(0.6))
                            }
                            
                            // Priority Badge
                            if let priority = TaskModel.Priority(rawValue: task.priority) {
                                Text(priority.displayName)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(hex: priority.color).opacity(0.3))
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(16)
            }
        }
        .sheet(isPresented: $showDetail) {
            TaskDetailView(task: task, viewModel: viewModel)
        }
    }
}
