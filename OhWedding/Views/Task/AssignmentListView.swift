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
                    AssignmentCell(assignment: assignment)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Задания для невесты")
    }
}

#Preview {
    NavigationView {
        AssignmentListView()
            .environmentObject(TaskViewModel())
    }
}
