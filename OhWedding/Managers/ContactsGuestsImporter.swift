//
//  ContactsGuestsImporter.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.01.2026.
//

import Foundation
import SwiftData

final class ContactsGuestsImporter {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func importGuests(from picked: [PickedContact]) throws -> [Guest] {
        var guests: [Guest] = []

        for item in picked {
            let name = item.name.isEmpty ? item.phone : item.name

            let guest = Guest(
                name: name,
                group: "",
                phone: item.phone,
                status: .invited,
                plusOne: false,
                dietaryRestrictions: "",
                notes: ""
            )

            modelContext.insert(guest)
            guests.append(guest)
        }

        try modelContext.save()
        return guests
    }
}
