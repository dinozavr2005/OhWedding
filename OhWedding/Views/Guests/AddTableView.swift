//
//  AddTableView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 01.08.2025.
//

import SwiftUI

struct MultipleSelectionRow: View {
    @State private var selectedGuests = Set<Guest>()

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

// MARK: — Форма добавления стола

struct AddTableView: View {
    @Environment(\.dismiss) var dismiss

    let availableGuests: [Guest]
    let onAdd: (SeatingTable) -> Void

    @State private var name: String = ""
    @State private var capacity: Int = 4
    @State private var shape: TableShape = .round
    @State private var selectedGuests = Set<Guest>()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Информация о столе")) {
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
            .navigationTitle("Новый стол")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        let table = SeatingTable(
                            name: name,
                            guests: Array(selectedGuests),
                            capacity: capacity,
                            shape: shape
                        )
                        onAdd(table)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
