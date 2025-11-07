//
//  AddExpenseView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 20.10.2025.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var amount = ""
    @State private var advance = ""
    @State private var category: ExpenseCategory = .other
    @State private var subcategory = ""
    @State private var date = Date()
    @State private var notes = ""

    let onAdd: (Expense) -> Void

    private var subcategoryOptions: [String] { category.subcategories }

    /// Автоматический расчёт долга
    private var debt: Double {
        let total = Double(amount) ?? 0
        let paid = Double(advance) ?? 0
        return max(total - paid, 0)
    }

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Основная информация
                Section(header: Text("Основная информация")) {
                    TextField("Название", text: $title)

                    Picker("Категория", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .onChange(of: category) { _ in
                        if !subcategoryOptions.contains(subcategory) {
                            subcategory = ""
                        }
                    }

                    if !subcategoryOptions.isEmpty {
                        Picker("Подкатегория", selection: $subcategory) {
                            Text("Не выбрано").tag("")
                            ForEach(subcategoryOptions, id: \.self) { sub in
                                Text(sub).tag(sub)
                            }
                        }
                        .id(category)
                    }
                }

                // MARK: - Финансы
                Section(header: Text("Финансы")) {
                    TextField("Сумма", text: $amount)
                        .keyboardType(.decimalPad)

                    TextField("Аванс", text: $advance)
                        .keyboardType(.decimalPad)

                    HStack {
                        Text("Остаток")
                        Spacer()
                        Text("\(debt, specifier: "%.0f") ₽")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("Статус оплаты")
                        Spacer()
                        Text(debt == 0 ? "Оплачено" : "Не оплачено")
                            .foregroundColor(debt == 0 ? .green : .red)
                            .fontWeight(.semibold)
                    }
                }

                // MARK: - Прочее
                Section(header: Text("Дополнительно")) {
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                    TextField("Заметки", text: $notes)
                }
            }
            .navigationTitle("Новый расход")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Добавить") {
                    guard let amountValue = Double(amount) else { return }

                    let advanceValue = Double(advance) ?? 0

                    let expense = Expense(
                        title: title,
                        amount: amountValue,
                        advance: advanceValue,
                        category: category,
                        subcategory: subcategory.isEmpty ? nil : subcategory,
                        date: date,
                        notes: notes
                    )

                    onAdd(expense)
                    dismiss()
                }
                .disabled(title.isEmpty || amount.isEmpty)
            )
        }
    }
}
