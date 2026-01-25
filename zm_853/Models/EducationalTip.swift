//
//  EducationalTip.swift
//  Task Maestro
//

import Foundation
import CoreData

@objc(EducationalTipEntity)
public class EducationalTipEntity: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var content: String
    @NSManaged public var category: String
    @NSManaged public var isRead: Bool
    @NSManaged public var createdAt: Date
}

struct EducationalTipModel: Identifiable {
    let id: UUID
    var title: String
    var content: String
    var category: TipCategory
    var isRead: Bool
    var createdAt: Date
    
    enum TipCategory: String, CaseIterable {
        case timeManagement = "Time Management"
        case productivity = "Productivity"
        case teamwork = "Teamwork"
        case planning = "Planning"
        case focus = "Focus"
        
        var icon: String {
            switch self {
            case .timeManagement: return "clock.fill"
            case .productivity: return "chart.line.uptrend.xyaxis"
            case .teamwork: return "person.3.fill"
            case .planning: return "calendar"
            case .focus: return "target"
            }
        }
    }
    
    init(from entity: EducationalTipEntity) {
        self.id = entity.id
        self.title = entity.title
        self.content = entity.content
        self.category = TipCategory(rawValue: entity.category) ?? .productivity
        self.isRead = entity.isRead
        self.createdAt = entity.createdAt
    }
}
