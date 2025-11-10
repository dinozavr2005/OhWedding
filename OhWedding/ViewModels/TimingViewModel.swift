//
//  TimingViewModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftUI

@MainActor
final class TimingViewModel: ObservableObject {
    @Published var blocks: [TimingBlock] = []
    @Published var isEditing: Bool = false

    // MARK: - Init
    init() {
        loadSampleData() // временно для примера
    }

    // MARK: - Загрузка данных
    private func loadSampleData() {
        blocks = TimingBlock.sampleData()
    }

    // MARK: - Блоки

    /// Добавить новый блок
    func addBlock(title: String = "Новый блок") {
        let newBlock = TimingBlock(title: title)
        blocks.append(newBlock)
    }

    /// Удалить блок
    func deleteBlock(_ block: TimingBlock) {
        blocks.removeAll { $0.id == block.id }
    }

    /// Обновить название блока
    func renameBlock(_ block: TimingBlock, newTitle: String) {
        block.title = newTitle
    }

    // MARK: - Позиции

    /// Добавить новую позицию в указанный блок
    func addPosition(to block: TimingBlock, time: Date, title: String = "Новая позиция") {
        let newPosition = TimingPosition(time: time, title: title)
        block.positions.append(newPosition)
        sortPositions(in: block)
        objectWillChange.send()
    }

    /// Удобный метод: добавить позицию с дефолтным временем
    func addPosition(to block: TimingBlock, title: String = "Новая позиция") {
        let time = defaultTime()
        addPosition(to: block, time: time, title: title)
    }

    /// Удалить позицию из блока
    func deletePosition(from block: TimingBlock, position: TimingPosition) {
        block.positions.removeAll { $0.id == position.id }
        objectWillChange.send()
    }

    /// Обновить данные позиции (например, изменить время или заголовок)
    func updatePosition(in block: TimingBlock, positionID: UUID, newTime: Date? = nil, newTitle: String? = nil) {
        guard let index = block.positions.firstIndex(where: { $0.id == positionID }) else { return }
        var position = block.positions[index]
        if let newTime { position.time = newTime }
        if let newTitle { position.title = newTitle }
        block.positions[index] = position
        sortPositions(in: block)
        objectWillChange.send()
    }

    // MARK: - Наполнение

    /// Добавить элемент наполнения в позицию
    func addContent(to block: TimingBlock, positionID: UUID, title: String) {
        guard let posIndex = block.positions.firstIndex(where: { $0.id == positionID }) else { return }
        block.positions[posIndex].contents.append(TimingContent(title: title))
        objectWillChange.send()
    }

    /// Удалить элемент наполнения
    func deleteContent(from block: TimingBlock, positionID: UUID, content: TimingContent) {
        guard let posIndex = block.positions.firstIndex(where: { $0.id == positionID }) else { return }
        block.positions[posIndex].contents.removeAll { $0.id == content.id }
        objectWillChange.send()
    }

    // MARK: - Сортировка по времени

    private func sortPositions(in block: TimingBlock) {
        block.positions.sort { $0.time < $1.time }
    }

    // MARK: - Вспомогательные методы

    private func defaultTime() -> Date {
        let calendar = Calendar.current
        return calendar.date(from: DateComponents(hour: 12, minute: 0)) ?? Date()
    }
}
