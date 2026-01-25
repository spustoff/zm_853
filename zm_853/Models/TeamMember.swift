//
//  TeamMember.swift
//  Task Maestro
//

import Foundation
import CoreData

@objc(TeamMemberEntity)
public class TeamMemberEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var role: String
    @NSManaged public var avatarColor: String
    @NSManaged public var createdAt: Date
    @NSManaged public var assignedTasks: NSSet?
    @NSManaged public var projects: NSSet?
}

struct TeamMemberModel: Identifiable {
    let id: UUID
    var name: String
    var email: String
    var role: String
    var avatarColor: String
    var createdAt: Date
    var assignedTaskCount: Int
    
    init(from entity: TeamMemberEntity) {
        self.id = entity.id
        self.name = entity.name
        self.email = entity.email
        self.role = entity.role
        self.avatarColor = entity.avatarColor
        self.createdAt = entity.createdAt
        self.assignedTaskCount = entity.assignedTasks?.count ?? 0
    }
}
