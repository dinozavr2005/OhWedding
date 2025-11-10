//
//  TimingModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import SwiftData
import Foundation

// MARK: - Наполнение позиции
@Model
final class TimingContent {
    var title: String

    init(title: String) {
        self.title = title
    }
}

// MARK: - Позиция (время + описание + наполнение)
@Model
final class TimingPosition {
    var time: Date
    var title: String
    @Relationship(deleteRule: .cascade) var contents: [TimingContent] = []

    init(time: Date, title: String, contents: [TimingContent] = []) {
        self.time = time
        self.title = title
        self.contents = contents
    }

    // Удобное форматирование времени
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}

// MARK: - Блок (например, "Утро", "Банкет")
@Model
final class TimingBlock {
    var order: Double
    var title: String
    @Relationship(deleteRule: .cascade) var positions: [TimingPosition] = []

    init(order: Double = 0, title: String, positions: [TimingPosition] = []) {
        self.order = order
        self.title = title
        self.positions = positions
    }
}

// MARK: - Предзаполненные данные (sampleData)
extension TimingBlock {
    static func sampleData() -> [TimingBlock] {
        let calendar = Calendar.current

        return [
            TimingBlock(
                order: 1,
                title: "Утро невесты",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 8, minute: 0))!,
                        title: "Съёмка невесты",
                        contents: [
                            TimingContent(title: "Фотосессия")
                        ]
                    ),
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 8, minute: 30))!,
                        title: "Встреча",
                        contents: []
                    ),
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 9, minute: 0))!,
                        title: "Съёмка молодожён",
                        contents: [
                            TimingContent(title: "Фотосессия")
                        ]
                    )
                ]
            ),

            TimingBlock(
                order: 2,
                title: "ЗАГС (если есть в этот день)",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 11, minute: 0))!,
                        title: "Церемония регистрации брака",
                        contents: []
                    )
                ]
            ),

            TimingBlock(
                order: 3,
                title: "Welcome (1 час)",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 12, minute: 0))!,
                        title: "Встреча гостей",
                        contents: [
                            TimingContent(title: "Фотосессия"),
                            TimingContent(title: "Фуршет")
                        ]
                    )
                ]
            ),

            TimingBlock(
                order: 4,
                title: "Регистрация (если есть)",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 13, minute: 0))!,
                        title: "Регистрация на площадке",
                        contents: [
                            TimingContent(title: "Одаривание"),
                            TimingContent(title: "Фотосессия")
                        ]
                    )
                ]
            ),

            TimingBlock(
                order: 5,
                title: "Появление и банкет",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 14, minute: 0))!,
                        title: "Первая часть банкета (1.5 ч)",
                        contents: [
                            TimingContent(title: "Одаривание"),
                            TimingContent(title: "Тосты"),
                            TimingContent(title: "Общение"),
                            TimingContent(title: "Love Story"),
                            TimingContent(title: "Первый танец")
                        ]
                    ),
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 15, minute: 30))!,
                        title: "Вторая часть банкета (1.5 ч)",
                        contents: [
                            TimingContent(title: "30 мин танцы"),
                            TimingContent(title: "Тосты"),
                            TimingContent(title: "Интерактивы"),
                            TimingContent(title: "Шоу"),
                            TimingContent(title: "Танец с папой")
                        ]
                    ),
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 17, minute: 0))!,
                        title: "Третья часть банкета (1.5 ч)",
                        contents: [
                            TimingContent(title: "30 мин танцы"),
                            TimingContent(title: "Интерактивы"),
                            TimingContent(title: "Видео"),
                            TimingContent(title: "Бросание букета"),
                            TimingContent(title: "Бутониерка"),
                            TimingContent(title: "Торт")
                        ]
                    )
                ]
            ),

            TimingBlock(
                order: 6,
                title: "SDE (танцы / свободное время)",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 18, minute: 30))!,
                        title: "Танцы и свободное время",
                        contents: [
                            TimingContent(title: "SDE видео"),
                            TimingContent(title: "Танцы"),
                            TimingContent(title: "Свободное общение")
                        ]
                    )
                ]
            )
        ]
    }
}
