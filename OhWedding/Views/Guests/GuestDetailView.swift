//
//  GuestDetailView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 31.07.2025.
//

import SwiftUI

struct GuestDetailView: View {
    let guest: Guest
    let onUpdate: (Guest) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var editedGuest: Guest

    init(guest: Guest, onUpdate: @escaping (Guest) -> Void) {
        self.guest = guest
        self.onUpdate = onUpdate
        _editedGuest = State(initialValue: guest)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Статус")) {
                    Picker("Статус", selection: $editedGuest.status) {
                        ForEach(GuestStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }

                Section(header: Text("Контактная информация")) {
                    TextField("Имя", text: $editedGuest.name)
                    TextField("Телефон", text: $editedGuest.phone)
                }

                Section(header: Text("Дополнительно")) {
                    Toggle("+1", isOn: $editedGuest.plusOne)
                    TextField("Ограничения в питании", text: $editedGuest.dietaryRestrictions)
                }
            }
            .navigationTitle("Информация о госте")
            .appBackground()
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Сохранить") {
                    onUpdate(editedGuest)
                    dismiss()
                }
            )
        }
    }
}
