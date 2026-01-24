//
//  ContactPicker.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.01.2026.
//

import SwiftUI
import Contacts
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {
    let disabledContactIdentifiers: [String]
    let onSelect: (CNContact) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let vc = CNContactPickerViewController()
        vc.delegate = context.coordinator
        applyDisabledPredicate(to: vc)
        return vc
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
        applyDisabledPredicate(to: uiViewController)
    }

    private func applyDisabledPredicate(to vc: CNContactPickerViewController) {
        guard !disabledContactIdentifiers.isEmpty else {
            vc.predicateForEnablingContact = nil
            return
        }
        vc.predicateForEnablingContact = NSPredicate(
            format: "NOT(identifier IN %@)",
            disabledContactIdentifiers
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelect: onSelect, onCancel: onCancel)
    }

    final class Coordinator: NSObject, CNContactPickerDelegate {
        let onSelect: (CNContact) -> Void
        let onCancel: () -> Void

        init(onSelect: @escaping (CNContact) -> Void, onCancel: @escaping () -> Void) {
            self.onSelect = onSelect
            self.onCancel = onCancel
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            onSelect(contact)
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            onCancel()
        }
    }
}
