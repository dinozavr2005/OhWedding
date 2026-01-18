//
//  PlusOneBadge.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 05.08.2025.
//

import SwiftUI

struct PlusOneBadge: View {
    var body: some View {
        Text("+1")
            .font(.caption2.weight(.semibold))
            .foregroundColor(.purple)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.purple.opacity(0.15))
            )
    }
}
