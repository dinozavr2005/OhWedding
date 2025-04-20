import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/HomeView.swift", line: 1)
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WeddingViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: __designTimeInteger("#10408_0", fallback: 24)) {
                    CountdownView()
                    QuickActionsGridView()
                    ProgressOverviewView()
                }
                .padding()
            }
            .navigationTitle(__designTimeString("#10408_1", fallback: "OH Wedding"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add settings action
                    }) {
                        Image(systemName: __designTimeString("#10408_2", fallback: "gear"))
                    }
                }
            }
        }
    }
}

// MARK: - Home Components
struct CountdownView: View {
    @EnvironmentObject var viewModel: WeddingViewModel
    
    var body: some View {
        VStack(spacing: __designTimeInteger("#10408_3", fallback: 8)) {
            Text(__designTimeString("#10408_4", fallback: "До свадьбы осталось"))
                .font(.title3)
            Text("\(viewModel.daysUntilWedding)")
                .font(.system(size: __designTimeInteger("#10408_5", fallback: 72), weight: .bold))
                .foregroundColor(.pink)
            Text(__designTimeString("#10408_6", fallback: "дней"))
                .font(.title3)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: __designTimeInteger("#10408_7", fallback: 20))
                .fill(Color.white)
                .shadow(radius: __designTimeInteger("#10408_8", fallback: 5))
        )
    }
}

struct QuickActionsGridView: View {
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: __designTimeInteger("#10408_9", fallback: 16)) {
            NavigationLink(destination: TaskListView()) {
                QuickActionCard(
                    title: __designTimeString("#10408_10", fallback: "Список задач"),
                    icon: __designTimeString("#10408_11", fallback: "list.bullet.clipboard"),
                    color: .blue
                )
            }
            
            NavigationLink(destination: GuestListView()) {
                QuickActionCard(
                    title: __designTimeString("#10408_12", fallback: "Гости"),
                    icon: __designTimeString("#10408_13", fallback: "person.2.fill"),
                    color: .green
                )
            }
            
            NavigationLink(destination: BudgetView()) {
                QuickActionCard(
                    title: __designTimeString("#10408_14", fallback: "Бюджет"),
                    icon: __designTimeString("#10408_15", fallback: "dollarsign.circle.fill"),
                    color: .purple
                )
            }
            
            NavigationLink(destination: Text(__designTimeString("#10408_16", fallback: "Вдохновение"))) {
                QuickActionCard(
                    title: __designTimeString("#10408_17", fallback: "Вдохновение"),
                    icon: __designTimeString("#10408_18", fallback: "heart.fill"),
                    color: .pink
                )
            }
        }
        .padding(.horizontal)
    }
}

struct ProgressOverviewView: View {
    @EnvironmentObject var viewModel: WeddingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: __designTimeInteger("#10408_19", fallback: 16)) {
            Text(__designTimeString("#10408_20", fallback: "Прогресс подготовки"))
                .font(.headline)
            
            ProgressBar(value: viewModel.progressPercentage)
            
            HStack {
                ProgressStat(
                    title: __designTimeString("#10408_21", fallback: "Задачи"),
                    value: "\(viewModel.weddingInfo.completedTasks)/\(viewModel.weddingInfo.totalTasks)"
                )
                Spacer()
                ProgressStat(
                    title: __designTimeString("#10408_22", fallback: "Гости"),
                    value: "\(viewModel.weddingInfo.confirmedGuests)/\(viewModel.weddingInfo.totalGuests)"
                )
                Spacer()
                ProgressStat(
                    title: __designTimeString("#10408_23", fallback: "Бюджет"),
                    value: String(format: __designTimeString("#10408_24", fallback: "%.0f%%"), (viewModel.budgetViewModel.totalExpenses / viewModel.weddingInfo.budget) * __designTimeInteger("#10408_25", fallback: 100))
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: __designTimeInteger("#10408_26", fallback: 20))
                .fill(Color.white)
                .shadow(radius: __designTimeInteger("#10408_27", fallback: 5))
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
                .font(.system(size: __designTimeInteger("#10408_28", fallback: 30)))
                .foregroundColor(color)
                .frame(width: __designTimeInteger("#10408_29", fallback: 60), height: __designTimeInteger("#10408_30", fallback: 60))
                .background(
                    Circle()
                        .fill(color.opacity(__designTimeFloat("#10408_31", fallback: 0.2)))
                )
            
            Text(title)
                .font(.system(size: __designTimeInteger("#10408_32", fallback: 16), weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: __designTimeInteger("#10408_33", fallback: 15))
                .fill(Color.white)
                .shadow(radius: __designTimeInteger("#10408_34", fallback: 3))
        )
    }
}

struct ProgressBar: View {
    let value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: __designTimeInteger("#10408_35", fallback: 8))
                    .fill(Color.gray.opacity(__designTimeFloat("#10408_36", fallback: 0.2)))
                    .frame(height: __designTimeInteger("#10408_37", fallback: 8))
                
                RoundedRectangle(cornerRadius: __designTimeInteger("#10408_38", fallback: 8))
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * value, height: __designTimeInteger("#10408_39", fallback: 8))
            }
        }
        .frame(height: __designTimeInteger("#10408_40", fallback: 8))
    }
}

struct ProgressStat: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: __designTimeInteger("#10408_41", fallback: 4)) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: __designTimeInteger("#10408_42", fallback: 16), weight: .medium))
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WeddingViewModel())
} 
