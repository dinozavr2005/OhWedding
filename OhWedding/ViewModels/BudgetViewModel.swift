import SwiftUI

class BudgetViewModel: ObservableObject {
    @Published var expenses: [Expense] = []
    @Published var selectedCategory: ExpenseCategory?
    
    var filteredExpenses: [Expense] {
        if let category = selectedCategory {
            return expenses.filter { $0.category == category }
        }
        return expenses
    }
    
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var paidExpenses: Double {
        expenses.filter { $0.isPaid }.reduce(0) { $0 + $1.amount }
    }
    
    var unpaidExpenses: Double {
        expenses.filter { !$0.isPaid }.reduce(0) { $0 + $1.amount }
    }
    
    var expensesByCategory: [ExpenseCategory: [Expense]] {
        Dictionary(grouping: expenses) { $0.category }
    }
    
    func addExpense(_ expense: Expense) {
        expenses.append(expense)
    }
    
    func updateExpense(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }
    
    func deleteExpense(_ expense: Expense) {
        expenses.removeAll { $0.id == expense.id }
    }
    
    func toggleExpensePayment(_ expense: Expense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index].isPaid.toggle()
        }
    }
}
