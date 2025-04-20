import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/BudgetView.swift", line: 1)
import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var weddingViewModel: WeddingViewModel
    @State private var showingAddExpense = false
    @State private var showingEditBudget = false
    @State private var newBudget: String = ""
    
    var body: some View {
        List {
            // Budget summary
            Section {
                VStack(spacing: __designTimeInteger("#9863_0", fallback: 16)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(__designTimeString("#9863_1", fallback: "Общий бюджет"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: __designTimeString("#9863_2", fallback: "%.0f ₽"), weddingViewModel.weddingInfo.budget))
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingEditBudget = __designTimeBoolean("#9863_3", fallback: true) }) {
                            Image(systemName: __designTimeString("#9863_4", fallback: "pencil.circle"))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(__designTimeString("#9863_5", fallback: "Потрачено"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: __designTimeString("#9863_6", fallback: "%.0f ₽"), weddingViewModel.budgetViewModel.totalExpenses))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(__designTimeString("#9863_7", fallback: "Осталось"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: __designTimeString("#9863_8", fallback: "%.0f ₽"), weddingViewModel.weddingInfo.budget - weddingViewModel.budgetViewModel.totalExpenses))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }
                    
                    BudgetProgressView(
                        spent: weddingViewModel.budgetViewModel.totalExpenses,
                        total: weddingViewModel.weddingInfo.budget
                    )
                }
                .padding(.vertical, __designTimeInteger("#9863_9", fallback: 8))
            }
            
            // Expenses by category
            Section(header: Text(__designTimeString("#9863_10", fallback: "Расходы по категориям"))) {
                ForEach(ExpenseCategory.allCases, id: \.self) { category in
                    CategoryRow(
                        category: category,
                        amount: weddingViewModel.budgetViewModel.expensesByCategory(category),
                        total: weddingViewModel.weddingInfo.budget
                    )
                }
            }
            
            // Recent expenses
            Section(header: Text(__designTimeString("#9863_11", fallback: "Последние расходы"))) {
                ForEach(weddingViewModel.budgetViewModel.filteredExpenses) { expense in
                    ExpenseRow(expense: expense) {
                        weddingViewModel.budgetViewModel.toggleExpensePayment(expense)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let expense = weddingViewModel.budgetViewModel.filteredExpenses[index]
                        weddingViewModel.budgetViewModel.deleteExpense(expense)
                    }
                }
            }
        }
        .navigationTitle(__designTimeString("#9863_12", fallback: "Бюджет"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddExpense = __designTimeBoolean("#9863_13", fallback: true) }) {
                    Image(systemName: __designTimeString("#9863_14", fallback: "plus"))
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView { expense in
                weddingViewModel.budgetViewModel.addExpense(expense)
            }
        }
        .alert(__designTimeString("#9863_15", fallback: "Изменить бюджет"), isPresented: $showingEditBudget) {
            TextField(__designTimeString("#9863_16", fallback: "Новый бюджет"), text: $newBudget)
                .keyboardType(.numberPad)
            
            Button(__designTimeString("#9863_17", fallback: "Отмена"), role: .cancel) { }
            Button(__designTimeString("#9863_18", fallback: "Сохранить")) {
                if let budget = Double(newBudget) {
                    weddingViewModel.updateBudget(budget)
                }
            }
        } message: {
            Text(__designTimeString("#9863_19", fallback: "Введите новую сумму бюджета"))
        }
    }
}

struct BudgetProgressView: View {
    let spent: Double
    let total: Double
    
    var progress: Double {
        min(spent / total, __designTimeFloat("#9863_20", fallback: 1.0))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: __designTimeInteger("#9863_21", fallback: 8))
                    .fill(Color.gray.opacity(__designTimeFloat("#9863_22", fallback: 0.2)))
                    .frame(height: __designTimeInteger("#9863_23", fallback: 8))
                
                RoundedRectangle(cornerRadius: __designTimeInteger("#9863_24", fallback: 8))
                    .fill(progressColor)
                    .frame(width: geometry.size.width * progress, height: __designTimeInteger("#9863_25", fallback: 8))
            }
        }
        .frame(height: __designTimeInteger("#9863_26", fallback: 8))
    }
    
    var progressColor: Color {
        if progress < __designTimeFloat("#9863_27", fallback: 0.5) {
            return .green
        } else if progress < __designTimeFloat("#9863_28", fallback: 0.8) {
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
        min(amount / total, __designTimeFloat("#9863_29", fallback: 1.0))
    }
    
    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .foregroundColor(.blue)
                .frame(width: __designTimeInteger("#9863_30", fallback: 30))
            
            VStack(alignment: .leading) {
                Text(category.rawValue)
                Text(String(format: __designTimeString("#9863_31", fallback: "%.0f ₽"), amount))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: __designTimeString("#9863_32", fallback: "%.0f%%"), progress * __designTimeInteger("#9863_33", fallback: 100)))
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
                Text(String(format: __designTimeString("#9863_34", fallback: "%.0f ₽"), expense.amount))
                    .font(.headline)
                
                Button(action: onToggle) {
                    Text(expense.isPaid ? __designTimeString("#9863_35", fallback: "Оплачено") : __designTimeString("#9863_36", fallback: "Не оплачено"))
                        .font(.caption)
                        .padding(.horizontal, __designTimeInteger("#9863_37", fallback: 8))
                        .padding(.vertical, __designTimeInteger("#9863_38", fallback: 4))
                        .background(expense.isPaid ? Color.green.opacity(__designTimeFloat("#9863_39", fallback: 0.2)) : Color.orange.opacity(__designTimeFloat("#9863_40", fallback: 0.2)))
                        .foregroundColor(expense.isPaid ? .green : .orange)
                        .cornerRadius(__designTimeInteger("#9863_41", fallback: 8))
                }
            }
        }
        .padding(.vertical, __designTimeInteger("#9863_42", fallback: 4))
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
                Section(header: Text(__designTimeString("#9863_43", fallback: "Основная информация"))) {
                    TextField(__designTimeString("#9863_44", fallback: "Название"), text: $title)
                    TextField(__designTimeString("#9863_45", fallback: "Сумма"), text: $amount)
                        .keyboardType(.numberPad)
                    
                    Picker(__designTimeString("#9863_46", fallback: "Категория"), selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
                
                Section(header: Text(__designTimeString("#9863_47", fallback: "Дополнительно"))) {
                    DatePicker(__designTimeString("#9863_48", fallback: "Дата"), selection: $date, displayedComponents: .date)
                    Toggle(__designTimeString("#9863_49", fallback: "Оплачено"), isOn: $isPaid)
                    TextField(__designTimeString("#9863_50", fallback: "Заметки"), text: $notes)
                }
            }
            .navigationTitle(__designTimeString("#9863_51", fallback: "Новый расход"))
            .navigationBarItems(
                leading: Button(__designTimeString("#9863_52", fallback: "Отмена")) { dismiss() },
                trailing: Button(__designTimeString("#9863_53", fallback: "Добавить")) {
                    if let amountValue = Double(amount) {
                        let expense = Expense(
                            title: title,
                            amount: amountValue,
                            category: category,
                            date: date,
                            isPaid: isPaid,
                            notes: notes.isEmpty ? nil : notes
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
            .environmentObject(WeddingViewModel())
    }
} 
