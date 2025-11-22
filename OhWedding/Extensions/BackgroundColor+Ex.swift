//
//  BackgroundColor+Ex.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 14.10.2025.
//

import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()   // ← теперь правильно

            content
        }
    }
}

extension View {
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}
