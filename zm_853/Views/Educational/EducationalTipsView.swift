//
//  EducationalTipsView.swift
//  Task Maestro
//

import SwiftUI

struct EducationalTipsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var tips: [EducationalTipEntity] = []
    @State private var selectedCategory: String? = nil
    
    var categories: [String] {
        let allCategories = tips.map { $0.category }
        return Array(Set(allCategories)).sorted()
    }
    
    var filteredTips: [EducationalTipEntity] {
        if let category = selectedCategory {
            return tips.filter { $0.category == category }
        }
        return tips
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
                    
                    Text("Educational Tips")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 38, height: 38)
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                // Category Filter
                if !categories.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Button(action: {
                                selectedCategory = nil
                            }) {
                                Text("All")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(selectedCategory == nil ? Color(hex: "081567") : .white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(selectedCategory == nil ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                    )
                            }
                            
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(selectedCategory == category ? Color(hex: "081567") : .white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedCategory == category ? Color(hex: "FCD826") : Color.white.opacity(0.1))
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 16)
                }
                
                // Tips List
                ScrollView {
                    VStack(spacing: 12) {
                        if filteredTips.isEmpty {
                            GlassmorphicCard(opacity: 0.1) {
                                VStack(spacing: 16) {
                                    Image(systemName: "lightbulb")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white.opacity(0.4))
                                    
                                    Text("No tips available")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(40)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 40)
                        } else {
                            ForEach(filteredTips) { tip in
                                TipCard(tip: tip)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
            }
        }
        .onAppear {
            tips = DataService.shared.fetchAllEducationalTips()
        }
    }
}

struct TipCard: View {
    let tip: EducationalTipEntity
    @State private var showDetail = false
    
    var category: EducationalTipModel.TipCategory {
        EducationalTipModel.TipCategory(rawValue: tip.category) ?? .productivity
    }
    
    var body: some View {
        Button(action: {
            showDetail = true
        }) {
            GlassmorphicCard(opacity: 0.1) {
                HStack(spacing: 16) {
                    Image(systemName: category.icon)
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "FCD826"))
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(tip.title)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                        
                        Text(tip.category)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "FCD826"))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(16)
            }
        }
        .sheet(isPresented: $showDetail) {
            EducationalTipDetailView(tip: tip)
        }
    }
}

struct EducationalTipDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let tip: EducationalTipEntity
    
    var category: EducationalTipModel.TipCategory {
        EducationalTipModel.TipCategory(rawValue: tip.category) ?? .productivity
    }
    
    var body: some View {
        ZStack {
            Color(hex: "081567")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        DataService.shared.markTipAsRead(tip: tip)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.1)))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 50)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Icon
                        Image(systemName: category.icon)
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "FCD826"))
                            .padding(30)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                            )
                        
                        // Title
                        Text(tip.title)
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        // Category
                        Text(tip.category)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "081567"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "FCD826"))
                            )
                        
                        // Content
                        GlassmorphicCard(opacity: 0.1) {
                            Text(tip.content)
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                                .lineSpacing(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(20)
                        }
                        .padding(.horizontal, 20)
                        
                        // Action Button
                        GlassmorphicButton(title: "Got it!", icon: "checkmark.circle.fill") {
                            DataService.shared.markTipAsRead(tip: tip)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .onAppear {
            DataService.shared.markTipAsRead(tip: tip)
        }
    }
}
