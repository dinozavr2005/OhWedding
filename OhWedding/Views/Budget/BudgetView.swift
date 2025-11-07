//
//  BudgetView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI
import SwiftData

struct BudgetView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = BudgetViewModel()
    @StateObject private var weddingViewModel = WeddingInfoViewModel()

    @State private var expandedCategories: Set<ExpenseCategory> = []
    @State private var selectedCategory: ExpenseCategory? = nil
    @State private var selectedExpense: Expense? = nil          // 👈 выбранный расход для редактирования
    @State private var showingAddExpense = false
    @State private var showingEditBudget = false
    @State private var newBudget: String = ""

    var body: some View {
        List {
            budgetSummarySection
            categorySection
            recentExpensesSection
        }
        .background(categoryNavigationLink)
        .navigationTitle("Бюджет")
        .toolbar { addExpenseButton }
        .sheet(isPresented: $showingAddExpense) { addExpenseSheet }
        .sheet(item: $selectedExpense) { expense in              // 👈 sheet для редактирования
            EditExpenseView(expense: expense) { updatedExpense in
                viewModel.updateExpense(updatedExpense, using: context)
            }
        }
        .alert("Изменить бюджет", isPresented: $showingEditBudget) { editBudgetAlert } message: {
            Text("Введите новую сумму бюджета")
        }
        .onAppear {
            weddingViewModel.loadInfo(using: context)
            viewModel.load(using: context)
        }
    }
}

// MARK: - Секция бюджета
private extension BudgetView {
    var budgetSummarySection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {

                // MARK: - Расходы
                HStack {
                    Text("Расходы:")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.totalExpenses.formattedCurrency)
                        .font(.headline)
                        .fontWeight(.semibold)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(" Предоплата:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(viewModel.paidAmount.formattedCurrency)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    HStack {
                        Text(" Остаток:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(viewModel.unpaidAmount.formattedCurrency)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .listRowBackground(Color.white)
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Категории расходов
private extension BudgetView {
    var categorySection: some View {
        Section(header: Text("Расходы по категориям")) {
            ForEach(ExpenseCategory.allCases, id: \.self) { category in
                CategoryCell(
                    category: category,
                    isExpanded: expandedCategories.contains(category),
                    totalBudget: weddingViewModel.totalBudget,
                    expenses: viewModel.expensesByCategory[category] ?? [],
                    onExpandToggle: { toggleCategory(category) },
                    onTap: { selectedCategory = category },
                    amountProvider: { subcategory in
                        viewModel.amount(for: category, subcategory: subcategory)
                    }
                )
            }
        }
    }

    func toggleCategory(_ category: ExpenseCategory) {
        withAnimation(.easeInOut(duration: 0.25)) {
            if expandedCategories.contains(category) {
                expandedCategories.remove(category)
            } else {
                expandedCategories.insert(category)
            }
        }
    }
}

// MARK: - Последние расходы
private extension BudgetView {
    var recentExpensesSection: some View {
        Section(header: Text("Последние расходы")) {
            ForEach(viewModel.expenses.reversed()) { expense in
                Button {
                    selectedExpense = expense
                } label: {
                    ExpenseRow(expense: expense)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    // Удаляем с учётом обратного порядка
                    let reversedExpenses = viewModel.expenses.reversed()
                    let expense = Array(reversedExpenses)[index]
                    viewModel.deleteExpense(expense, using: context)
                }
            }
        }
    }
}

// MARK: - Навигация по категориям
private extension BudgetView {
    var categoryNavigationLink: some View {
        NavigationLink(
            destination: Group {
                if let category = selectedCategory {
                    CategoryDetailView(category: category)
                }
            },
            isActive: Binding(
                get: { selectedCategory != nil },
                set: { if !$0 { selectedCategory = nil } }
            )
        ) {
            EmptyView()
        }
        .hidden()
    }

    var addExpenseButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { showingAddExpense = true }) {
                Image(systemName: "plus")
            }
        }
    }

    var addExpenseSheet: some View {
        AddExpenseView { expense in
            viewModel.addExpense(expense, using: context)
        }
    }

    var editBudgetAlert: some View {
        Group {
            TextField("Новый бюджет", text: $newBudget)
                .keyboardType(.numberPad)
            Button("Отмена", role: .cancel) {}
            Button("Сохранить") {
                if let budget = Double(newBudget) {
                    weddingViewModel.updateBudget(budget, using: context)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        BudgetView()
            .modelContainer(for: [WeddingInfo.self, Expense.self], inMemory: true)
    }
}
