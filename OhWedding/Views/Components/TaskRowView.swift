//
//  TaskRowView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 20.04.2025.
//

import SwiftUI

// Стиль Toggle в виде чек‑бокса
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 2) Обёртка строки задачи
struct TaskRowView: View {
    @Binding var task: WeddingTask

    var body: some View {
        Toggle(task.title, isOn: $task.isCompleted)
            .toggleStyle(CheckboxToggleStyle())
            .strikethrough(task.isCompleted, color: .gray)
            .foregroundColor(task.isCompleted ? .gray : .primary)
    }
}
