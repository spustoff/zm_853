//
//  TaskDetailView.swift
//  Task Maestro
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let task: TaskEntity
    let viewModel: TaskViewModel
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                    
                    Spacer()
                    
                    Text("Task Details")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "F44336"))
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        Text(task.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Description
                        if let description = task.taskDescription, !description.isEmpty {
                            GlassmorphicCard(opacity: 0.1) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Description")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Text(description)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .lineSpacing(4)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                            }
                        }
                        
                        // Status
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Status")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                    Spacer()
                                }
                                
                                HStack(spacing: 8) {
                                    ForEach([TaskModel.TaskStatus.pending, .inProgress, .completed, .blocked], id: \.self) { status in
                                        Button(action: {
                                            viewModel.updateTaskStatus(task: task, status: status)
                                        }) {
                                            Text(status.displayName)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(task.status == status.rawValue ? Color(hex: "081567") : .white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(task.status == status.rawValue ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                        
                        // Details Grid
                        VStack(spacing: 12) {
                            DetailRow(icon: "flag.fill", label: "Priority", value: (TaskModel.Priority(rawValue: task.priority) ?? .medium).displayName, color: Color(hex: (TaskModel.Priority(rawValue: task.priority) ?? .medium).color))
                            
                            if let dueDate = task.dueDate {
                                DetailRow(icon: "calendar", label: "Due Date", value: formatDate(dueDate), color: Color(hex: "FCD826"))
                            }
                            
                            DetailRow(icon: "clock", label: "Created", value: formatDate(task.createdAt), color: Color(hex: "2196F3"))
                            
                            if task.estimatedHours > 0 {
                                DetailRow(icon: "timer", label: "Estimated", value: "\(Int(task.estimatedHours))h", color: Color(hex: "9C27B0"))
                            }
                            
                            if let project = task.project {
                                DetailRow(icon: "folder.fill", label: "Project", value: project.name, color: Color(hex: project.color))
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Task"),
                message: Text("Are you sure you want to delete this task?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteTask(task: task)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        GlassmorphicCard(opacity: 0.1) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(16)
        }
    }
}
