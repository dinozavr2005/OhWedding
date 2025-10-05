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
            .font(.caption2)
            .foregroundColor(.white)
            .padding(6)
            .background(Circle().fill(Color.green.opacity(0.8)))
    }
}
