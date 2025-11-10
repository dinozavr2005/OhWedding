//
//  TimingBlockView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftUI
import SwiftData

struct TimingBlockView: View {
    @Bindable var block: TimingBlock
    @ObservedObject var viewModel: TimingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            positions
            if viewModel.isEditing {
                addPositionButton
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 10) {
            if viewModel.isEditing {
                TextField("Название блока", text: $block.title)
                    .font(.headline)
                    .padding(8)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(8)
            } else {
                Text(block.title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Spacer()

            if viewModel.isEditing {
                Button(role: .destructive) {
                    viewModel.deleteBlock(block)
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
        }
    }

    // MARK: - Positions
    private var positions: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 🔹 Главное изменение: сортируем позиции по времени перед отображением
            ForEach(block.positions.sorted(by: { $0.time < $1.time })) { position in
                TimingPositionView(block: block, position: position, viewModel: viewModel)
            }
        }
    }

    // MARK: - Add position button
    private var addPositionButton: some View {
        Button {
            viewModel.addPosition(to: block)
        } label: {
            Label("Добавить позицию", systemImage: "plus.circle.fill")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding(.top, 4)
    }
}
