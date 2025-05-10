//
//  BudgetView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct BudgetView: View {
    @StateObject private var viewModel = BudgetViewModel()
    @State private var showingAddExpense = false
    @State private var showingEditBudget = false
    @State private var newBudget: String = ""
    @State private var totalBudget: Double = 0
    
    var body: some View {
        List {
            // Budget summary
            Section {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Общий бюджет")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.0f ₽", totalBudget))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingEditBudget = true }) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Потрачено")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.0f ₽", viewModel.totalExpenses))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Осталось")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.0f ₽", totalBudget - viewModel.totalExpenses))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    
                    BudgetProgressView(
                        spent: viewModel.totalExpenses,
                        total: totalBudget
                    )
                }
                .padding(.vertical, 8)
            }
            
            // Expenses by category
            Section(header: Text("Расходы по категориям")) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    CategoryRow(
                        category: category,
                        amount: viewModel.expensesByCategory[category]?.reduce(0) { $0 + $1.amount } ?? 0,
                        total: totalBudget
                    )
                }
            }
            
            // Recent expenses
            Section(header: Text("Последние расходы")) {
                ForEach(viewModel.expenses) { expense in
                    ExpenseRow(expense: expense) {
                        viewModel.toggleExpensePayment(expense)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let expense = viewModel.expenses[index]
                        viewModel.deleteExpense(expense)
                    }
                }
            }
        }
        .navigationTitle("Бюджет")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddExpense = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView { expense in
                viewModel.addExpense(expense)
            }
        }
        .alert("Изменить бюджет", isPresented: $showingEditBudget) {
            TextField("Новый бюджет", text: $newBudget)
                .keyboardType(.numberPad)
            
            Button("Отмена", role: .cancel) { }
            Button("Сохранить") {
                if let budget = Double(newBudget) {
                    totalBudget = budget
                }
            }
        } message: {
            Text("Введите новую сумму бюджета")
        }
    }
}

struct BudgetProgressView: View {
    let spent: Double
    let total: Double
    
    var progress: Double {
        min(spent / total, 1.0)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(progressColor)
                    .frame(width: geometry.size.width * progress, height: 8)
            }
        }
        .frame(height: 8)
    }
    
    var progressColor: Color {
        if progress < 0.5 {
            return .green
        } else if progress < 0.8 {
            return .orange
        } else {
            return .red
        }
    }
}

struct CategoryRow: View {
    let category: ExpenseCategory
    let amount: Double
    let total: Double
    
    var progress: Double {
        min(amount / total, 1.0)
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

struct ExpenseRow: View {
    let expense: Expense
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                    .font(.headline)
                
                HStack {
                    Image(systemName: expense.category.icon)
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
                
                Button(action: onToggle) {
                    Text(expense.isPaid ? "Оплачено" : "Не оплачено")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(expense.isPaid ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                        .foregroundColor(expense.isPaid ? .green : .orange)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var amount = ""
    @State private var category: ExpenseCategory = .other
    @State private var date = Date()
    @State private var isPaid = false
    @State private var notes = ""
    let onAdd: (Expense) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основная информация")) {
                    TextField("Название", text: $title)
                    TextField("Сумма", text: $amount)
                        .keyboardType(.numberPad)
                    
                    Picker("Категория", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
                
                Section(header: Text("Дополнительно")) {
                    DatePicker("Дата", selection: $date, displayedComponents: .date)
                    Toggle("Оплачено", isOn: $isPaid)
                    TextField("Заметки", text: $notes)
                }
            }
            .navigationTitle("Новый расход")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Добавить") {
                    if let amountValue = Double(amount) {
                        let expense = Expense(
                            title: title,
                            amount: amountValue,
                            category: category,
                            date: date,
                            isPaid: isPaid,
                            notes: notes
                        )
                        onAdd(expense)
                        dismiss()
                    }
                }
                .disabled(title.isEmpty || amount.isEmpty)
            )
        }
    }
}

#Preview {
    NavigationView {
        BudgetView()
    }
} 
