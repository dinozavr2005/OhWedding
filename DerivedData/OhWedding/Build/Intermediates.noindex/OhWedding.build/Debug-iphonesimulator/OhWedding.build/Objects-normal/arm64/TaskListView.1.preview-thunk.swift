import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/Task/TaskListView.swift", line: 1)
import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: __designTimeInteger("#14716_0", fallback: 16)) {
                NavigationLink(destination: Text(__designTimeString("#14716_1", fallback: "Рекомендации"))) {
                    ChecklistCell(
                        title: __designTimeString("#14716_2", fallback: "Рекомендации"),
                        completedCount: viewModel.recommendationsCompleted,
                        totalCount: viewModel.recommendationsTotal,
                        color: .blue
                    )
                }
                
                NavigationLink(destination: Text(__designTimeString("#14716_3", fallback: "Чек-лист жених и невеста"))) {
                    ChecklistCell(
                        title: __designTimeString("#14716_4", fallback: "Чек-лист жених и невеста"),
                        completedCount: viewModel.coupleChecklistCompleted,
                        totalCount: viewModel.coupleChecklistTotal,
                        color: .pink
                    )
                }
                
                NavigationLink(destination: Text(__designTimeString("#14716_5", fallback: "Задание для невесты"))) {
                    ChecklistCell(
                        title: __designTimeString("#14716_6", fallback: "Задание для невесты"),
                        completedCount: viewModel.brideTasksCompleted,
                        totalCount: viewModel.brideTasksTotal,
                        color: .purple
                    )
                }
                
                NavigationLink(destination: Text(__designTimeString("#14716_7", fallback: "Чек-лист для свадьбы"))) {
                    ChecklistCell(
                        title: __designTimeString("#14716_8", fallback: "Чек-лист для свадьбы"),
                        completedCount: viewModel.weddingChecklistCompleted,
                        totalCount: viewModel.weddingChecklistTotal,
                        color: .green
                    )
                }
            }
            .padding()
        }
        .navigationTitle(__designTimeString("#14716_9", fallback: "Задачи"))
        .background(Color.gray.opacity(__designTimeFloat("#14716_10", fallback: 0.1)))
    }
}

#Preview {
    NavigationView {
        TaskListView()
    }
} 
