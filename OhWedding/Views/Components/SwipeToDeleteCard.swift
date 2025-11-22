//
//  SwipeToDeleteCard.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.11.2025.
//

import SwiftUI

struct SwipeToDeleteCard<Content: View>: View {
    let onDelete: () -> Void
    let content: Content

    @State private var offsetX: CGFloat = 0
    @State private var isOpen = false

    init(onDelete: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.onDelete = onDelete
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .trailing) {

            deleteButton

            content
                .offset(x: offsetX)
                .animation(.spring(), value: offsetX)
                // 👉 свайп работает, скролл не ломается
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { value in
                            // вертикальный жест игнорируем
                            guard abs(value.translation.width) > abs(value.translation.height) else { return }

                            if value.translation.width < 0 {
                                offsetX = max(value.translation.width, -80)
                            }
                        }
                        .onEnded { value in
                            guard abs(value.translation.width) > abs(value.translation.height) else { return }

                            withAnimation(.spring()) {
                                if value.translation.width < -40 {
                                    isOpen = true
                                    offsetX = -80
                                } else {
                                    isOpen = false
                                    offsetX = 0
                                }
                            }
                        }
                )
                .onTapGesture {
                    if isOpen {
                        withAnimation(.spring()) {
                            isOpen = false
                            offsetX = 0
                        }
                    }
                }
        }
        .clipped()
    }

    private var deleteButton: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: 80)
            .overlay(
                Button {
                    withAnimation(.spring()) { onDelete() }
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding(.trailing, 8)
            .opacity(isOpen ? 1 : 0.8)
    }
}
