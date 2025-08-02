//
//  TableViewCell.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.08.2025.
//

import SwiftUI

struct SeatingTableView: View {
    let table: SeatingTable
    let allGuests: [Guest]
    let onDropGuest: (Guest) -> Void

    var body: some View {
        VStack {
            Text(table.name)
                .font(.headline)

            ZStack {
                if table.shape == .round {
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 150, height: 150)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 2)
                        .frame(width: 150, height: 150)
                }

                VStack {
                    ForEach(table.guests) { guest in
                        Text(guest.name)
                            .font(.caption)
                    }
                }
            }
            .frame(width: 150, height: 150) // обязательно!
            .background(Color.clear)        // без этого drop не работает
            .contentShape(Rectangle())      // делает всю область активной
            .onDrop(of: [.plainText], isTargeted: nil) { providers in
                print("📥 Drop started")

                guard let provider = providers.first else {
                    print("⚠️ No providers")
                    return false
                }

                _ = provider.loadObject(ofClass: NSString.self) { item, error in
                    if let error = error {
                        print("❌ Error loading item: \(error)")
                        return
                    }

                    guard let uuidString = item as? String else {
                        print("❌ Failed to cast item as String")
                        return
                    }

                    print("📦 Received UUID string: \(uuidString)")

                    guard let guestID = UUID(uuidString: uuidString) else {
                        print("❌ Failed to create UUID from string")
                        return
                    }

                    guard let guest = allGuests.first(where: { $0.id == guestID }) else {
                        print("❌ Guest not found in allGuests")
                        return
                    }

                    print("✅ Successfully dropped guest: \(guest.name) (\(guest.id))")

                    DispatchQueue.main.async {
                        onDropGuest(guest)
                    }
                }

                return true
            }

        }
    }
}
