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
    let onSave: (SeatingTable) -> Void

    @State private var table: SeatingTable
    @State private var selectedGuests: Set<Guest>

    init(table: SeatingTable,
         availableGuests: [Guest],
         onSave: @escaping (SeatingTable) -> Void)
    {
        self.availableGuests = availableGuests
        self.onSave = onSave
        _table = State(initialValue: table)
        _selectedGuests = State(initialValue: Set(table.guests))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Информация о столе")) {
                    TextField("Название стола", text: $table.name)
                    Stepper("Вместимость: \(table.capacity)", value: $table.capacity, in: 1...20)
                    Picker("Форма", selection: $table.shape) {
                        ForEach(TableShape.allCases) { shape in
                            Text(shape.rawValue).tag(shape)
                        }
                    }
                }

                Section(header: Text("Посадить гостей")) {
                    ForEach(availableGuests) { guest in
                        MultipleSelectionRow(
                            title: guest.name,
                            isSelected: selectedGuests.contains(guest)
                        ) {
                            if selectedGuests.contains(guest) {
                                selectedGuests.remove(guest)
                            } else {
                                selectedGuests.insert(guest)
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
                        var updated = table
                        updated.guests = Array(selectedGuests)
                        onSave(updated)
                        dismiss()
                    }
                    .disabled(table.name.isEmpty)
                }
            }
        }
    }
}

