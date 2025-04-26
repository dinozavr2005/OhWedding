import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                NavigationLink(destination: Text("Рекомендации")) {
                    ChecklistCell(
                        title: "Рекомендации",
                        completedCount: viewModel.recommendationsCompleted,
                        totalCount: viewModel.recommendationsTotal,
                        color: .blue
                    )
                }
                
                NavigationLink {
                    BrideAndGroomChecklistView()
                        .environmentObject(viewModel)   // ← здесь
                } label: {
                    ChecklistCell(
                        title: "Чек‑лист жених и невеста",
                        completedCount: viewModel.coupleChecklistCompleted,
                        totalCount: viewModel.coupleChecklistTotal,
                        color: .pink
                    )
                }

                NavigationLink(destination: Text("Задание для невесты")) {
                    ChecklistCell(
                        title: "Задание для невесты",
                        completedCount: viewModel.brideTasksCompleted,
                        totalCount: viewModel.brideTasksTotal,
                        color: .purple
                    )
                }
                
                NavigationLink(destination: Text("Чек-лист для свадьбы")) {
                    ChecklistCell(
                        title: "Чек-лист для свадьбы",
                        completedCount: viewModel.weddingChecklistCompleted,
                        totalCount: viewModel.weddingChecklistTotal,
                        color: .green
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Задачи")
        .background(Color.gray.opacity(0.1))
    }
}

#Preview {
    NavigationView {
        TaskListView()
    }
} 
