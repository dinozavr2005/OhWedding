//
//  WeddingCheckListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.05.2025.
//

import SwiftUI

struct WeddingCheckListView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var isPresentingAdd = false

    var body: some View {
        List {
            // Отображаем все задачи с категорией .weddingChecklist из viewModel
            ForEach(viewModel.tasks.filter { $0.category == .weddingChecklist }) { task in
                if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                    TaskRowView(task: $viewModel.tasks[idx])  // Отображение задачи
                }
            }
            .onDelete { offsets in
                // Для каждого удаляемого индекса удаляем задачу
                offsets.forEach { offset in
                    // Ищем задачу с этим индексом среди задач, отфильтрованных по категории
                    let taskToDelete = viewModel.tasks.filter { $0.category == .weddingChecklist }[offset]
                    viewModel.deleteTask(taskToDelete)  // Удаление задачи из viewModel
                }
            }
        }
        .listStyle(InsetGroupedListStyle())  // Стиль списка
        .navigationTitle("Чек-лист свадьбы")  // Заголовок экрана
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
            // Передаем категорию .weddingChecklist в AddTaskView
            AddTaskView(isPresented: $isPresentingAdd, category: .weddingChecklist)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    WeddingCheckListView()
        .environmentObject(TaskViewModel())
}
