//
//  AssignmentListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import SwiftUI
import SwiftData

struct AssignmentListView: View {
    @EnvironmentObject var viewModel: TaskViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.assignments) { assignment in
                    AssignmentCell(
                        assignment: assignment,
                        onToggle: {
                            viewModel.toggleAssigmentCompletion(assignment)
                            provideHapticFeedback() // виброотдача
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .appBackground()
        .navigationTitle("Задания для невесты")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Виброотдача
    private func provideHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
