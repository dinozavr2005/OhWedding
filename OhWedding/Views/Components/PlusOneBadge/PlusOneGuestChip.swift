//
//  PlusOneGuestChip.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 18.01.2026.
//

import SwiftUI

struct PlusOneGuestChip: View {
    let guest: Guest

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(guest.name)
                .font(.system(size: 16))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(height: 40)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)

            if guest.plusOne {
                Text("+1")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.9))
                    .cornerRadius(8)
                    .offset(x: 6, y: -6)
            }
        }
    }
}
