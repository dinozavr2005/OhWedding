//
//  EditExpenseView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.10.2025.
//

import SwiftUI
import Foundation

struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @State var expense: Expense
    var onSave: (Expense) -> Void

    // MARK: - Derived data
    private var subcategories: [String] {
        expense.category.subcategories
    }

    // MARK: - Расчёты
    private var remainingAmount: Double {
        max(expense.amount - expense.advance, 0)
    }

    private var isPaid: Bool {
        remainingAmount == 0
    }

    var body: some View {
        NavigationView {
            Form {
                mainInfoSection
                financeSection
                notesSection
            }
            .navigationTitle("Редактирование")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        onSave(expense)
                        dismiss()
                    }
                }
            }
        }
    }
}

private extension EditExpenseView {

    // MARK: - Основная информация
    var mainInfoSection: some View {
        Section("Основная информация") {
            TextField("Название", text: $expense.title)

            Picker("Категория", selection: $expense.category) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }

            if !subcategories.isEmpty {
                Picker("Подкатегория", selection: $expense.subcategory) {
                    Text("Не выбрано").tag("")
                    ForEach(subcategories, id: \.self) { sub in
                        Text(sub).tag(sub)
                    }
                }
                // Сбрасываем выбор при смене категории
                .id(expense.category)
            }
        }
    }

    // MARK: - Финансы
    var financeSection: some View {
        Section("Финансы") {
            TextField("Сумма", value: $expense.amount, format: .number.precision(.fractionLength(0)))
                .keyboardType(.decimalPad)

            TextField("Аванс", value: $expense.advance, format: .number.precision(.fractionLength(0)))
                .keyboardType(.decimalPad)

            // 💰 Остаток
            HStack {
                Text("Остаток")
                Spacer()
                Text("\(remainingAmount, specifier: "%.0f") ₽")
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("Статус оплаты")
                Spacer()
                Text(isPaid ? "Оплачено" : "Не оплачено")
                    .foregroundColor(isPaid ? .green : .red)
                    .fontWeight(.semibold)
            }
        }
    }

    // MARK: - Прочее
    var notesSection: some View {
        Section("Прочее") {
            DatePicker("Дата", selection: $expense.date, displayedComponents: .date)
            TextField("Заметки", text: $expense.notes)
        }
    }
}

// MARK: - Форматтер для чисел
extension NumberFormatter {
    static var decimal0: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f
    }
}
