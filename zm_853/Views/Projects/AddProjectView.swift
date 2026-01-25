//
//  AddProjectView.swift
//  Task Maestro
//

import SwiftUI

struct AddProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: ProjectViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var hasEndDate = false
    @State private var selectedColor = "#FCD826"
    
    let colors = ["#FCD826", "#4CAF50", "#2196F3", "#F44336", "#9C27B0", "#FF9800", "#00BCD4", "#E91E63"]
    
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
                    
                    Text("New Project")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: createProject) {
                        Text("Create")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "FCD826"))
                    }
                    .disabled(name.isEmpty)
                    .opacity(name.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Name Input
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Project Name")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                TextField("Enter project name", text: $name)
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
                        
                        // Color Selection
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Project Color")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 12) {
                                    ForEach(colors, id: \.self) { color in
                                        Button(action: {
                                            selectedColor = color
                                        }) {
                                            Circle()
                                                .fill(Color(hex: color))
                                                .frame(width: 40, height: 40)
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                                )
                                        }
                                    }
                                }
                            }
                            .padding(16)
                        }
                        
                        // Start Date
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Start Date")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                DatePicker("", selection: $startDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .colorScheme(.dark)
                            }
                            .padding(16)
                        }
                        
                        // End Date
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(spacing: 12) {
                                Toggle(isOn: $hasEndDate) {
                                    Text("Set End Date")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .tint(Color(hex: "FCD826"))
                                
                                if hasEndDate {
                                    DatePicker("", selection: $endDate, in: startDate..., displayedComponents: .date)
                                        .datePickerStyle(.graphical)
                                        .colorScheme(.dark)
                                }
                            }
                            .padding(16)
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private func createProject() {
        viewModel.createProject(
            name: name,
            description: description,
            startDate: startDate,
            endDate: hasEndDate ? endDate : nil,
            color: selectedColor
        )
        presentationMode.wrappedValue.dismiss()
    }
}
