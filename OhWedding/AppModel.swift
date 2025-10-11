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
            // Путь к файлу базы
            let url = URL.documentsDirectory.appending(path: "Wedding.sqlite")

            // Конфигурация без имени (одна база для всех моделей)
            let configuration = ModelConfiguration(url: url)

            // Контейнер с перечислением всех моделей
            let container = try ModelContainer(
                for: Guest.self,
                    SeatingTable.self,
                    Assignment.self,
                configurations: configuration
            )

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

