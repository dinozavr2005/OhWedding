//
//  QuickActionCard.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 14.10.2025.
//

import SwiftUI

struct QuickActionCard: View {
    let title: String
    let image: Image
    let color: Color

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(color)
                .frame(width: 70, height: 70)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )

            Text(title)
                .font(.manropeBold(size: 15))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}
