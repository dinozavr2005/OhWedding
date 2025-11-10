//
//  TimingViewModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftUI
import SwiftData

@MainActor
final class TimingViewModel: ObservableObject {
    @Published var blocks: [TimingBlock] = []
    @Published var isEditing: Bool = false

    private let context: ModelContext

    // MARK: - Init
    init(context: ModelContext) {
        self.context = context
        fetchBlocks()
    }

    // MARK: - Загрузка данных
    func fetchBlocks() {
        // Загружаем все блоки и сортируем по order
        let descriptor = FetchDescriptor<TimingBlock>(sortBy: [SortDescriptor(\.order, order: .forward)])
        do {
            blocks = try context.fetch(descriptor)
        } catch {
            print("❌ Ошибка при загрузке блоков тайминга: \(error)")
        }
    }

    // MARK: - Добавление блока после другого блока
    func insertBlock(after block: TimingBlock? = nil, title: String = "Новый блок") {
        let sorted = blocks.sorted(by: { $0.order < $1.order })
        let newOrder: Double

        if let block {
            // Найдём блок, который идёт после текущего
            if let next = sorted.first(where: { $0.order > block.order }) {
                // Вставляем между текущим и следующим (среднее значение)
                newOrder = (block.order + next.order) / 2
            } else {
                // Если текущий — последний, ставим +1
                newOrder = block.order + 1
            }
        } else {
            // Если список пуст — начинаем с 1
            newOrder = 1
        }

        let newBlock = TimingBlock(order: newOrder, title: title)
        context.insert(newBlock)
        saveContext()
        fetchBlocks()
    }

    // MARK: - Удаление и переименование блока
    func deleteBlock(_ block: TimingBlock) {
        context.delete(block)
        saveContext()
        fetchBlocks()
    }

    func renameBlock(_ block: TimingBlock, newTitle: String) {
        block.title = newTitle
        saveContext()
        fetchBlocks()
    }

    // MARK: - Позиции
    func addPosition(to block: TimingBlock, time: Date, title: String = "Новая позиция") {
        let newPosition = TimingPosition(time: time, title: title)
        block.positions.append(newPosition)
        saveContext()
        fetchBlocks()
    }

    func addPosition(to block: TimingBlock, title: String = "Новая позиция") {
        addPosition(to: block, time: defaultTime(), title: title)
    }

    func deletePosition(from block: TimingBlock, position: TimingPosition) {
        block.positions.removeAll { $0 == position }
        saveContext()
        fetchBlocks()
    }

    func updatePosition(_ position: TimingPosition, newTime: Date? = nil, newTitle: String? = nil) {
        if let newTime { position.time = newTime }
        if let newTitle { position.title = newTitle }
        saveContext()
        fetchBlocks()
    }

    // MARK: - Наполнение
    func addContent(to position: TimingPosition, title: String) {
        position.contents.append(TimingContent(title: title))
        saveContext()
        fetchBlocks()
    }

    func deleteContent(from position: TimingPosition, content: TimingContent) {
        position.contents.removeAll { $0 == content }
        saveContext()
        fetchBlocks()
    }

    // MARK: - Helpers
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Ошибка при сохранении контекста: \(error)")
        }
    }

    private func defaultTime() -> Date {
        Calendar.current.date(from: DateComponents(hour: 12, minute: 0)) ?? Date()
    }
}
