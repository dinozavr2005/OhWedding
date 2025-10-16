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
                    Label {
                        Text("Главная")
                    } icon: {
                        Image("houseIcon")
                            .renderingMode(.template)
                    }
                }
                .tag(0)

            TasksTabView()
                .tabItem {
                    Label {
                        Text("Задачи")
                    } icon: {
                        Image("checklistIcon")
                            .renderingMode(.template)
                    }
                }
                .tag(1)

            GuestsTabView()
                .tabItem {
                    Label("Гости", systemImage: "person.2.fill")
                }
                .tag(2)

            BudgetTabView()
                .tabItem {
                    Label {
                        Text("Бюджет")
                    } icon: {
                        Image("banknote")
                            .renderingMode(.template)
                    }
                }
                .tag(3)
        }
        .tint(Color(hex: "6C5CE7"))
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
