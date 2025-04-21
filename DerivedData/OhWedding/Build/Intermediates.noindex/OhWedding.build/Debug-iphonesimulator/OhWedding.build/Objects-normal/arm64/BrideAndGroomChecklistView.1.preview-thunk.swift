import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/Task/BrideAndGroomChecklistView.swift", line: 1)
//
//  BrideAndGroomChecklistView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct BrideAndGroomChecklistView: View {
    @StateObject private var viewModel = TaskViewModel()

    // Выбираем только индексы задач нужной категории
    private var indices: [Int] {
        viewModel.tasks.indices
            .filter { viewModel.tasks[$0].category == .coupleChecklist }
    }

    var body: some View {
        List {
            ForEach(indices, id: \.self) { idx in
                HStack {
                    // Кнопка‑чекбокс
                    Button {
                        viewModel.tasks[idx].isCompleted.toggle()
                    } label: {
                        Image(systemName: viewModel.tasks[idx].isCompleted
                              ? __designTimeString("#14936_0", fallback: "checkmark.square")
                              : __designTimeString("#14936_1", fallback: "square"))
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Заголовок задачи
                    Text(viewModel.tasks[idx].title)
                        .strikethrough(viewModel.tasks[idx].isCompleted, color: .gray)
                        .foregroundColor(viewModel.tasks[idx].isCompleted ? .gray : .primary)
                }
            }
            .onDelete { offsets in
                // Чтобы корректно удалить, переводим оффсеты индексов
                let toDelete = offsets.map { indices[$0] }
                toDelete.forEach { viewModel.deleteTask(viewModel.tasks[$0]) }
            }
        }
        .navigationTitle(__designTimeString("#14936_2", fallback: "Чек‑лист жених и невеста"))
    }
}

#Preview {
    NavigationView {
        BrideAndGroomChecklistView()
    }
}
