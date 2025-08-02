//
//  GuestRow.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 31.07.2025.
//

import SwiftUI

struct GuestRow: View {
    let guest: Guest

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(guest.name)
                    .font(.headline)

                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.blue)
                    Text(guest.phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            StatusBadge(status: guest.status)
        }
        .padding(.vertical, 4)
    }
}
