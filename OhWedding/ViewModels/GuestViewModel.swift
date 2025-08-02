import SwiftUI

class GuestViewModel: ObservableObject {
    @Published var guests: [Guest] = []
    @Published var searchText: String = ""
    @Published var tables: [SeatingTable] = []

    var filteredGuests: [Guest] {
        if searchText.isEmpty {
            return guests
        }
        return guests.filter { guest in
            guest.name.localizedCaseInsensitiveContains(searchText) ||
            guest.group.localizedCaseInsensitiveContains(searchText)
        }
    }

    var totalGuests: Int {
        guests.count
    }

    var confirmedGuests: Int {
        guests.filter { $0.status == .confirmed }.count
    }

    var pendingGuests: Int {
        guests.filter { $0.status == .invited }.count
    }

    var declinedGuests: Int {
        guests.filter { $0.status == .declined }.count
    }

    var totalTables: Int {
        tables.count
    }

    var unassignedGuestsCount: Int {
        let assignedIDs = Set(tables.flatMap { $0.guests.map(\.id) })
        return guests.filter { !assignedIDs.contains($0.id) }.count
    }

    func addGuest(_ guest: Guest) {
        guests.append(guest)
    }

    func updateGuest(_ guest: Guest) {
        if let index = guests.firstIndex(where: { $0.id == guest.id }) {
            guests[index] = guest
        }
    }

    func deleteGuest(_ guest: Guest) {
        guests.removeAll { $0.id == guest.id }
    }

    func updateGuestStatus(_ guest: Guest, status: GuestStatus) {
        if let index = guests.firstIndex(where: { $0.id == guest.id }) {
            guests[index].status = status
        }
    }

    /// Все гости, которых ещё не посадили ни за один стол
    var unassignedGuests: [Guest] {
        let assignedIDs = Set(tables.flatMap { $0.guests.map(\.id) })
        return guests.filter { !assignedIDs.contains($0.id) }
    }

    /// Гости, доступные для данного стола (не считая тех, что уже за ним сидят)
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
