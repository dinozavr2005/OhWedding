//
//  TimingPositionView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftUI

struct TimingPositionView: View {
    var block: TimingBlock
    var position: TimingPosition
    @ObservedObject var viewModel: TimingViewModel

    @State private var newContentTitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            header
            contents
            if viewModel.isEditing {
                addContentField
            }
        }
        .padding(10)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }

    // MARK: - Header
    private var header: some View {
        Group {
            if viewModel.isEditing {
                // ✏️ Режим редактирования — DatePicker + TextField + delete button
                HStack(alignment: .center, spacing: 10) {
                    DatePicker(
                        "",
                        selection: Binding(
                            get: { position.time },
                            set: { newValue in
                                viewModel.updatePosition(
                                    in: block,
                                    positionID: position.id,
                                    newTime: newValue
                                )
                            }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                    .frame(width: 78, height: 36)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(6)

                    TextField(
                        "Название",
                        text: Binding(
                            get: { position.title },
                            set: { newValue in
                                viewModel.updatePosition(
                                    in: block,
                                    positionID: position.id,
                                    newTitle: newValue
                                )
                            }
                        )
                    )
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 36)

                    Spacer(minLength: 8)

                    Button {
                        viewModel.deletePosition(from: block, position: position)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
            } else {
                // 👀 Режим просмотра — просто время + название
                HStack(spacing: 8) {
                    Text(position.formattedTime)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .frame(width: 54, alignment: .leading)

                    Text(position.title)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    Spacer()
                }
            }
        }
    }

    // MARK: - Список содержимого
    private var contents: some View {
        VStack(alignment: .leading, spacing: 6) {
            if viewModel.isEditing {
                // ✏️ Можно удалять элементы
                ForEach(position.contents) { content in
                    HStack(spacing: 8) {
                        Text("• \(content.title)")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Button {
                            viewModel.deleteContent(
                                from: block,
                                positionID: position.id,
                                content: content
                            )
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
            } else {
                // 👀 Только просмотр содержимого
                ForEach(position.contents) { content in
                    Text("• \(content.title)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 62)
                }
            }
        }
    }

    // MARK: - Добавление нового контента
    private var addContentField: some View {
        HStack(spacing: 8) {
            TextField("Новое наполнение", text: $newContentTitle)
                .textFieldStyle(.roundedBorder)
                .frame(height: 34)

            Button {
                guard !newContentTitle.isEmpty else { return }
                viewModel.addContent(
                    to: block,
                    positionID: position.id,
                    title: newContentTitle
                )
                newContentTitle = ""
            } label: {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title3)
            }
        }
        .padding(.top, 4)
    }
}
