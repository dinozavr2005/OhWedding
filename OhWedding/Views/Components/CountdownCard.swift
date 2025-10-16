//
//  CountdownCard.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 14.10.2025.
//

import SwiftUI

struct CountdownCard: View {
    let days: Int

    var body: some View {
        VStack(spacing: 4) {
            Spacer()
            Text("До свадьбы осталось")
                .font(.manropeMedium(size: 16))
                .foregroundColor(.black.opacity(0.7))

            Text("\(days)")
                .font(.manropeBold(size: 64))
                .foregroundColor(.black)

            Text(daysString(for: days))
                .font(.manropeMedium(size: 16))
                .foregroundColor(.black.opacity(0.7))
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 180)
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "F0AAFF").opacity(0.3), location: 0.0),
                    .init(color: Color(hex: "F0AAFF").opacity(0.3), location: 0.6),
                    .init(color: Color(hex: "6C5CE7").opacity(0.3), location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 8)
        )
    }

    private func daysString(for number: Int) -> String {
        let n = number % 100
        if n >= 11 && n <= 14 { return "дней" }
        switch number % 10 {
        case 1: return "день"
        case 2, 3, 4: return "дня"
        default: return "дней"
        }
    }
}
