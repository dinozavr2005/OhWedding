//
//  TaskListView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = TaskViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // MARK: - Раздел "Задания"
                Section {
                    NavigationLink(destination: AssignmentListView()
                        .environmentObject(viewModel)) {
                        ChecklistCard(
                            title: "Задания для невесты",
                            completedCount: viewModel.brideTasksCompleted,
                            totalCount: viewModel.brideTasksTotal,
                            color: Color(hex: "E792FC")
                        )
                    }
                } header: {
                    Text("Задания")
                        .font(.manropeSemiBold(size: 18))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }

                // MARK: - Раздел "Чек-листы"
                Section {
                    NavigationLink(destination: WeddingCheckListView()
                        .environmentObject(viewModel)) {
                        ChecklistCard(
                            title: "Чек-лист свадьбы",
                            completedCount: viewModel.weddingChecklistCompleted,
                            totalCount: viewModel.weddingChecklistTotal,
                            color: Color(hex: "4ECDC4")
                        )
                    }

                    NavigationLink(destination: BrideAndGroomChecklistView(isBride: true)
                        .environmentObject(viewModel)) {
                        ChecklistCard(
                            title: "Чек-лист невесты",
                            completedCount: viewModel.brideCheckListCompleted,
                            totalCount: viewModel.brideCheckListTotal,
                            color: Color(hex: "F0AAFF")
                        )
                    }

                    NavigationLink(destination: BrideAndGroomChecklistView(isBride: false)
                        .environmentObject(viewModel)) {
                        ChecklistCard(
                            title: "Чек-лист жениха",
                            completedCount: viewModel.groomChecklistCompleted,
                            totalCount: viewModel.groomChecklistTotal,
                            color: Color(hex: "6C5CE7")
                        )
                    }
                } header: {
                    Text("Чек-листы")
                        .font(.manropeSemiBold(size: 18))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .appBackground()
        .navigationTitle("Задачи")
        .onAppear {
            viewModel.updateContext(context)
        }
    }
}

struct ChecklistCard: View {
    let title: String
    let completedCount: Int
    let totalCount: Int
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.manropeSemiBold(size: 16))
                .foregroundColor(.primary)

            HStack {
                Text("\(completedCount)/\(totalCount) выполнено")
                    .font(.manropeRegular(size: 13))
                    .foregroundColor(.secondary)
                Spacer()
                Circle()
                    .fill(color.opacity(0.25))
                    .frame(width: 10, height: 10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    NavigationView {
        TaskListView()
    }
}
