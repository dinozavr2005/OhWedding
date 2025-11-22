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

    // Задачи для этой категории
    private var checklistTasks: [WeddingTask] {
        viewModel.tasks.filter { $0.category == .weddingChecklist }
    }

    var body: some View {
        List {
            ForEach(checklistTasks) { task in
                if let idx = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {

                    TaskCardView(task: $viewModel.tasks[idx])
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(
                            top: 6,
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
        .navigationTitle("Чек-лист свадьбы")
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
                category: .weddingChecklist
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
        WeddingCheckListView()
            .environmentObject(TaskViewModel())
    }
}
