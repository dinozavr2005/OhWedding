import Foundation
import SwiftData

@MainActor
class GuestViewModel: ObservableObject {
    @Published var guests: [Guest] = []
    @Published var searchText: String = ""
    @Published var tables: [SeatingTable] = []

    init() {}

    // MARK: - Guests

    func loadGuests(using context: ModelContext) {
        do {
            guests = try context.fetch(FetchDescriptor<Guest>())
        } catch {
            print("❌ Ошибка при загрузке гостей: \(error)")
        }
    }

    func addGuest(using context: ModelContext,
                  name: String,
                  phone: String,
                  plusOne: Bool,
                  dietaryRestrictions: String) {
        let guest = Guest(
            name: name,
            group: "",
            phone: phone,
            status: .invited,
            plusOne: plusOne,
            dietaryRestrictions: dietaryRestrictions,
            notes: ""
        )
        context.insert(guest)
        do {
            try context.save()
            guests.append(guest)
        } catch {
            print("❌ Ошибка при сохранении гостя: \(error)")
        }
    }

    func addGuests(using context: ModelContext, guests: [Guest]) {
        for guest in guests {
            context.insert(guest)
        }
        do {
            try context.save()
            loadGuests(using: context)
        } catch {
            print("❌ Ошибка при импорте гостей: \(error)")
        }
    }

    func updateGuest(using context: ModelContext, guest: Guest, mutate: (Guest) -> Void) {
        mutate(guest)
        do {
            try context.save()
            loadGuests(using: context)
        } catch {
            print("❌ Ошибка при обновлении гостя: \(error)")
        }
    }

    func deleteGuest(using context: ModelContext, guest: Guest) {
        context.delete(guest)
        do {
            try context.save()
            guests.removeAll { $0.id == guest.id }
        } catch {
            print("❌ Ошибка при удалении гостя: \(error)")
        }
    }

    func updateGuestStatus(using context: ModelContext, guest: Guest, status: GuestStatus) {
        updateGuest(using: context, guest: guest) { $0.status = status }
    }

    var filteredGuests: [Guest] {
        if searchText.isEmpty {
            return guests
        }
        return guests.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.group.localizedCaseInsensitiveContains(searchText)
        }
    }

    var totalGuests: Int { guests.count }

    var confirmedGuests: Int {
        guests.filter { $0.status == .confirmed }.count
    }

    var pendingGuests: Int {
        guests.filter { $0.status == .invited }.count
    }

    var declinedGuests: Int {
        guests.filter { $0.status == .declined }.count
    }

    // MARK: - Tables

    var totalTables: Int { tables.count }

    var unassignedGuestsCount: Int {
        let assignedIDs = Set(tables.flatMap { $0.guests.map(\.id) })
        return guests.filter { !assignedIDs.contains($0.id) }.count
    }

    var unassignedGuests: [Guest] {
        let assignedIDs = Set(tables.flatMap { $0.guests.map(\.id) })
        return guests.filter { !assignedIDs.contains($0.id) }
    }

    func availableGuests(for table: SeatingTable?) -> [Guest] {
        let otherAssigned = tables
            .filter { $0.id != table?.id }
            .flatMap { $0.guests }

        let assignedSet = Set(otherAssigned.map(\.id))
        return guests.filter { !assignedSet.contains($0.id) }
    }

    func addTable(_ table: SeatingTable) {
        tables.append(table)
    }

    func updateAllTables(_ newTables: [SeatingTable]) {
        tables = newTables
    }

    func updateTable(_ table: SeatingTable) {
        if let idx = tables.firstIndex(where: { $0.id == table.id }) {
            tables[idx] = table
        }
    }

    func deleteTable(_ table: SeatingTable) {
        tables.removeAll { $0.id == table.id }
    }
}
