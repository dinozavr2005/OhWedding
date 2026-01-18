import Foundation
import SwiftData

@MainActor
final class GuestViewModel: ObservableObject {
    @Published var guests: [Guest] = []
    @Published var searchText: String = ""
    @Published var tables: [SeatingTable] = []

    var totalGuestsWithPlusOne: Int {
        guests.reduce(0) { $0 + ($1.plusOne ? 2 : 1) }
    }

    var confirmedGuestsWithPlusOne: Int {
        guests
            .filter { $0.status == .confirmed }
            .reduce(0) { $0 + ($1.plusOne ? 2 : 1) }
    }

    var unassignedGuestsCountWithPlusOne: Int {
        guests
            .filter { $0.seatingTable == nil }
            .reduce(0) { $0 + ($1.plusOne ? 2 : 1) }
    }

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
            loadTables(using: context)
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

    func loadTables(using context: ModelContext) {
        do {
            tables = try context.fetch(
                FetchDescriptor<SeatingTable>(sortBy: [SortDescriptor(\.name)])
            )
        } catch { print("❌ Load tables:", error) }
    }

    func addTable(using context: ModelContext,
                  name: String,
                  capacity: Int,
                  shape: TableShape,
                  guests: [Guest]) {

        let table = SeatingTable(name: name, capacity: capacity, shape: shape)
        context.insert(table)

        // связь в обе стороны (инверс обновится и так, но делаем явно)
        guests.forEach { $0.seatingTable = table }
        table.guests = guests

        do {
            try context.save()
            loadTables(using: context)
            loadGuests(using: context) // чтобы обновился статус у гостей
        } catch { print("❌ Add table:", error) }
    }

    func updateTable(using context: ModelContext,
                     table: SeatingTable,
                     name: String? = nil,
                     capacity: Int? = nil,
                     shape: TableShape? = nil,
                     newGuests: [Guest]? = nil) {
        if let name { table.name = name }
        if let shape { table.shape = shape }

        // если меняем capacity без смены состава — тоже валидируем
        if let newCap = capacity {
            table.capacity = newCap
        }

        if let newGuests {
            let oldSet = Set(table.guests.map(\.uuid))
            let newSet = Set(newGuests.map(\.uuid))

            // снятые
            table.guests.filter { !newSet.contains($0.uuid) }
                .forEach { $0.seatingTable = nil }

            // новые
            newGuests.filter { !oldSet.contains($0.uuid) }
                .forEach { $0.seatingTable = table }

            table.guests = newGuests
        }

        do {
            try context.save()
            loadTables(using: context)
            loadGuests(using: context)
        } catch { print("❌ Update table:", error) }
    }

    func deleteTable(using context: ModelContext, table: SeatingTable) {
        // .nullify на связи сам обнулит guest.seatingTable
        context.delete(table)
        do {
            try context.save()
            loadTables(using: context)
            loadGuests(using: context)
        } catch { print("❌ Delete table:", error) }
    }

    var totalTables: Int { tables.count }

    var unassignedGuestsCount: Int { guests.filter { $0.seatingTable == nil }.count }
    var unassignedGuests: [Guest] { guests.filter { $0.seatingTable == nil } }

    func availableGuests(for table: SeatingTable?) -> [Guest] {
        guests.filter { g in
            // Доступны все без стола + уже сидящие за текущим столом
            g.seatingTable == nil || g.seatingTable?.uuid == table?.uuid
        }
    }
}
