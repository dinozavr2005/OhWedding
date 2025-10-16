//
//  HomeView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var guestVM = GuestViewModel()
    @StateObject private var taskVM = TaskViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()

    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    CountdownCard(days: homeVM.daysUntilWedding)
                    QuickActionsGridView()
                    ProgressOverviewView(viewModel: progressViewModel)
                }
                .padding(.horizontal, 30)
                .padding(.top, 16)
            }
            .appBackground()
            .navigationTitle(homeVM.weddingTitle)
            .task {
                // загружаем данные
                guestVM.loadGuests(using: modelContext)
                guestVM.loadTables(using: modelContext)
                taskVM.updateContext(modelContext)

                // передаём в ProgressVM
                progressViewModel.updateGuestProgress(
                    confirmed: guestVM.confirmedGuestsWithPlusOne,
                    total: guestVM.totalGuestsWithPlusOne
                )

                progressViewModel.updateTaskProgress(
                    completed: taskVM.completedTasks,
                    total: taskVM.totalTasks
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                WeddingSettingsView(viewModel: homeVM)
            }
        }
    }
}

struct QuickActionsGridView: View {
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ],
            spacing: 20
        ) {
            NavigationLink(destination: TaskListView()) {
                QuickActionCard(
                    title: "Список задач",
                    image: Image("List"), // ассет
                    color: Color(hex: "4ECDC4")
                )
            }

            NavigationLink(destination: GuestListView()) {
                QuickActionCard(
                    title: "Гости",
                    image: Image(systemName: "person.2.fill"), // SF Symbol
                    color: Color(hex: "6C5CE7")
                )
            }

            NavigationLink(destination: BudgetView()) {
                QuickActionCard(
                    title: "Бюджет",
                    image: Image("budgetIcon"),
                    color: Color(hex: "F0AAFF")
                )
            }

            NavigationLink(destination: Text("Тайминг")) {
                QuickActionCard(
                    title: "Тайминг",
                    image: Image(systemName: "clock"),
                    color: Color(hex: "E792FC")
                )
            }
        }
    }
}

struct ProgressOverviewView: View {
    @ObservedObject var viewModel: ProgressViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Прогресс подготовки")
                .font(.manropeSemiBold(size: 18))

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
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct ProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // фон
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12) // увеличил высоту

                // прогресс с градиентом
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "4ECDC4"),
                                Color(hex: "6C5CE7")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * value, height: 12)
            }
        }
        .frame(height: 12)
    }
}

struct ProgressStat: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.manropeRegular(size: 12))
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 16, weight: .medium))
        }
    }
}

#Preview {
    HomeView()
} 
