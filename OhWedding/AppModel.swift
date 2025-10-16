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
            // Путь к базе
            let url = URL.documentsDirectory.appending(path: "Wedding.sqlite")
            
            // Конфигурация базы
            let configuration = ModelConfiguration(url: url)
            
            // Контейнер со всеми моделями
            let container = try ModelContainer(
                for: Guest.self,
                SeatingTable.self,
                Assignment.self,
                WeddingTask.self,
                configurations: configuration
            )
            
            let appModel = AppModel(container: container)
            DataSeeder.seedAllIfNeeded(context: appModel.modelContext)
            
            return appModel
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
