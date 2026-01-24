//
//  ContactsPickView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 23.01.2026.
//

import SwiftUI
import Contacts
import ContactsUI


struct ContactsPickView: View {
    @Environment(\.dismiss) private var dismiss

    let onDone: ([PickedContact]) -> Void

    @State private var showPicker = false
    @State private var showDeniedAlert = false
    @State private var picked: [PickedContact] = []

    var body: some View {
        NavigationView {
            List {
                if picked.isEmpty {
                    Text("Добавляйте гостей из контактов по одному — каждый выбор попадёт в список ниже.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 8)
                }

                ForEach(picked) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name.isEmpty ? "Без имени" : item.name)
                            .font(.body)

                        if !item.phone.isEmpty {
                            Text(item.phone)
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { picked.remove(atOffsets: $0) }
            }
            .listStyle(.insetGrouped)
            .appBackground()
            .navigationTitle("Контакты")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Сохранить") {
                        onDone(picked)
                        dismiss()
                    }
                    .disabled(picked.isEmpty)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    requestContactsAccessAndOpen()
                } label: {
                    Text("Открыть контакты")
                        .frame(maxWidth: .infinity)
                        .frame(height: 37)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
            .sheet(isPresented: $showPicker) {
                ContactPicker(
                    disabledContactIdentifiers: picked.map { $0.id },
                    onSelect: { contact in
                        let name = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
                        let phone = contact.phoneNumbers.first?.value.stringValue ?? ""

                        // на всякий (если что-то поменялось) — доп. защита
                        guard !picked.contains(where: { $0.id == contact.identifier }) else { return }

                        picked.append(
                            PickedContact(
                                id: contact.identifier,
                                name: name,
                                phone: phone
                            )
                        )
                    },
                    onCancel: { }
                )
            }
            .alert("Нет доступа к контактам", isPresented: $showDeniedAlert) {
                Button("Настройки") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Разрешите доступ к контактам в настройках, чтобы выбрать контакт.")
            }
        }
    }

    private func requestContactsAccessAndOpen() {
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized, .limited:
            showPicker = true

        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    granted ? (showPicker = true) : (showDeniedAlert = true)
                }
            }

        case .denied, .restricted:
            showDeniedAlert = true

        @unknown default:
            showDeniedAlert = true
        }
    }
}


#Preview {
    ContactsPickView(onDone: { _ in })
}
