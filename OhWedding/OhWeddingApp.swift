//
//  OhWeddingApp.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 12.04.2025.
//

import SwiftUI

@main
struct OhWeddingApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(AppModel.shared)
                .modelContainer(AppModel.shared.modelContainer) // ← ВАЖНО
        }
    }
}
