//
//  BrideAndGroomChecklistView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct BrideAndGroomChecklistView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var isPresentingAdd = false

    var body: some View {
        List {
            // Секция "Общее"
            Section(
                header: Text("Общее")
                    .font(.headline)
                    .foregroundColor(.indigo)
            ) {
                ForEach(WeddingChecklistData.commonTasks) { task in
                    if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                        TaskRowView(task: $viewModel.tasks[idx])
                    }
                }
                .onDelete { offsets in
                    // offsets — это индексы в commonTasks
                    offsets.forEach { i in
                        let taskToDelete = WeddingChecklistData.commonTasks[i]
                        viewModel.deleteTask(taskToDelete)
                    }
                }
            }

            // Секция "Невеста"
            Section(
                header: Text("Невеста")
                    .font(.headline)
                    .foregroundColor(.pink)
            ) {
                ForEach(WeddingChecklistData.brideTasks) { task in
                    if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                        TaskRowView(task: $viewModel.tasks[idx])
                    }
                }
                .onDelete { offsets in
                    offsets.forEach { i in
                        let taskToDelete = WeddingChecklistData.brideTasks[i]
                        viewModel.deleteTask(taskToDelete)
                    }
                }
            }

            // Секция "Жених"
            Section(
                header: Text("Жених")
                    .font(.headline)
                    .foregroundColor(.blue)
            ) {
                ForEach(WeddingChecklistData.groomTasks) { task in
                    if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                        TaskRowView(task: $viewModel.tasks[idx])
                    }
                }
                .onDelete { offsets in
                    offsets.forEach { i in
                        let taskToDelete = WeddingChecklistData.groomTasks[i]
                        viewModel.deleteTask(taskToDelete)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Чек-лист жених и невеста")
        .toolbar {
            // Кнопка «+»
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // Модальный экран
        .sheet(isPresented: $isPresentingAdd) {
            AddTaskView(isPresented: $isPresentingAdd)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    BrideAndGroomChecklistView()
        .environmentObject(TaskViewModel())
}
