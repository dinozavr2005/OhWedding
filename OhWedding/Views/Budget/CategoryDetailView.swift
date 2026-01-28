//
//  CategoryDetailView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.10.2025.
//

import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    let category: ExpenseCategory
    @StateObject private var viewModel = BudgetViewModel()

    @State private var showingAddExpense = false
    @State private var editingExpense: Expense?

    // Фильтрация расходов по категории локально
    private var expensesInCategory: [Expense] {
        viewModel.expenses.filter { $0.category == category }
    }

    // Агрегаты по текущей категории
    private var totalAmount: Int {
        expensesInCategory.reduce(0) { $0 + $1.amount }
    }

    private var totalAdvance: Int {
        expensesInCategory.reduce(0) { $0 + $1.advance }
    }

    private var totalDebt: Int {
        max(totalAmount - totalAdvance, 0)
    }

    var body: some View {
        VStack {
            if expensesInCategory.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("Нет расходов в категории")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    // Сводка
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Всего")
                                Spacer()
                                (Text(totalAmount, format: .number) + Text(" ₽")).bold()
                            }

                            HStack {
                                Text("Аванс")
                                Spacer()
                                Text(totalAdvance, format: .number) + Text(" ₽")
                            }
                            .foregroundColor(.secondary)

                            HStack {
                                Text("Остаток")
                                Spacer()
                                Text(totalDebt, format: .number) + Text(" ₽")
                            }
                            .foregroundColor(totalDebt == 0 ? .green : .red)
                        }
                        .font(.subheadline)
                        .padding(.vertical, 4)
                    }

                    // Расходы
                    Section(header: Text("Расходы")) {
                        ForEach(expensesInCategory) { expense in
                            Button {
                                editingExpense = expense
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(expense.title).font(.headline)
                                        Spacer()
                                        Text(expense.amount, format: .number) + Text(" ₽")
                                    }

                                    if !expense.subcategory.isEmpty {
                                        Text(expense.subcategory)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }

                                    HStack(spacing: 8) {
                                        if expense.advance > 0 {
                                            Text("Аванс: ") + Text(expense.advance, format: .number) + Text(" ₽")
                                        }

                                        Text(expense.isPaid ? "Оплачено" : "Не оплачено")
                                            .foregroundColor(expense.isPaid ? .green : .orange)
                                    }
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let expense = expensesInCategory[index]
                                viewModel.deleteExpense(expense, using: context)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .appBackground()
        .navigationTitle(category.rawValue)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showingAddExpense = true } label: { Image(systemName: "plus") }
            }
        }
        .onAppear {
            viewModel.load(using: context)
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(initialCategory: category) { expense in
                viewModel.addExpense(expense, using: context)
            }
        }
        .sheet(item: $editingExpense) { expense in
            EditExpenseView(expense: expense) { updated in
                viewModel.updateExpense(updated, using: context)
            }
        }
    }
}
