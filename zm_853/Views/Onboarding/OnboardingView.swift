//
//  OnboardingView.swift
//  Task Maestro
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPage(
                        icon: "checkmark.circle.fill",
                        title: "Organize Your Tasks",
                        description: "Create, manage, and track all your tasks in one place. Set priorities, deadlines, and never miss important work.",
                        pageIndex: 0
                    )
                    .tag(0)
                    
                    OnboardingPage(
                        icon: "chart.bar.fill",
                        title: "Track Your Progress",
                        description: "Visualize your productivity with interactive Gantt charts and comprehensive analytics dashboard.",
                        pageIndex: 1
                    )
                    .tag(1)
                    
                    OnboardingPage(
                        icon: "person.3.fill",
                        title: "Collaborate Efficiently",
                        description: "Work seamlessly with your team. Assign tasks, track progress, and achieve goals together.",
                        pageIndex: 2
                    )
                    .tag(2)
                    
                    OnboardingPage(
                        icon: "lightbulb.fill",
                        title: "Learn & Improve",
                        description: "Get educational tips on task management, productivity techniques, and team collaboration.",
                        pageIndex: 3
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(currentPage == index ? Color(hex: "FCD826") : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                if currentPage == 3 {
                    GlassmorphicButton(title: "Get Started", icon: "arrow.right") {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                    .transition(.opacity)
                } else {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("Next")
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(Color(hex: "FCD826"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    let pageIndex: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "FCD826"))
                .padding(.bottom, 20)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(6)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
