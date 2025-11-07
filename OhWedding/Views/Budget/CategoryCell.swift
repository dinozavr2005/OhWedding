//
//  CategoryCell.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.10.2025.
//

import SwiftUI

struct CategoryCell: View {
    let category: ExpenseCategory
    let isExpanded: Bool
    let totalBudget: Double
    let expenses: [Expense]
    let onExpandToggle: () -> Void
    let onTap: () -> Void
    let amountProvider: (String) -> Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                CategoryRow(
                    category: category,
                    amount: expenses.reduce(0) { $0 + $1.amount },
                    total: totalBudget
                )
                .contentShape(Rectangle())
                .onTapGesture(perform: onTap)

                Spacer()

                Button(action: onExpandToggle) {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }

            if isExpanded {
                ForEach(category.subcategories, id: \.self) { subcategory in
                    HStack {
                        Text(subcategory)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.0f ₽", amountProvider(subcategory)))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading, 36)
                    .padding(.vertical, 2)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
    }
}
