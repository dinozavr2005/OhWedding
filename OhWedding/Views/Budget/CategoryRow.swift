//
//  CategoryRow.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.10.2025.
//

import SwiftUI

struct CategoryRow: View {
    let category: ExpenseCategory
    let amount: Double
    let total: Double

    private var progress: Double {
        guard total > 0 else { return 0 }
        return min(amount / total, 1.0)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(category.icon)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 34, height: 34)

            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.manropeSemiBold(size: 16))
                    .foregroundColor(.primary)

                Text(amount.formatted(
                    .number
                        .grouping(.automatic)   // ← 100 000
                        .precision(.fractionLength(0))
                ) + " ₽")
                .font(.manropeRegular(size: 14))
                .foregroundColor(.black)
            }

            Spacer()

            Text(progress.formatted(.percent.precision(.fractionLength(0))))
                .font(.manropeRegular(size: 14))
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
    }
}
