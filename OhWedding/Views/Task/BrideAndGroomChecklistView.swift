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
    var isBride: Bool  // Флаг для определения, невеста ли это или жених

    var body: some View {
        List {
            // В зависимости от значения isBride, отображаем задачи для невесты или жениха
            let tasks = viewModel.tasks.filter { $0.category == (isBride ? .brideChecklist : .groomCheckList) }

            // Отображаем задачи для соответствующего чек-листа
            ForEach(tasks) { task in
                if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                    TaskRowView(task: $viewModel.tasks[idx])  // Отображение задачи
                }
            }
            .onDelete { offsets in
                // Для каждого удаляемого индекса удаляем задачу
                offsets.forEach { index in
                    let taskToDelete = tasks[index]
                    viewModel.deleteTask(taskToDelete)  // Удаление задачи из viewModel
                }
            }
        }
        .listStyle(InsetGroupedListStyle())  // Стиль списка
        .navigationTitle(isBride ? "Чек-лист невесты" : "Чек-лист жениха")  // Заголовок экрана
        .toolbar {
            // Кнопка для добавления задачи
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isPresentingAdd = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // Модальный экран для добавления новой задачи
        .sheet(isPresented: $isPresentingAdd) {
            // Передаем флаг isBride в AddTaskView, чтобы определить, в какую категорию добавить задачу
            AddTaskView(isPresented: $isPresentingAdd, category: isBride ? .brideChecklist : .groomCheckList)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    BrideAndGroomChecklistView(isBride: true)
        .environmentObject(TaskViewModel())
}

