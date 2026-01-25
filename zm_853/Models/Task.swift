//
//  Task.swift
//  Task Maestro
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var taskDescription: String?
    @NSManaged public var priority: Int16
    @NSManaged public var status: String
    @NSManaged public var createdAt: Date
    @NSManaged public var dueDate: Date?
    @NSManaged public var completedAt: Date?
    @NSManaged public var estimatedHours: Double
    @NSManaged public var actualHours: Double
    @NSManaged public var tags: String?
    @NSManaged public var project: ProjectEntity?
    @NSManaged public var assignedTo: TeamMemberEntity?
}

struct TaskModel: Identifiable {
    let id: UUID
    var title: String
    var description: String
    var priority: Priority
    var status: TaskStatus
    var createdAt: Date
    var dueDate: Date?
    var completedAt: Date?
    var estimatedHours: Double
    var actualHours: Double
    var tags: [String]
    var projectID: UUID?
    var assignedToID: UUID?
    
    enum Priority: Int16 {
        case low = 0
        case medium = 1
        case high = 2
        case urgent = 3
        
        var displayName: String {
            switch self {
            case .low: return "Low"
            case .medium: return "Medium"
            case .high: return "High"
            case .urgent: return "Urgent"
            }
        }
        
        var color: String {
            switch self {
            case .low: return "#4CAF50"
            case .medium: return "#2196F3"
            case .high: return "#FF9800"
            case .urgent: return "#F44336"
            }
        }
    }
    
    enum TaskStatus: String {
        case pending = "pending"
        case inProgress = "in_progress"
        case completed = "completed"
        case blocked = "blocked"
        
        var displayName: String {
            switch self {
            case .pending: return "Pending"
            case .inProgress: return "In Progress"
            case .completed: return "Completed"
            case .blocked: return "Blocked"
            }
        }
    }
    
    init(from entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title
        self.description = entity.taskDescription ?? ""
        self.priority = Priority(rawValue: entity.priority) ?? .medium
        self.status = TaskStatus(rawValue: entity.status) ?? .pending
        self.createdAt = entity.createdAt
        self.dueDate = entity.dueDate
        self.completedAt = entity.completedAt
        self.estimatedHours = entity.estimatedHours
        self.actualHours = entity.actualHours
        self.tags = entity.tags?.components(separatedBy: ",") ?? []
        self.projectID = entity.project?.id
        self.assignedToID = entity.assignedTo?.id
    }
}
