//
//  ExpenseRow.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 22.10.2025.
//

import SwiftUI

struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)

                HStack {
                    Image(expense.category.icon)
                        .foregroundColor(.blue)
                    Text(expense.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(String(format: "%.0f ₽", expense.amount))
                    .font(.headline)

                Text(expense.isPaid ? "Оплачено" : "Не оплачено")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(expense.isPaid ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    .foregroundColor(expense.isPaid ? .green : .orange)
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }
}
