import SwiftUI

class GuestViewModel: ObservableObject {
    @Published var guests: [Guest] = []
    @Published var searchText: String = ""

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
}
