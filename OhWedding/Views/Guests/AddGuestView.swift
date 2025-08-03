//
//  AddGuestView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 29.07.2025.
//

import SwiftUI
import SwiftData

struct AddGuestView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var phone = ""
    @State private var plusOne = false
    @State private var dietaryRestrictions = ""

    let viewModel: GuestViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Основная информация")) {
                    TextField("Имя", text: $name)
                        .autocapitalization(.words)
                    TextField("Телефон", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Дополнительно")) {
                    Toggle("+1", isOn: $plusOne)
                    TextField("Ограничения в питании", text: $dietaryRestrictions)
                }
            }
            .navigationTitle("Новый гость")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Добавить") {
                        viewModel.addGuest(
                            using: modelContext,
                            name: name,
                            phone: phone,
                            plusOne: plusOne,
                            dietaryRestrictions: dietaryRestrictions
                        )
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
