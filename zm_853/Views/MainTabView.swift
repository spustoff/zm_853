//
//  MainTabView.swift
//  Task Maestro
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Navigation Bar
                HStack {
                    Text("Task Maestro")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(hex: "FCD826"))
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                // Content
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                    
                    TasksView()
                        .tag(1)
                    
                    ProjectsView()
                        .tag(2)
                    
                    AnalyticsView()
                        .tag(3)
                    
                    SettingsView()
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Custom Tab Bar
                HStack(spacing: 0) {
                    TabBarButton(icon: "house.fill", title: "Home", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    TabBarButton(icon: "checkmark.circle.fill", title: "Tasks", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    
                    TabBarButton(icon: "folder.fill", title: "Projects", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    
                    TabBarButton(icon: "chart.bar.fill", title: "Analytics", isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                    
                    TabBarButton(icon: "gear", title: "Settings", isSelected: selectedTab == 4) {
                        selectedTab = 4
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .foregroundColor(isSelected ? Color(hex: "FCD826") : .white.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.white.opacity(0.1) : Color.clear
            )
            .cornerRadius(12)
        }
    }
}
