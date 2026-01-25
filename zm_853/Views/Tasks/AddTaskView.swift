//
//  AddTaskView.swift
//  Task Maestro
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: TaskViewModel
    let projects: [ProjectEntity]
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedPriority: TaskModel.Priority = .medium
    @State private var dueDate = Date()
    @State private var hasDueDate = false
    @State private var selectedProject: ProjectEntity?
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("New Task")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: createTask) {
                        Text("Create")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "FCD826"))
                    }
                    .disabled(title.isEmpty)
                    .opacity(title.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Title Input
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                TextField("Enter task title", text: $title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            }
                            .padding(16)
                        }
                        
                        // Description Input
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                TextEditor(text: $description)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .frame(height: 100)
                                    .background(Color.clear)
                            }
                            .padding(16)
                        }
                        
                        // Priority Selection
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Priority")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                HStack(spacing: 8) {
                                    ForEach([TaskModel.Priority.low, .medium, .high, .urgent], id: \.self) { priority in
                                        Button(action: {
                                            selectedPriority = priority
                                        }) {
                                            Text(priority.displayName)
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(selectedPriority == priority ? .white : .white.opacity(0.7))
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(selectedPriority == priority ? Color(hex: priority.color) : Color.white.opacity(0.1))
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                        
                        // Due Date
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 12) {
                                Toggle(isOn: $hasDueDate) {
                                    Text("Set Due Date")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .tint(Color(hex: "FCD826"))
                                
                                if hasDueDate {
                                    DatePicker("", selection: $dueDate, displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                        .colorScheme(.dark)
                                }
                            }
                            .padding(16)
                        }
                        
                        // Project Selection
                        if !projects.isEmpty {
                            GlassmorphicCard(opacity: 0.1) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Project (Optional)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                selectedProject = nil
                                            }) {
                                                Text("None")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundColor(selectedProject == nil ? Color(hex: "081567") : .white)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(selectedProject == nil ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                                    )
                                            }
                                            
                                            ForEach(projects) { project in
                                                Button(action: {
                                                    selectedProject = project
                                                }) {
                                                    HStack(spacing: 6) {
                                                        Circle()
                                                            .fill(Color(hex: project.color))
                                                            .frame(width: 8, height: 8)
                                                        Text(project.name)
                                                            .font(.system(size: 12, weight: .semibold))
                                                    }
                                                    .foregroundColor(selectedProject?.id == project.id ? Color(hex: "081567") : .white)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(selectedProject?.id == project.id ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                                    )
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(16)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private func createTask() {
        viewModel.createTask(
            title: title,
            description: description,
            priority: selectedPriority,
            dueDate: hasDueDate ? dueDate : nil,
            projectID: selectedProject?.id
        )
        presentationMode.wrappedValue.dismiss()
    }
}
