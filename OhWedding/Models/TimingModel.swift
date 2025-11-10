//
//  TimingModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.11.2025.
//

import Foundation

// MARK: - Наполнение позиции
struct TimingContent: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
}

// MARK: - Позиция (время + описание + наполнение)
struct TimingPosition: Identifiable, Codable, Hashable {
    var id = UUID()
    var time: Date
    var title: String
    var contents: [TimingContent] = []

    // Удобное отображение
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
}

// MARK: - Блок (например, "Утро", "Банкет")
final class TimingBlock: Identifiable, ObservableObject, Codable {
    var id = UUID()
    @Published var title: String
    @Published var positions: [TimingPosition] = []

    init(title: String, positions: [TimingPosition] = []) {
        self.title = title
        self.positions = positions
    }

    // MARK: Codable
    enum CodingKeys: CodingKey {
        case id, title, positions
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        positions = try container.decode([TimingPosition].self, forKey: .positions)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(positions, forKey: .positions)
    }
}

// MARK: - Данные
extension TimingBlock {
    static func sampleData() -> [TimingBlock] {
        let calendar = Calendar.current

        return [
            TimingBlock(
                title: "Утро невесты",
                positions: [
                    TimingPosition(
                        time: calendar.date(from: DateComponents(hour: 8, minute: 0))!,
                        title: "Подготовка",
                        contents: [
                            TimingContent(title: "Съёмка невесты"),
                            TimingContent(title: "Встреча"),
                            TimingContent(title: "Съёмка молодожён")
                        ]
                    )
                ]
            ),

            TimingBlock(
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
