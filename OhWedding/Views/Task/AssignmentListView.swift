//
//  AssignmentListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import SwiftUI

struct AssignmentListView: View {
    @EnvironmentObject var viewModel: TaskViewModel  // Используем EnvironmentObject для доступа к вью модели

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.assignments.indices, id: \.self) { index in
                    // Используем AssignmentCell для каждого задания
                    AssignmentCell(assignment: $viewModel.assignments[index])  // Передаем Binding к каждому заданию
                        .onTapGesture {
                            // При нажатии меняем статус задания через вью модель
                            viewModel.toggleAssigmentCompletion(at: index)
                        }
                }
            }
            .padding()
        }
        .navigationTitle("Задания для невесты")
    }
}

#Preview {
    NavigationView {
        AssignmentListView()
            .environmentObject(TaskViewModel())  // Передаем вью модель через environment
    }
}
