//
//  MainTabView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

// MARK: - MainTabView

struct MainTabView: View {
    
    // MARK: - State
    
    @State private var selectedTab = 0
    @Environment(\.modelContext) private var context
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selectedTab) {
            homeTab
            tasksTab
            guestsTab
            budgetTab
        }
        .tint(Color(hex: "6C5CE7"))
    }
}

// MARK: - Tabs

private extension MainTabView {
    
    var homeTab: some View {
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
    }
    
    var tasksTab: some View {
        NavigationView {
            TaskListView()
        }
        .tabItem {
            Label {
                Text("Задачи")
            } icon: {
                Image("checklistIcon")
                    .renderingMode(.template)
            }
        }
        .tag(1)
    }
    
    var guestsTab: some View {
        NavigationView {
            GuestListView()
        }
        .tabItem {
            Label("Гости", systemImage: "person.2.fill")
        }
        .tag(2)
    }
    
    var budgetTab: some View {
        NavigationView {
            BudgetView()
        }
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
}

// MARK: - Preview

#Preview {
    MainTabView()
}
