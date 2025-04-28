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

    @State private var title: String = ""
    @State private var category: TaskCategory = .general

    // Категории, которые вам нужны именно в этом списке
    private let sections: [TaskCategory] = [.general, .brideTasks, .coupleChecklist]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название задачи")) {
                    TextField("Что нужно сделать", text: $title)
                }
            }
            .navigationTitle("Новая задача")
            .navigationBarItems(
                leading: Button("Отменить") {
                    isPresented = false
                },
                trailing: Button("Сохранить") {
                    let newTask = WeddingTask(
                        title: title,
                        isCompleted: false,
                        dueDate: nil,
                        category: category
                    )
                    viewModel.addTask(newTask)
                    isPresented = false
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
            )
        }
    }
}
