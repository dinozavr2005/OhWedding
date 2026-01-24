//
//  ProgressOverviewView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 24.01.2026.
//

import SwiftUI

// MARK: - ProgressOverviewView

struct ProgressOverviewView: View {

    // MARK: - Input

    let progress: Double
    let completedTasks: Int
    let totalTasks: Int
    let totalGuestsWithPlusOne: Int

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Прогресс подготовки")
                .font(.manropeSemiBold(size: 18))

            ProgressBar(value: progress)

            HStack {
                ProgressStat(
                    title: "Задачи",
                    value: "\(completedTasks)/\(totalTasks)"
                )
                Spacer()
                ProgressStat(
                    title: "Гости",
                    value: "\(totalGuestsWithPlusOne)"
                )
            }
        }
        .padding()
        .background(cardBackground)
    }
}

private extension ProgressOverviewView {
    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - ProgressBar

struct ProgressBar: View {
    let value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 12)

                RoundedRectangle(cornerRadius: 10)
                    .fill(progressGradient)
                    .frame(width: geometry.size.width * value, height: 12)
            }
        }
        .frame(height: 12)
    }
}

// MARK: - ProgressBar + UI

private extension ProgressBar {

    var progressGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "4ECDC4"),
                Color(hex: "6C5CE7")
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - ProgressStat

struct ProgressStat: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.manropeRegular(size: 12))
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(size: 16, weight: .medium))
        }
    }
}
