//
//  MainTabView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(0)

            TasksTabView()
                .tabItem {
                    Label("Задачи", systemImage: "list.bullet.clipboard")
                }
                .tag(1)

            GuestsTabView()
                .tabItem {
                    Label("Гости", systemImage: "person.2.fill")
                }
                .tag(2)

            BudgetTabView()
                .tabItem {
                    Label("Бюджет", systemImage: "dollarsign.circle.fill")
                }
                .tag(3)
        }
        .onAppear {
            DataSeeder.seedAssignmentsIfNeeded(context: context)
        }
    }
}

// MARK: - Tab Views
struct TasksTabView: View {
    var body: some View {
        NavigationView {
            TaskListView()
        }
    }
}

struct GuestsTabView: View {
    var body: some View {
        NavigationView {
            GuestListView()
        }
    }
}

struct BudgetTabView: View {
    var body: some View {
        NavigationView {
            BudgetView()
        }
    }
}

#Preview {
    MainTabView()
} 
