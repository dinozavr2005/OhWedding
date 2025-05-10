//
//  AssignmentCell.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import SwiftUI

struct AssignmentCell: View {
    @Binding var assignment: Assignment  // Привязка для изменения состояния задания

    var body: some View {
        HStack {
            // Чекбокс (Toggle)
            Toggle(isOn: $assignment.isCompleted) {
                VStack(alignment: .leading) {
                    Text(assignment.title)
                        .font(.headline)
                        .strikethrough(assignment.isCompleted)  // За черкивание текста, если задание выполнено

                    Text(assignment.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .toggleStyle(CheckboxToggleStyle())  // Стиль для чекбокса
            .padding()
        }
        .background(Color.white)  // Фон ячейки
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct AssignmentCell_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentCell(assignment: .constant(Assignment(title: "Скачать Pinterest", description: "Сохранять в муд борд всё, что привлекает внимание.", isCompleted: false)))
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}

