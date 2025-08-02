//
//  AddGuestView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 29.07.2025.
//

import SwiftUI

struct AddGuestView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var phone = ""
    @State private var plusOne = false
    @State private var dietaryRestrictions = ""

    // onAdd возвращает созданного гостя
    let onAdd: (Guest) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основная информация")) {
                    TextField("Имя", text: $name)
                    TextField("Телефон", text: $phone)
                }

                Section(header: Text("Дополнительно")) {
                    Toggle("+1", isOn: $plusOne)
                    TextField("Ограничения в питании", text: $dietaryRestrictions)
                }
            }
            .navigationTitle("Новый гость")
            .navigationBarItems(
                leading: Button("Отмена") { dismiss() },
                trailing: Button("Добавить") {
                    let guest = Guest(
                        name: name,
                        group: "",               // Если не используется, оставляем пустым
                        phone: phone,
                        status: .invited,
                        plusOne: plusOne,
                        dietaryRestrictions: dietaryRestrictions,
                        notes: ""                // Если нет заметок, оставляем пустым
                    )
                    onAdd(guest)
                    dismiss()
                }
                .disabled(name.isEmpty)
            )
        }
    }
}
