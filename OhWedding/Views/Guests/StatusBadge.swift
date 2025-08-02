//
//  StatusBadge.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.08.2025.
//

import SwiftUI

struct StatusBadge: View {
    let status: GuestStatus

    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}
