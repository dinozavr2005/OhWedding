//
//  HomeView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    CountdownView(viewModel: viewModel)
                    QuickActionsGridView()
                    ProgressOverviewView(viewModel: progressViewModel)
                }
                .padding()
            }
            .navigationTitle(viewModel.weddingTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                WeddingSettingsView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Home Components
struct CountdownView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text("До свадьбы осталось")
                .font(.title3)
            Text("\(viewModel.daysUntilWedding)")
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(.pink)
            Text("дней")
                .font(.title3)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
    }
}

struct QuickActionsGridView: View {
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            NavigationLink(destination: TaskListView()) {
                QuickActionCard(
                    title: "Список задач",
                    icon: "list.bullet.clipboard",
                    color: .blue
                )
            }
            
            NavigationLink(destination: GuestListView()) {
                QuickActionCard(
                    title: "Гости",
                    icon: "person.2.fill",
                    color: .green
                )
            }
            
            NavigationLink(destination: BudgetView()) {
                QuickActionCard(
                    title: "Бюджет",
                    icon: "dollarsign.circle.fill",
                    color: .purple
                )
            }
            
            NavigationLink(destination: Text("Вдохновение")) {
                QuickActionCard(
                    title: "Вдохновение",
                    icon: "heart.fill",
                    color: .pink
                )
            }
        }
        .padding(.horizontal)
    }
}

struct ProgressOverviewView: View {
    @ObservedObject var viewModel: ProgressViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Прогресс подготовки")
                .font(.headline)
            
            ProgressBar(value: viewModel.progressPercentage)
            
            HStack {
                ProgressStat(
                    title: "Задачи",
                    value: "\(viewModel.completedTasks)/\(viewModel.totalTasks)"
                )
                Spacer()
                ProgressStat(
                    title: "Гости",
                    value: "\(viewModel.confirmedGuests)/\(viewModel.totalGuests)"
                )
                Spacer()
                ProgressStat(
                    title: "Бюджет",
                    value: String(format: "%.0f%%", (viewModel.totalExpenses / viewModel.totalBudget) * 100)
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
    }
}

// MARK: - Reusable Components
struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(radius: 3)
        )
    }
}

struct ProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * value, height: 8)
            }
        }
        .frame(height: 8)
    }
}

struct ProgressStat: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 16, weight: .medium))
        }
    }
}

#Preview {
    HomeView()
} 
