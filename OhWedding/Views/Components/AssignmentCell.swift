//
//  AssignmentCell.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import SwiftUI
import SwiftData

struct AssignmentCell: View {
    @Bindable var assignment: Assignment  // @Binding → @Bindable

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Toggle(isOn: $assignment.isCompleted) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(assignment.title)
                        .font(.headline)
                        .foregroundColor(assignment.isCompleted ? .gray : .primary)
                        .strikethrough(assignment.isCompleted, color: .gray)

                    Text(assignment.detail)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .toggleStyle(CheckboxToggleStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    // Превью без SwiftData-контекста
    AssignmentCell(
        assignment: Assignment(
            title: "Скачать Pinterest",
            detail: "Сохранять в муд борд всё, что привлекает внимание.",
            isCompleted: false
        )
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}

