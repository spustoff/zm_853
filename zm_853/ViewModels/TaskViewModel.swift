//
//  TaskViewModel.swift
//  Task Maestro
//

import Foundation
import CoreData
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskEntity] = []
    @Published var filteredTasks: [TaskEntity] = []
    @Published var selectedFilter: TaskFilter = .all
    @Published var searchText: String = ""
    
    private let dataService = DataService.shared
    
    enum TaskFilter: String, CaseIterable {
        case all = "All"
        case pending = "Pending"
        case inProgress = "In Progress"
        case completed = "Completed"
        case urgent = "Urgent"
    }
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        tasks = dataService.fetchAllTasks()
        applyFilters()
    }
    
    func applyFilters() {
        var result = tasks
        
        // Apply status filter
        switch selectedFilter {
        case .all:
            break
        case .pending:
            result = result.filter { $0.status == "pending" }
        case .inProgress:
            result = result.filter { $0.status == "in_progress" }
        case .completed:
            result = result.filter { $0.status == "completed" }
        case .urgent:
            result = result.filter { $0.priority == 3 }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.taskDescription?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        filteredTasks = result
    }
    
    func createTask(title: String, description: String, priority: TaskModel.Priority, dueDate: Date?, projectID: UUID? = nil) {
        dataService.createTask(title: title, description: description, priority: priority, dueDate: dueDate, projectID: projectID)
        loadTasks()
    }
    
    func updateTaskStatus(task: TaskEntity, status: TaskModel.TaskStatus) {
        dataService.updateTaskStatus(task: task, status: status)
        loadTasks()
    }
    
    func deleteTask(task: TaskEntity) {
        dataService.deleteTask(task: task)
        loadTasks()
    }
    
    func tasksForProject(_ projectID: UUID) -> [TaskEntity] {
        tasks.filter { $0.project?.id == projectID }
    }
}
