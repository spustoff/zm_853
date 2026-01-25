//
//  DataService.swift
//  Task Maestro
//

import Foundation
import CoreData

class DataService {
    static let shared = DataService()
    private let context = PersistenceController.shared.container.viewContext
    
    // MARK: - Task Operations
    
    func createTask(title: String, description: String, priority: TaskModel.Priority, dueDate: Date?, projectID: UUID? = nil, assignedToID: UUID? = nil) {
        let task = TaskEntity(context: context)
        task.id = UUID()
        task.title = title
        task.taskDescription = description
        task.priority = priority.rawValue
        task.status = TaskModel.TaskStatus.pending.rawValue
        task.createdAt = Date()
        task.dueDate = dueDate
        task.estimatedHours = 0
        task.actualHours = 0
        
        if let projectID = projectID {
            task.project = fetchProject(id: projectID)
        }
        
        if let assignedToID = assignedToID {
            task.assignedTo = fetchTeamMember(id: assignedToID)
        }
        
        PersistenceController.shared.save()
        updateAnalytics()
    }
    
    func fetchAllTasks() -> [TaskEntity] {
        let request = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    func updateTaskStatus(task: TaskEntity, status: TaskModel.TaskStatus) {
        task.status = status.rawValue
        if status == .completed {
            task.completedAt = Date()
        }
        PersistenceController.shared.save()
        updateAnalytics()
    }
    
    func deleteTask(task: TaskEntity) {
        context.delete(task)
        PersistenceController.shared.save()
    }
    
    // MARK: - Project Operations
    
    func createProject(name: String, description: String, startDate: Date, endDate: Date?, color: String) {
        let project = ProjectEntity(context: context)
        project.id = UUID()
        project.name = name
        project.projectDescription = description
        project.startDate = startDate
        project.endDate = endDate
        project.color = color
        project.progress = 0
        project.createdAt = Date()
        
        PersistenceController.shared.save()
    }
    
    func fetchAllProjects() -> [ProjectEntity] {
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ProjectEntity.createdAt, ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchProject(id: UUID) -> ProjectEntity? {
        let request = NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
    
    func updateProjectProgress(project: ProjectEntity) {
        let tasks = project.tasks?.allObjects as? [TaskEntity] ?? []
        if tasks.isEmpty {
            project.progress = 0
        } else {
            let completedCount = tasks.filter { $0.status == "completed" }.count
            project.progress = Double(completedCount) / Double(tasks.count)
        }
        PersistenceController.shared.save()
    }
    
    func deleteProject(project: ProjectEntity) {
        context.delete(project)
        PersistenceController.shared.save()
    }
    
    // MARK: - Team Member Operations
    
    func createTeamMember(name: String, email: String, role: String, avatarColor: String) {
        let member = TeamMemberEntity(context: context)
        member.id = UUID()
        member.name = name
        member.email = email
        member.role = role
        member.avatarColor = avatarColor
        member.createdAt = Date()
        
        PersistenceController.shared.save()
    }
    
    func fetchAllTeamMembers() -> [TeamMemberEntity] {
        let request = NSFetchRequest<TeamMemberEntity>(entityName: "TeamMemberEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \TeamMemberEntity.name, ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
    
    func fetchTeamMember(id: UUID) -> TeamMemberEntity? {
        let request = NSFetchRequest<TeamMemberEntity>(entityName: "TeamMemberEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
    
    func deleteTeamMember(member: TeamMemberEntity) {
        context.delete(member)
        PersistenceController.shared.save()
    }
    
    // MARK: - Analytics Operations
    
    func updateAnalytics() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let request = NSFetchRequest<AnalyticsEntity>(entityName: "AnalyticsEntity")
        request.predicate = NSPredicate(format: "date == %@", today as CVarArg)
        
        let analytics: AnalyticsEntity
        if let existing = try? context.fetch(request).first {
            analytics = existing
        } else {
            analytics = AnalyticsEntity(context: context)
            analytics.id = UUID()
            analytics.date = today
        }
        
        let tasks = fetchAllTasks()
        let todayTasks = tasks.filter { calendar.isDate($0.createdAt, inSameDayAs: Date()) }
        let completedToday = tasks.filter {
            guard let completedAt = $0.completedAt else { return false }
            return calendar.isDate(completedAt, inSameDayAs: Date())
        }
        
        analytics.tasksCreated = Int16(todayTasks.count)
        analytics.tasksCompleted = Int16(completedToday.count)
        analytics.hoursWorked = completedToday.reduce(0) { $0 + $1.actualHours }
        analytics.productivityScore = calculateProductivityScore(completed: completedToday.count, created: todayTasks.count)
        
        PersistenceController.shared.save()
    }
    
    func fetchAnalytics(days: Int = 7) -> [AnalyticsEntity] {
        let calendar = Calendar.current
        let endDate = calendar.startOfDay(for: Date())
        let startDate = calendar.date(byAdding: .day, value: -days, to: endDate)!
        
        let request = NSFetchRequest<AnalyticsEntity>(entityName: "AnalyticsEntity")
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \AnalyticsEntity.date, ascending: true)]
        
        return (try? context.fetch(request)) ?? []
    }
    
    private func calculateProductivityScore(completed: Int, created: Int) -> Double {
        if created == 0 { return 100.0 }
        let ratio = Double(completed) / Double(created)
        return min(ratio * 100, 100.0)
    }
    
    // MARK: - Educational Tips
    
    func seedEducationalTips() {
        let existingTips = fetchAllEducationalTips()
        if !existingTips.isEmpty { return }
        
        let tips = [
            ("Pomodoro Technique", "Work in 25-minute focused intervals with 5-minute breaks. This helps maintain concentration and prevents burnout.", "Time Management"),
            ("Eisenhower Matrix", "Prioritize tasks by urgency and importance. Focus on important but not urgent tasks to prevent last-minute rushes.", "Planning"),
            ("Two-Minute Rule", "If a task takes less than two minutes, do it immediately. This prevents small tasks from piling up.", "Productivity"),
            ("Time Blocking", "Schedule specific time blocks for different types of work. This creates structure and reduces decision fatigue.", "Time Management"),
            ("Morning Routine", "Start your day with a consistent routine. This sets a positive tone and improves overall productivity.", "Focus"),
            ("Single-Tasking", "Focus on one task at a time. Multitasking reduces efficiency and increases errors.", "Focus"),
            ("Team Standup", "Brief daily team meetings keep everyone aligned and identify blockers early.", "Teamwork"),
            ("Clear Communication", "Be explicit in your communication. Ambiguity leads to misunderstandings and wasted time.", "Teamwork"),
            ("Regular Breaks", "Take regular breaks to maintain mental clarity. Your brain needs rest to perform optimally.", "Productivity"),
            ("Goal Setting", "Set SMART goals (Specific, Measurable, Achievable, Relevant, Time-bound) for better results.", "Planning")
        ]
        
        for (title, content, category) in tips {
            let tip = EducationalTipEntity(context: context)
            tip.id = UUID()
            tip.title = title
            tip.content = content
            tip.category = category
            tip.isRead = false
            tip.createdAt = Date()
        }
        
        PersistenceController.shared.save()
    }
    
    func fetchAllEducationalTips() -> [EducationalTipEntity] {
        let request = NSFetchRequest<EducationalTipEntity>(entityName: "EducationalTipEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \EducationalTipEntity.createdAt, ascending: false)]
        return (try? context.fetch(request)) ?? []
    }
    
    func markTipAsRead(tip: EducationalTipEntity) {
        tip.isRead = true
        PersistenceController.shared.save()
    }
    
    // MARK: - Seed Data
    
    func seedSampleData() {
        let projects = fetchAllProjects()
        if !projects.isEmpty { return }
        
        // Create sample projects
        createProject(name: "Mobile App Development", description: "Build a new iOS application", startDate: Date(), endDate: Calendar.current.date(byAdding: .month, value: 3, to: Date()), color: "#4CAF50")
        createProject(name: "Marketing Campaign", description: "Q1 marketing initiatives", startDate: Date(), endDate: Calendar.current.date(byAdding: .month, value: 2, to: Date()), color: "#2196F3")
        
        // Create sample team members
        createTeamMember(name: "Sarah Johnson", email: "sarah@taskmaestro.com", role: "Project Manager", avatarColor: "#FF6B6B")
        createTeamMember(name: "Mike Chen", email: "mike@taskmaestro.com", role: "Developer", avatarColor: "#4ECDC4")
        createTeamMember(name: "Emily Davis", email: "emily@taskmaestro.com", role: "Designer", avatarColor: "#95E1D3")
        
        // Create sample tasks
        let allProjects = fetchAllProjects()
        let teamMembers = fetchAllTeamMembers()
        
        if let project = allProjects.first, let member = teamMembers.first {
            createTask(title: "Design UI Mockups", description: "Create initial design concepts", priority: .high, dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()), projectID: project.id, assignedToID: member.id)
            createTask(title: "Setup Development Environment", description: "Configure Xcode and dependencies", priority: .urgent, dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()), projectID: project.id)
            createTask(title: "Write Technical Specifications", description: "Document technical requirements", priority: .medium, dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()), projectID: project.id)
        }
        
        seedEducationalTips()
    }
}
