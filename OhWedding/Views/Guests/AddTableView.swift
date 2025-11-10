//
//  AddTableView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 01.08.2025.
//

import SwiftUI

// MARK: - Row

struct MultipleSelectionRow: View {
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

// MARK: - Форма добавления стола (под новые методы VM)

struct AddTableView: View {
    @Environment(\.dismiss) var dismiss

    let availableGuests: [Guest]
    /// onAdd вызывает VM:
    /// viewModel.addTable(using: context, name:capacity:shape:guests:)
    let onAdd: (_ name: String, _ capacity: Int, _ shape: TableShape, _ guests: [Guest]) -> Void

    @State private var name: String = ""
    @State private var capacity: Int = 4
    @State private var shape: TableShape = .round
    @State private var selectedGuestIDs = Set<UUID>()

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
                        let title = guest.plusOne ? "\(guest.name) +1" : guest.name

                        MultipleSelectionRow(
                            title: title,
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
            .navigationTitle("Новый стол")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        let selected = availableGuests.filter { selectedGuestIDs.contains($0.uuid) }
                        onAdd(name, capacity, shape, selected)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

