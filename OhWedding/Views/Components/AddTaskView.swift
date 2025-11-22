//
//  AddTaskView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 26.04.2025.
//

import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var viewModel: TaskViewModel
    @Binding var isPresented: Bool
    var category: TaskCategory

    @State private var taskTitle: String = ""
    @State private var emoji: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {

                // Поле названия задачи
                customField(
                    title: "Введите название задачи",
                    text: $taskTitle
                )

                // Поле emoji
                customField(
                    title: "Эмодзи (необязательно)",
                    text: $emoji
                )
                .onChange(of: emoji) { newValue in
                    emoji = filterToEmoji(newValue)
                }

                Button(action: addTask) {
                    Text("Добавить задачу")
                        .font(.manropeSemiBold(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(14)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 24)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Добавить задачу")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Закрыть") {
                        isPresented = false
                    }
                }
            }
            .appBackground()
        }
    }

    // MARK: - Красивое кастомное поле
    private func customField(title: String, text: Binding<String>) -> some View {
        TextField(title, text: text)
            .font(.manropeRegular(size: 16))
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal)
    }

    private func addTask() {
        let newTask = WeddingTask(
            title: taskTitle,
            isCompleted: false,
            dueDate: nil,
            category: category,
            emoji: emoji.isEmpty ? nil : emoji
        )

        viewModel.addTask(newTask)
        isPresented = false
    }

    private func filterToEmoji(_ input: String) -> String {
        let emojis = input.filter { $0.isEmoji }
        return emojis.count > 1 ? String(emojis.prefix(1)) : emojis
    }
}

extension Character {
    var isEmoji: Bool {
        unicodeScalars.first?.properties.isEmojiPresentation == true ||
        unicodeScalars.first?.properties.generalCategory == .otherSymbol
    }
}

#Preview {
    AddTaskView(isPresented: .constant(true), category: .weddingChecklist)
        .environmentObject(TaskViewModel())
}
