import Foundation

final class ProgressViewModel: ObservableObject {
    @Published var completedTasks: Int = 0
    @Published var totalTasks: Int = 0
    @Published var confirmedGuests: Int = 0
    @Published var totalGuests: Int = 0

    /// Средний прогресс по задачам и гостям
    var progressPercentage: Double {
        let taskProgress = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
        let guestProgress = totalGuests > 0 ? Double(confirmedGuests) / Double(totalGuests) : 0
        return (taskProgress + guestProgress) / 2.0
    }

    // MARK: - Методы обновления

    func updateTaskProgress(completed: Int, total: Int) {
        completedTasks = completed
        totalTasks = total
    }

    func updateGuestProgress(confirmed: Int, total: Int) {
        confirmedGuests = confirmed
        totalGuests = total
    }
}
