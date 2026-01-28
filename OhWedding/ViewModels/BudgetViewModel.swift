import Foundation
import SwiftData

@MainActor
final class BudgetViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var selectedCategory: ExpenseCategory?

    // MARK: - Загрузка
    func load(using context: ModelContext) {
        if let result = try? context.fetch(FetchDescriptor<Expense>()) {
            self.expenses = result
        }
    }

    // MARK: - Добавление
    func addExpense(_ expense: Expense, using context: ModelContext) {
        context.insert(expense)
        save(context)
        load(using: context)
    }

    // MARK: - Обновление
    func updateExpense(_ expense: Expense, using context: ModelContext) {
        // Достаточно сохранить, изменения @Model отслеживаются автоматически
        save(context)
        load(using: context)
    }

    // MARK: - Удаление
    func deleteExpense(_ expense: Expense, using context: ModelContext) {
        context.delete(expense)
        save(context)
        load(using: context)
    }

    // MARK: - Подсчёты
    var filteredExpenses: [Expense] {
        if let category = selectedCategory {
            return expenses.filter { $0.category == category }
        }
        return expenses
    }

    /// Общая сумма всех расходов
    var totalExpenses: Int {
        expenses.reduce(0) { $0 + $1.amount }
    }

    /// Сумма реально оплаченная (учитывает авансы)
    var paidAmount: Int {
        expenses.reduce(0) { $0 + min($1.advance, $1.amount) }
    }

    /// Сумма к оплате (долг)
    var unpaidAmount: Int {
        expenses.reduce(0) { $0 + max($1.amount - $1.advance, 0) }
    }

    /// Группировка по категориям
    var expensesByCategory: [ExpenseCategory: [Expense]] {
        Dictionary(grouping: expenses) { $0.category }
    }

    /// Остаток бюджета (неизрасходованная сумма)
    func remainingBudget(totalBudget: Int) -> Int {
        max(totalBudget - totalExpenses, 0)
    }

    /// Подсчёт суммы по подкатегории
    func amount(for category: ExpenseCategory, subcategory: String) -> Int {
        expenses
            .filter { $0.category == category && $0.subcategoryRaw == subcategory }
            .reduce(0) { $0 + $1.amount }
    }

    // MARK: - Сохранение
    private func save(_ context: ModelContext) {
        try? context.save()
    }
}
