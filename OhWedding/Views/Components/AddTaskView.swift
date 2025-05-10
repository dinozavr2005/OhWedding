//
//  AddTaskView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 26.04.2025.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @Binding var isPresented: Bool
    var category: TaskCategory  // Принимаем категорию задачи

    @State private var taskTitle: String = ""

    // Устанавливаем фон
    var body: some View {
        NavigationView {
            VStack {
                TextField("Введите название задачи", text: $taskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Добавить задачу") {
                    addTask()  // Добавляем задачу
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Добавить задачу")
            .navigationBarItems(trailing: Button("Закрыть") {
                isPresented = false
            })
            .background(Color(.systemBackground))
        }
    }

    private func addTask() {
        // Создаем новую задачу
        let newTask = WeddingTask(title: taskTitle, isCompleted: false, dueDate: Date(), category: category)

        // Добавляем задачу в соответствующую категорию
        viewModel.addTask(newTask)

        // Закрываем модальное окно и обновляем список
        isPresented = false
    }
}

#Preview {
    AddTaskView(isPresented: .constant(true), category: .weddingChecklist)
        .environmentObject(TaskViewModel())
}
