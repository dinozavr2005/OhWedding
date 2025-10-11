//
//  TaskListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = TaskViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // MARK: - Задания
                Section(header: Text("Задания").font(.headline)) {
                    NavigationLink(destination: AssignmentListView()
                        .environmentObject(viewModel)) {
                        ChecklistCell(
                            title: "Задания",
                            completedCount: viewModel.brideTasksCompleted,
                            totalCount: viewModel.brideTasksTotal,
                            color: .purple
                        )
                    }
                }

                // MARK: - Чек-листы
                Section(header: Text("Чек-листы").font(.headline)) {
                    NavigationLink(destination: WeddingCheckListView()
                        .environmentObject(viewModel)) {
                            ChecklistCell(
                                title: "Чек-лист свадьбы",
                                completedCount: viewModel.weddingChecklistCompleted,
                                totalCount: viewModel.weddingChecklistTotal,
                                color: .green
                            )
                        }

                    NavigationLink(destination: BrideAndGroomChecklistView(isBride: true)
                        .environmentObject(viewModel)) {
                            ChecklistCell(
                                title: "Чек-лист невесты",
                                completedCount: viewModel.brideCheckListCompleted,
                                totalCount: viewModel.brideCheckListTotal,
                                color: .pink
                            )
                        }

                    NavigationLink(destination: BrideAndGroomChecklistView(isBride: false)
                        .environmentObject(viewModel)) {
                            ChecklistCell(
                                title: "Чек-лист жениха",
                                completedCount: viewModel.groomChecklistCompleted,
                                totalCount: viewModel.groomChecklistTotal,
                                color: .blue
                            )
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Задачи")
        .background(Color.gray.opacity(0.1))
        .onAppear {
            // когда SwiftData создаст реальный контекст — обновим ViewModel
            viewModel.updateContext(context)
        }
    }
}

#Preview {
    NavigationView {
        TaskListView()
    }
}
