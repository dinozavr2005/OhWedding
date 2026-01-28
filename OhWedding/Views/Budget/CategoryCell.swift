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
    let totalBudget: Int
    let expenses: [Expense]
    let onExpandToggle: () -> Void
    let onTap: () -> Void
    let amountProvider: (String) -> Int

    private var categoryAmount: Int {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                CategoryRow(
                    category: category,
                    amount: categoryAmount,
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
                ForEach(category.subcategories, id: \.self) { sub in
                    HStack {
                        Text(sub)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()

                        Text(amountProvider(sub), format: .number) + Text(" ₽")
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
