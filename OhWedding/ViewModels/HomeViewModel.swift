import Foundation
import SwiftData

// MARK: - HomeViewModel

@MainActor
final class HomeViewModel: ObservableObject {

    // MARK: - State

    @Published private(set) var isLoaded: Bool = false

    @Published private(set) var completedTasks: Int = 0
    @Published private(set) var totalTasks: Int = 0

    @Published private(set) var confirmedGuestsWithPlusOne: Int = 0
    @Published private(set) var totalGuestsWithPlusOne: Int = 0

    // MARK: - Derived

    var progressPercentage: Double {
        // Если хочешь: задачи + гости 50/50
        let tasksPart = totalTasks == 0 ? 0 : Double(completedTasks) / Double(totalTasks)
        let guestsPart = totalGuestsWithPlusOne == 0 ? 0 : Double(confirmedGuestsWithPlusOne) / Double(totalGuestsWithPlusOne)
        return (tasksPart + guestsPart) / 2.0
    }

    // MARK: - Lifecycle

    init() {}

    // MARK: - Public API

    /// Loads all required data for Home screen once.
    /// Keeps WeddingInfoViewModel as a single source of truth for wedding info (SwiftData).
    func loadIfNeeded(
        using context: ModelContext,
        weddingVM: WeddingInfoViewModel,
        guestVM: GuestViewModel,
        taskVM: TaskViewModel
    ) {
        guard !isLoaded else { return }
        isLoaded = true

        // 1) Wedding info (source of truth is WeddingInfoViewModel)
        weddingVM.loadInfo(using: context)

        // 2) Guests
        guestVM.loadGuests(using: context)
        guestVM.loadTables(using: context)

        // 3) Tasks
        taskVM.updateContext(context)

        // 4) Aggregates for Home (progress)
        refreshProgress(guestVM: guestVM, taskVM: taskVM)
    }

    /// Updates only screen aggregates. Call when returning to Home if needed.
    func refreshProgress(guestVM: GuestViewModel, taskVM: TaskViewModel) {
        confirmedGuestsWithPlusOne = guestVM.confirmedGuestsWithPlusOne
        totalGuestsWithPlusOne = guestVM.totalGuestsWithPlusOne

        completedTasks = taskVM.completedTasks
        totalTasks = taskVM.totalTasks
    }

    /// If you need to re-run initial load (e.g. logout / reset).
    func reset() {
        isLoaded = false
        completedTasks = 0
        totalTasks = 0
        confirmedGuestsWithPlusOne = 0
        totalGuestsWithPlusOne = 0
    }
}
