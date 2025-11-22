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
    var isBride: Bool

    // Задачи только нужной категории
    private var tasks: [WeddingTask] {
        viewModel.tasks.filter { $0.category == (isBride ? .brideChecklist : .groomCheckList) }
    }

    var body: some View {
        List {
            ForEach(tasks) { task in
                if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {

                    TaskCardView(task: $viewModel.tasks[idx])
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(
                            top: 6,      // ← расстояние между ячейками
                            leading: 20,
                            bottom: 6,
                            trailing: 20
                        ))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                            Button(role: .destructive) {
                                viewModel.deleteTask(task)
                                provideHaptic()
                            } label: {
                                Label("Удалить", systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .appBackground()
        .navigationTitle(isBride ? "Чек-лист невесты" : "Чек-лист жениха")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                isPresentingAdd = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isPresentingAdd) {
            AddTaskView(
                isPresented: $isPresentingAdd,
                category: isBride ? .brideChecklist : .groomCheckList
            )
            .environmentObject(viewModel)
        }
    }

    private func provideHaptic() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

#Preview {
    NavigationView {
        BrideAndGroomChecklistView(isBride: true)
            .environmentObject(TaskViewModel())
    }
}
