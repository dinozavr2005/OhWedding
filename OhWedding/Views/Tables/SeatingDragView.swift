//
//  SeatingDragView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.08.2025.
//

import SwiftUI

struct SeatingDragView: View {
    let guests: [Guest]
    @Binding var tables: [SeatingTable]
    let onUpdate: () -> Void
    @Environment(\.dismiss) private var dismiss

    // --- сетка столов: 2 колонки ---
    private let tableColumns = [
        GridItem(.flexible(minimum: 120), spacing: 20),
        GridItem(.flexible(minimum: 120), spacing: 20)
    ]

    // --- две строки для гостей ---
    private let guestRows = [
        GridItem(.fixed(40), spacing: 10),
        GridItem(.fixed(40), spacing: 10)
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // --- Столы ---
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: tableColumns, spacing: 20) {
                        ForEach(tables, id: \.uuid) { table in
                            SeatingTableView(table: table,
                                             allGuests: guests,
                                             onDropGuest: { guest in
                                handleDrop(guest, to: table)
                            })
                            .frame(minHeight: 120)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemBackground))

                Divider()

                // --- Гости без мест ---
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: guestRows, spacing: 10) {
                        ForEach(unseatedGuests) { guest in
                            Text(guest.name)
                                .font(.system(size: 16))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .frame(height: 40)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .onDrag {
                                    NSItemProvider(object: guest.uuid.uuidString as NSString)
                                }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                // Приём дропа от гостей из столов
                .onDrop(of: [.text], isTargeted: nil) { providers in
                    guard let provider = providers.first else { return false }
                    provider.loadObject(ofClass: NSString.self) { item, _ in
                        guard
                            let uuidString = item as? String,
                            let id = UUID(uuidString: uuidString),
                            let guest = guests.first(where: { $0.uuid == id })
                        else { return }
                        DispatchQueue.main.async { handleReturn(guest) }
                    }
                    return true
                }
                .frame(height: 90)
                .background(Color(UIColor.systemBackground))
            }
            .navigationTitle("Схема столов")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        onUpdate()
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Логика перемещения


    private func handleDrop(_ guest: Guest, to table: SeatingTable) {
        // Убираем из всех столов
        for i in tables.indices {
            tables[i].guests.removeAll { $0.uuid == guest.uuid }
        }

        // Назначаем новый стол прямо в модели гостя (важно для SwiftData)
        guest.seatingTable = table

        // Добавляем в выбранный стол
        if let idx = tables.firstIndex(where: { $0.uuid == table.uuid }) {
            tables[idx].guests.append(guest)
        }
    }

    private func handleReturn(_ guest: Guest) {
        // Убираем из всех столов
        for i in tables.indices {
            tables[i].guests.removeAll { $0.uuid == guest.uuid }
        }

        // Освобождаем место — теперь гость без стола
        guest.seatingTable = nil
    }

    // MARK: - Вычисляемые данные

    /// Гости, которые ещё не посажены за столы
    private var unseatedGuests: [Guest] {
        let occupiedIDs = Set(tables.flatMap { $0.guests.map(\.uuid) })
        return guests.filter { !occupiedIDs.contains($0.uuid) }
    }
}
