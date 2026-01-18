//
//  SearchBar.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 02.01.2026.
//

import SwiftUI

struct SearchBar: View {
    let placeholder: String
    @Binding var text: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.secondary)

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.secondary))
                .font(.manropeMedium(size: 17))
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.search)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary.opacity(0.9))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.black.opacity(0.08), lineWidth: 1)
        )
        // Если хочешь как “мягкая карточка” (опционально)
        // .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 6)
    }
}
