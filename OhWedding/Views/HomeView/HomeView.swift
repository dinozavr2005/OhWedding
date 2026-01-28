//
//  HomeView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

// MARK: - HomeView

struct HomeView: View {

    // MARK: - Dependencies

    @Environment(\.modelContext) private var modelContext

    // MARK: - State
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var guestVM = GuestViewModel()
    @StateObject private var taskVM = TaskViewModel()
    @StateObject private var weddingVM = WeddingInfoViewModel()

    @State private var showingSettings = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            content
                .navigationTitle(weddingVM.weddingTitle)
                .navigationBarTitleDisplayMode(.large)
                .toolbar { settingsToolbar }
                .sheet(isPresented: $showingSettings) { settingsSheet }
                .task { loadIfNeeded() }
                .onAppear {
                    if homeVM.isLoaded {
                        refreshHome()
                    }
                }
        }
    }
}

// MARK: - Content

private extension HomeView {

    var content: some View {
        ScrollView {
            VStack(spacing: 24) {
                CountdownCard(days: weddingVM.daysUntilWedding)

                QuickActionsGridView()

                if homeVM.progressPercentage > 0 {
                    ProgressOverviewView(
                        progress: homeVM.progressPercentage,
                        completedTasks: homeVM.completedTasks,
                        totalTasks: homeVM.totalTasks,
                        totalGuestsWithPlusOne: homeVM.totalGuestsWithPlusOne
                    )
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 16)
        }
        .appBackground()
    }
}
// MARK: - Toolbar & Sheets

private extension HomeView {

    var settingsToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .foregroundColor(.black)
            }
        }
    }

    var settingsSheet: some View {
        WeddingSettingsView()
            .environmentObject(weddingVM)
    }
}

// MARK: - Loading

private extension HomeView {

    func loadIfNeeded() {
        homeVM.loadIfNeeded(
            using: modelContext,
            weddingVM: weddingVM,
            guestVM: guestVM,
            taskVM: taskVM
        )
    }

    func refreshHome() {
        guestVM.loadGuests(using: modelContext)
        guestVM.loadTables(using: modelContext)
        taskVM.updateContext(modelContext)
        homeVM.refreshProgress(guestVM: guestVM, taskVM: taskVM)
    }
}

// MARK: - QuickActionsGridView

struct QuickActionsGridView: View {

    // MARK: - Layout

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    // MARK: - Body

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            NavigationLink(destination: TaskListView()) {
                QuickActionCard(
                    title: "Список задач",
                    image: Image("List"),
                    color: Color(hex: "4ECDC4")
                )
            }

            NavigationLink(destination: GuestListView()) {
                QuickActionCard(
                    title: "Гости",
                    image: Image(systemName: "person.2.fill"),
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

            NavigationLink(destination: TimingView()) {
                QuickActionCard(
                    title: "Тайминг",
                    image: Image(systemName: "clock"),
                    color: Color(hex: "E792FC")
                )
            }
        }
    }
}


// MARK: - Preview

#Preview {
    HomeView()
}
