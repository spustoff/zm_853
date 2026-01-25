//
//  SettingsView.swift
//  Task Maestro
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    @State private var showDeleteAlert = false
    @State private var showAbout = false
    @State private var showEducationalTips = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Section
                GlassmorphicCard(opacity: 0.15) {
                    HStack(spacing: 16) {
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
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("TM")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(hex: "081567"))
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Task Maestro")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Master your productivity")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                }
                .padding(.horizontal, 20)
                
                // Learning Section
                VStack(spacing: 12) {
                    Text("Learning & Development")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    SettingsButton(
                        icon: "lightbulb.fill",
                        title: "Educational Tips",
                        subtitle: "Learn productivity techniques",
                        color: Color(hex: "FCD826")
                    ) {
                        showEducationalTips = true
                    }
                    
                    SettingsButton(
                        icon: "chart.bar.fill",
                        title: "View Analytics",
                        subtitle: "Track your progress",
                        color: Color(hex: "2196F3")
                    ) {
                        // Already accessible via tab bar
                    }
                }
                
                // App Settings
                VStack(spacing: 12) {
                    Text("App Settings")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    SettingsButton(
                        icon: "arrow.clockwise.circle.fill",
                        title: "Reset Onboarding",
                        subtitle: "View welcome screens again",
                        color: Color(hex: "9C27B0")
                    ) {
                        hasCompletedOnboarding = false
                    }
                    
                    SettingsButton(
                        icon: "info.circle.fill",
                        title: "About Task Maestro",
                        subtitle: "Version 1.0.0",
                        color: Color(hex: "00BCD4")
                    ) {
                        showAbout = true
                    }
                }
                
                // Privacy & Data
                VStack(spacing: 12) {
                    Text("Privacy & Data")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    GlassmorphicCard(opacity: 0.1) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "lock.shield.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "4CAF50"))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your Data is Private")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Text("All data is stored locally on your device")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Danger Zone
                VStack(spacing: 12) {
                    Text("Account Management")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        GlassmorphicCard(opacity: 0.1) {
                            HStack(spacing: 12) {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(hex: "F44336"))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Delete All Data")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(hex: "F44336"))
                                    
                                    Text("Reset app to initial state")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(16)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // App Info
                Text("Task Maestro v1.0.0")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 20)
                    .padding(.bottom, 40)
            }
            .padding(.vertical, 20)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete All Data"),
                message: Text("This will permanently delete all your tasks, projects, and data. This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    PersistenceController.shared.deleteAll()
                    hasCompletedOnboarding = false
                },
                secondaryButton: .cancel()
            )
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .sheet(isPresented: $showEducationalTips) {
            EducationalTipsView()
        }
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            GlassmorphicCard(opacity: 0.1) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(16)
            }
        }
        .padding(.horizontal, 20)
    }
}
