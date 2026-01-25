//
//  ProjectDetailView.swift
//  Task Maestro
//

import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let project: ProjectEntity
    let viewModel: ProjectViewModel
    @State private var showDeleteAlert = false
    
    var tasks: [TaskEntity] {
        (project.tasks?.allObjects as? [TaskEntity]) ?? []
    }
    
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
                        // Project Header
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(hex: project.color))
                                .frame(width: 24, height: 24)
                            
                            Text(project.name)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        if let description = project.projectDescription, !description.isEmpty {
                            Text(description)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                                .lineSpacing(4)
                        }
                        
                        // Progress Card
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Overall Progress")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                    Spacer()
                                    Text("\(Int(project.progress * 100))%")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                
                                ProgressView(value: project.progress)
                                    .tint(Color(hex: "FCD826"))
                            }
                            .padding(16)
                        }
                        
                        // Stats
                        HStack(spacing: 12) {
                            GlassmorphicCard(opacity: 0.1) {
                                VStack(spacing: 8) {
                                    Text("\(tasks.count)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    Text("Total Tasks")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                            }
                            
                            GlassmorphicCard(opacity: 0.1) {
                                VStack(spacing: 8) {
                                    Text("\(tasks.filter { $0.status == "completed" }.count)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(Color(hex: "4CAF50"))
                                    Text("Completed")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                            }
                        }
                        
                        // Timeline
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Timeline")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Start Date")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.7))
                                        Text(project.startDate, style: .date)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    if let endDate = project.endDate {
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("End Date")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.7))
                                            Text(endDate, style: .date)
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                        
                        // Tasks List
                        if !tasks.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Tasks (\(tasks.count))")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                
                                ForEach(tasks.sorted(by: { $0.createdAt > $1.createdAt })) { task in
                                    GlassmorphicCard(opacity: 0.1) {
                                        HStack(spacing: 12) {
                                            Image(systemName: task.status == "completed" ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 20))
                                                .foregroundColor(task.status == "completed" ? Color(hex: "4CAF50") : .white.opacity(0.4))
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(task.title)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(.white)
                                                
                                                if let priority = TaskModel.Priority(rawValue: task.priority) {
                                                    Text(priority.displayName)
                                                        .font(.system(size: 10, weight: .semibold))
                                                        .foregroundColor(.white)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 4)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 6)
                                                                .fill(Color(hex: priority.color).opacity(0.3))
                                                        )
                                                }
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(12)
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Project"),
                message: Text("Are you sure you want to delete this project and all its tasks?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteProject(project: project)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
