//
//  AssignmentCell.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import SwiftUI
import SwiftData

struct AssignmentCell: View {
    let assignment: Assignment
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Toggle(
                    isOn: .init(
                        get: { assignment.isCompleted },
                        set: { _ in onToggle() }
                    )
                ) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(assignment.title)
                            .font(.manropeSemiBold(size: 16))
                            .foregroundColor(assignment.isCompleted ? .gray : .primary)
                            .strikethrough(assignment.isCompleted, color: .gray)

                        Text(assignment.detail)
                            .font(.manropeRegular(size: 14))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .toggleStyle(CheckboxToggleStyle())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}


#Preview {
    AssignmentCell(
        assignment: Assignment(
            title: "Скачать Pinterest",
            detail: "Сохранять в муд борд всё, что привлекает внимание.",
            isCompleted: false
        ),
        onToggle: {}
    )
    .padding()
    .background(Color.gray.opacity(0.1))
}

