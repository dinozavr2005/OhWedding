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

    var progress: Double {
        guard total > 0 else { return 0 }
        return min(amount / total, 1.0)
    }

    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(.blue)
                .frame(width: 30)

            VStack(alignment: .leading) {
                Text(category.rawValue)
                Text(String(format: "%.0f ₽", amount))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(String(format: "%.0f%%", progress * 100))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
