//
//  TaskListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Tasks Section
                Section(header: Text("Задания").font(.headline)) {
                        NavigationLink(destination: AssignmentListView()
                                        .environmentObject(viewModel)) {  // Передаем вью модель через environmentObject
                            ChecklistCell(
                                title: "Задания",
                                completedCount: viewModel.brideTasksCompleted,
                                totalCount: viewModel.brideTasksTotal,
                                color: .purple
                            )
                        }
                    }

                // Checklists Section
                Section(header: Text("Чек-листы").font(.headline)) {
                    NavigationLink(destination: WeddingCheckListView()
                                    .environmentObject(viewModel)) {  // Переход на чек-лист свадьбы
                        ChecklistCell(
                            title: "Чек-лист свадьбы",
                            completedCount: viewModel.weddingChecklistCompleted,
                            totalCount: viewModel.weddingChecklistTotal,
                            color: .green
                        )
                    }

                    // Переход на чек-лист для невесты
                    NavigationLink(destination: BrideAndGroomChecklistView(isBride: true)
                                    .environmentObject(viewModel)) {
                        ChecklistCell(
                            title: "Чек-лист невесты",
                            completedCount: viewModel.brideCheckListCompleted,
                            totalCount: viewModel.brideCheckListTotal,
                            color: .pink
                        )
                    }

                    // Переход на чек-лист для жениха
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
    }
}

#Preview {
    NavigationView {
        TaskListView()
    }
}
