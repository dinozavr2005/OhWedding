//
//  AddExpenseView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 20.10.2025.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var amount = ""
    @State private var advance = ""
    @State private var category: ExpenseCategory
    @State private var subcategory = ""
    @State private var date = Date()
    @State private var notes = ""

    let onAdd: (Expense) -> Void

    private var subcategoryOptions: [String] { category.subcategories }

    init(initialCategory: ExpenseCategory = .other,
         onAdd: @escaping (Expense) -> Void) {
        _category = State(initialValue: initialCategory)
        self.onAdd = onAdd
    }

    // MARK: - Helpers

    private func cleanNumberString(_ s: String) -> String {
        s.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\u{00A0}", with: "")  // NBSP
            .replacingOccurrences(of: "\u{202F}", with: "")  // narrow NBSP
    }

    private var amountInt: Int? {
        let t = cleanNumberString(amount)
        return t.isEmpty ? nil : Int(t)
    }

    private var advanceInt: Int {
        let t = cleanNumberString(advance)
        return Int(t) ?? 0
    }

    /// Автоматический расчёт долга
    private var debt: Int {
        let total = amountInt ?? 0
        let paid = min(advanceInt, total)
        return max(total - paid, 0)
    }

    private var canAdd: Bool {
        !title.isEmpty && amountInt != nil
    }

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Основная информация
                Section(header: Text("Основная информация")) {
                    TextField("Название", text: $title)

                    HStack {
                        Text("Категория")
                        Spacer()

                        Menu {
                            ForEach(ExpenseCategory.allCases, id: \.self) { c in
                                Button {
                                    category = c
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(c.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                        Text(c.rawValue)
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(category.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)

                                Text(category.rawValue)
                                    .foregroundStyle(.primary)

                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.footnote)
                                    .foregroundStyle(.primary)
                            }
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
                        .keyboardType(.numberPad)

                    TextField("Аванс", text: $advance)
                        .keyboardType(.numberPad)

                    HStack {
                        Text("Остаток")
                        Spacer()
                        Text(debt, format: .number) + Text(" ₽")
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
            .appBackground()
            .navigationTitle("Новый расход")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Добавить") {
                    guard let amountValue = amountInt else { return }

                    let safeAdvance = min(advanceInt, amountValue)

                    let expense = Expense(
                        title: title,
                        amount: amountValue,
                        advance: safeAdvance,
                        category: category,
                        subcategory: subcategory.isEmpty ? nil : subcategory,
                        date: date,
                        notes: notes
                    )

                    onAdd(expense)
                    dismiss()
                }
                .disabled(!canAdd)
            )
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseView { expense in
            print(expense)
        }
    }
}
