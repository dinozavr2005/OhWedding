//
//  GuestRow.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 31.07.2025.
//

import SwiftUI

struct GuestRow: View {
    let guest: Guest
    var onStatusTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(guest.name)
                        .font(.headline)

                    if guest.plusOne {
                        PlusOneBadge()
                    }
                }

                HStack {
                    Image(systemName: "phone")
                        .foregroundColor(.purple)
                    Text(guest.phone)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            StatusBadge(status: guest.status, onTap: onStatusTap)
        }
        .padding(.vertical, 4)
    }
}
