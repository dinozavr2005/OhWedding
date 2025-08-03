//
//  SeatingDragView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.08.2025.
//

import SwiftUI

struct SeatingDragView: View {
    let guests: [Guest]
    @Binding var tables: [SeatingTable]
    let onUpdate: () -> Void
    @Environment(\.dismiss) private var dismiss

    static var draggedGuest: Guest?

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(tables.indices, id: \.self) { index in
                            SeatingTableView(table: tables[index], allGuests: guests) { guest in
                                handleDrop(guest, to: index)
                            }
                        }
                    }
                    .padding()
                }

                Divider().padding(.vertical)

                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(guests) { guest in
                            Text(guest.name)
                                .padding(8)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                                .onDrag {
                                    print("⬆️ Start dragging: \(guest.name) — \(guest.uuid)")
                                    return NSItemProvider(object: guest.uuid.uuidString as NSString)
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Рассадка")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") {
                        onUpdate()
                        dismiss()
                    }
                }
            }
        }
    }

    private func handleDrop(_ guest: Guest, to index: Int) {
        print("📌 handleDrop called with guest: \(guest.name), table: \(tables[index].name)")

        if tables[index].guests.contains(where: { $0.uuid == guest.uuid }) {
            print("⚠️ Guest already at this table")
            return
        }

        var table = tables[index]
        table.guests.append(guest)
        tables[index] = table 
        print("✅ Guest added to table \(tables[index].name)")
    }
}
