//
//  ProjectViewModel.swift
//  Task Maestro
//

import Foundation
import Combine

class ProjectViewModel: ObservableObject {
    @Published var projects: [ProjectEntity] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadProjects()
    }
    
    func loadProjects() {
        projects = dataService.fetchAllProjects()
        updateAllProjectProgress()
    }
    
    func createProject(name: String, description: String, startDate: Date, endDate: Date?, color: String) {
        dataService.createProject(name: name, description: description, startDate: startDate, endDate: endDate, color: color)
        loadProjects()
    }
    
    func deleteProject(project: ProjectEntity) {
        dataService.deleteProject(project: project)
        loadProjects()
    }
    
    func updateAllProjectProgress() {
        for project in projects {
            dataService.updateProjectProgress(project: project)
        }
    }
    
    func tasksForProject(_ project: ProjectEntity) -> [TaskEntity] {
        (project.tasks?.allObjects as? [TaskEntity]) ?? []
    }
}
