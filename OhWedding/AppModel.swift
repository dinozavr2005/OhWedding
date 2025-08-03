//
//  AppModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 03.08.2025.
//

import Foundation
import SwiftData

@MainActor
final class AppModel: ObservableObject {
    static let shared: AppModel = {
        do {
            let url = URL.documentsDirectory.appending(path: "Guests.sqlite")
            let configuration = ModelConfiguration("GuestModel", url: url)
            let container = try ModelContainer(for: Guest.self, configurations: configuration)
            return AppModel(container: container)
        } catch {
            fatalError("❌ Не удалось инициализировать ModelContainer: \(error)")
        }
    }()

    let modelContainer: ModelContainer
    var modelContext: ModelContext { modelContainer.mainContext }

    private init(container: ModelContainer) {
        self.modelContainer = container
    }
}
