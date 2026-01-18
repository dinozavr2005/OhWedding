//
//  StatCardsRow.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.01.2026.
//

import SwiftUI

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)

                Text(title)
                    .font(.manropeMedium(size: 15))
                    .foregroundColor(.secondary)

                Spacer()
            }

            Text("\(value)")
                .font(.manropeSemiBold(size: 30))
        }
        .padding(16)
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
struct StatCardsRow: View {
    let total: Int
    let confirmed: Int

    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "person.2",
                iconColor: Color(red: 0.52, green: 0.47, blue: 0.73),
                title: "Всего гостей",
                value: total
            )

            StatCard(
                icon: "checkmark",
                iconColor: .green,
                title: "Подтвердили",
                value: confirmed
            )
        }
        .frame(height: 112)
    }
}

struct SeatingStatCardsRow: View {
    let totalTables: Int
    let unseatedCount: Int

    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "square.grid.2x2",
                iconColor: Color(red: 0.52, green: 0.47, blue: 0.73),
                title: "Всего столов",
                value: totalTables
            )

            StatCard(
                icon: "person.2",
                iconColor: .orange,
                title: "Без места",
                value: unseatedCount
            )
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}
