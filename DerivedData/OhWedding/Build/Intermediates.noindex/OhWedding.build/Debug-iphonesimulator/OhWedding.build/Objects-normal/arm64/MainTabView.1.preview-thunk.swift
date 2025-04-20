import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/MainTabView.swift", line: 1)
import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = WeddingViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(__designTimeString("#10350_0", fallback: "Главная"), systemImage: __designTimeString("#10350_1", fallback: "house.fill"))
                }
                .tag(__designTimeInteger("#10350_2", fallback: 0))
            
            TasksTabView()
                .tabItem {
                    Label(__designTimeString("#10350_3", fallback: "Задачи"), systemImage: __designTimeString("#10350_4", fallback: "list.bullet.clipboard"))
                }
                .tag(__designTimeInteger("#10350_5", fallback: 1))
            
            GuestsTabView()
                .tabItem {
                    Label(__designTimeString("#10350_6", fallback: "Гости"), systemImage: __designTimeString("#10350_7", fallback: "person.2.fill"))
                }
                .tag(__designTimeInteger("#10350_8", fallback: 2))
            
            BudgetTabView()
                .tabItem {
                    Label(__designTimeString("#10350_9", fallback: "Бюджет"), systemImage: __designTimeString("#10350_10", fallback: "dollarsign.circle.fill"))
                }
                .tag(__designTimeInteger("#10350_11", fallback: 3))
        }
        .environmentObject(viewModel)
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
