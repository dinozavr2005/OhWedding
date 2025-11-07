//
//  BudgetProgressView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 22.10.2025.
//

import SwiftUI

struct BudgetProgressView: View {
    let spent: Double
    let total: Double

    /// Сколько процентов бюджета осталось
    var remainingProgress: Double {
        guard total > 0 else { return 0 }
        return max(1 - (spent / total), 0)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Серый фон (всё пространство)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)

                // Зелёная часть — то, что осталось
                RoundedRectangle(cornerRadius: 8)
                    .fill(progressColor)
                    .frame(width: geometry.size.width * remainingProgress, height: 8)
            }
        }
        .frame(height: 8)
    }

    /// Цвет шкалы в зависимости от остатка
    var progressColor: Color {
        if remainingProgress > 0.5 {
            return .green
        } else if remainingProgress > 0.2 {
            return .orange
        } else {
            return .red
        }
    }
}
