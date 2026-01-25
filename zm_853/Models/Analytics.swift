//
//  Analytics.swift
//  Task Maestro
//

import Foundation
import CoreData

@objc(AnalyticsEntity)
public class AnalyticsEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var tasksCompleted: Int16
    @NSManaged public var tasksCreated: Int16
    @NSManaged public var hoursWorked: Double
    @NSManaged public var productivityScore: Double
}

struct AnalyticsModel: Identifiable {
    let id: UUID
    var date: Date
    var tasksCompleted: Int
    var tasksCreated: Int
    var hoursWorked: Double
    var productivityScore: Double
    
    init(from entity: AnalyticsEntity) {
        self.id = entity.id
        self.date = entity.date
        self.tasksCompleted = Int(entity.tasksCompleted)
        self.tasksCreated = Int(entity.tasksCreated)
        self.hoursWorked = entity.hoursWorked
        self.productivityScore = entity.productivityScore
    }
}
