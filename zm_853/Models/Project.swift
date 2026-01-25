//
//  Project.swift
//  Task Maestro
//

import Foundation
import CoreData

@objc(ProjectEntity)
public class ProjectEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var projectDescription: String?
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date?
    @NSManaged public var color: String
    @NSManaged public var progress: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var tasks: NSSet?
    @NSManaged public var team: NSSet?
}

struct ProjectModel: Identifiable {
    let id: UUID
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date?
    var color: String
    var progress: Double
    var createdAt: Date
    var taskCount: Int
    var completedTaskCount: Int
    
    init(from entity: ProjectEntity) {
        self.id = entity.id
        self.name = entity.name
        self.description = entity.projectDescription ?? ""
        self.startDate = entity.startDate
        self.endDate = entity.endDate
        self.color = entity.color
        self.progress = entity.progress
        self.createdAt = entity.createdAt
        
        let tasks = entity.tasks?.allObjects as? [TaskEntity] ?? []
        self.taskCount = tasks.count
        self.completedTaskCount = tasks.filter { $0.status == "completed" }.count
    }
}
