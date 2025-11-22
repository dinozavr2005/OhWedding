//
//  TaskCardView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.11.2025.
//

import SwiftUI

struct TaskCardView: View {
    @Binding var task: WeddingTask

    var checkedImage = Image("checkBox2")
    var uncheckedImage = Image("checkBox1")

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 20) {

                // КНОПКА ЧЕКБОКСА
                Button {
                    task.isCompleted.toggle()
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } label: {
                    (task.isCompleted ? checkedImage : uncheckedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                }

                // ТЕКСТ
                Text(task.title)
                    .font(.manropeSemiBold(size: 16))
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                    .lineLimit(2)

                Spacer()

                // ЭМОДЗИ (если есть)
                if let emoji = task.emoji, !emoji.isEmpty {
                    Text(emoji)
                        .font(.system(size: 22))   // Размер эмодзи
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}
