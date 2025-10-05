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
            // Название стола
            Text(table.name)
                .font(.headline)

            ZStack {
                // --- Форма стола ---
                if table.shape == .round {
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 150, height: 150)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 2)
                        .frame(width: 150, height: 150)
                }

                // --- Гости внутри ---
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(table.guests) { guest in
                            Text(guest.name)
                                .font(.caption)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(maxWidth: 130)
                                // 👇 добавили возможность перетаскивать гостя наружу
                                .onDrag {
                                    NSItemProvider(object: guest.uuid.uuidString as NSString)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                }
                .frame(width: 150, height: 150)
            }
            .background(Color.clear)
            .contentShape(Rectangle())
            // 👇 принимаем гостей, которых перетащили на этот стол
            .onDrop(of: [.plainText], isTargeted: nil) { providers in
                handleDrop(providers)
            }
        }
    }

    // MARK: - Drag & Drop
    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }

        provider.loadObject(ofClass: NSString.self) { item, error in
            if let error = error {
                print("❌ Error loading item: \(error)")
                return
            }

            guard
                let uuidString = item as? String,
                let guestID = UUID(uuidString: uuidString),
                let guest = allGuests.first(where: { $0.uuid == guestID })
            else {
                print("❌ Guest not found or invalid UUID")
                return
            }

            DispatchQueue.main.async {
                onDropGuest(guest)
            }
        }
        return true
    }
}
