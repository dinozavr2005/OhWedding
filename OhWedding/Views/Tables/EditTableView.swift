//
//  EditTableView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.08.2025.
//

import SwiftUI

struct EditTableView: View {
    @Environment(\.dismiss) var dismiss

    let availableGuests: [Guest]
    /// onSave должен дергать VM:
    /// viewModel.updateTable(using: context, table:originalTable, name:capacity:shape:newGuests:)
    let onSave: (_ name: String, _ capacity: Int, _ shape: TableShape, _ guests: [Guest]) -> Void

    @State private var name: String
    @State private var capacity: Int
    @State private var shape: TableShape
    @State private var selectedGuestIDs: Set<UUID>

    init(
        table: SeatingTable,
        availableGuests: [Guest],
        onSave: @escaping (_ name: String, _ capacity: Int, _ shape: TableShape, _ guests: [Guest]) -> Void
    ) {
        self.availableGuests = availableGuests
        self.onSave = onSave
        _name = State(initialValue: table.name)
        _capacity = State(initialValue: table.capacity)
        _shape = State(initialValue: table.shape)
        _selectedGuestIDs = State(initialValue: Set(table.guests.map(\.uuid)))
    }

    private var occupied: Int {
        availableGuests
            .filter { selectedGuestIDs.contains($0.uuid) }
            .reduce(0) { $0 + ($1.plusOne ? 2 : 1) }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Информация о столе"),
                    footer: Text("Занято \(occupied) из \(capacity)")
                        .foregroundColor(occupied > capacity ? .red : .secondary)
                ) {
                    TextField("Название стола", text: $name)
                    Stepper("Вместимость: \(capacity)", value: $capacity, in: 1...20)
                    Picker("Форма", selection: $shape) {
                        ForEach(TableShape.allCases) { shape in
                            Text(shape.rawValue).tag(shape)
                        }
                    }
                }

                Section(header: Text("Посадить гостей")) {
                    ForEach(availableGuests) { guest in
                        MultipleSelectionRow(
                            title: guest.name,
                            isSelected: selectedGuestIDs.contains(guest.uuid)
                        ) {
                            if selectedGuestIDs.contains(guest.uuid) {
                                selectedGuestIDs.remove(guest.uuid)
                            } else {
                                selectedGuestIDs.insert(guest.uuid)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Редактировать стол")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let selected = availableGuests.filter { selectedGuestIDs.contains($0.uuid) }
                        onSave(name, capacity, shape, selected)
                        dismiss()
                    }
                    .disabled(name.isEmpty || occupied > capacity)
                }
            }
        }
    }
}
