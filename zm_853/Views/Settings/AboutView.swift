//
//  AboutView.swift
//  Task Maestro
//

import SwiftUI

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    
                    Text("About")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .overlay(
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(Color.white.opacity(0.1)))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                )
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // App Icon
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(hex: "FCD826"),
                                        Color(hex: "FCD826").opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("TM")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(Color(hex: "081567"))
                            )
                            .padding(.top, 20)
                        
                        VStack(spacing: 8) {
                            Text("Task Maestro")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Description
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("About Task Maestro")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Task Maestro is your ultimate productivity companion, combining powerful task management with educational insights to help you work smarter, not harder.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                                    .lineSpacing(6)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                        }
                        .padding(.horizontal, 20)
                        
                        // Features
                        GlassmorphicCard(opacity: 0.1) {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Key Features")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                
                                FeatureRow(icon: "checkmark.circle.fill", text: "Advanced task management with priorities")
                                FeatureRow(icon: "folder.fill", text: "Project organization and tracking")
                                FeatureRow(icon: "chart.bar.xaxis", text: "Interactive Gantt charts")
                                FeatureRow(icon: "chart.line.uptrend.xyaxis", text: "Comprehensive analytics dashboard")
                                FeatureRow(icon: "lightbulb.fill", text: "Educational productivity tips")
                                FeatureRow(icon: "person.3.fill", text: "Team collaboration features")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                        }
                        .padding(.horizontal, 20)
                        
                        // Categories
                        HStack(spacing: 12) {
                            CategoryBadge(title: "Business")
                            CategoryBadge(title: "Education")
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "FCD826"))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

struct CategoryBadge: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(Color(hex: "081567"))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "FCD826"))
            )
    }
}
