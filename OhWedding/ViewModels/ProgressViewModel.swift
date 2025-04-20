import Foundation

class ProgressViewModel: ObservableObject {
    @Published var completedTasks: Int = 0
    @Published var totalTasks: Int = 0
    @Published var confirmedGuests: Int = 0
    @Published var totalGuests: Int = 0
    @Published var totalExpenses: Double = 0
    @Published var totalBudget: Double = 0
    
    var progressPercentage: Double {
        let taskProgress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
        let guestProgress = totalGuests > 0 ? Double(confirmedGuests) / Double(totalGuests) : 0
        let budgetProgress = totalBudget > 0 ? totalExpenses / totalBudget : 0
        
        return (taskProgress + guestProgress + budgetProgress) / 3.0
    }
    
    func updateTaskProgress(completed: Int, total: Int) {
        completedTasks = completed
        totalTasks = total
    }
    
    func updateGuestProgress(confirmed: Int, total: Int) {
        confirmedGuests = confirmed
        totalGuests = total
    }
    
    func updateBudgetProgress(expenses: Double, budget: Double) {
        totalExpenses = expenses
        totalBudget = budget
    }
} 