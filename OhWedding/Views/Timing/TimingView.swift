//
//  TimingView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftUI
import SwiftData

struct TimingView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: TimingViewModel

    init() {
        // Используем общий контейнер, чтобы не передавать контекст вручную
        _viewModel = StateObject(wrappedValue: TimingViewModel(context: AppModel.shared.modelContext))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 🔹 Отображаем блоки в порядке order
                ForEach(viewModel.blocks.sorted(by: { $0.order < $1.order })) { block in
                    VStack(spacing: 12) {
                        TimingBlockView(block: block, viewModel: viewModel)

                        // ✅ Кнопка добавления нового блока сразу после текущего
                        if viewModel.isEditing {
                            Button {
                                withAnimation {
                                    viewModel.insertBlock(after: block)
                                }
                            } label: {
                                Label("Добавить блок", systemImage: "plus.circle.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .buttonStyle(.plain)
                            .padding(.leading, 8)
                        }
                    }
                }

                // 🔹 Кнопка добавления первого блока (если список пуст)
                if viewModel.isEditing && viewModel.blocks.isEmpty {
                    Button {
                        withAnimation {
                            viewModel.insertBlock(after: nil)
                        }
                    } label: {
                        Label("Добавить первый блок", systemImage: "plus.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
        .navigationTitle("Тайминг дня")
        .toolbar {
            Button(viewModel.isEditing ? "Готово" : "Редактировать") {
                withAnimation(.easeInOut) {
                    viewModel.isEditing.toggle()
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.fetchBlocks()
        }
    }
}

#Preview {
    NavigationView {
        TimingView()
            .modelContainer(AppModel.shared.modelContainer) // 👈 Подключаем контейнер для превью
    }
}
