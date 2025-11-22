//
//  WeddingChecklistData.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import Foundation

struct WeddingChecklistData {

    // MARK: - Общие задачи
    static let commonTasks: [WeddingTask] = [
        WeddingTask(title: "Кольца",
                    isCompleted: false,
                    dueDate: nil,
                    category: .weddingChecklist,
                    emoji: "💍"),

        WeddingTask(title: "Брачная ночь",
                    isCompleted: false,
                    dueDate: nil,
                    category: .weddingChecklist,
                    emoji: "🌙")
    ]

    // MARK: - Задачи для невесты
    static let brideTasks: [WeddingTask] = [
        WeddingTask(title: "Платье", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👗"),
        WeddingTask(title: "Второе платье (полегче)", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👗"),
        WeddingTask(title: "Туфли", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👠"),
        WeddingTask(title: "Сменная обувь", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👡"),
        WeddingTask(title: "Фата", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👰"),
        WeddingTask(title: "Заколка", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "✨"),
        WeddingTask(title: "Бельё", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🩱"),

        WeddingTask(title: "Утренний образ", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💄"),
        WeddingTask(title: "Утренний образ подруг", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💄"),
        WeddingTask(title: "Вечерний образ", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👗"),

        WeddingTask(title: "Прическа/укладка", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💇‍♀️"),
        WeddingTask(title: "Макияж", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💋"),
        WeddingTask(title: "Укладка (повтор)", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💇‍♀️"),

        WeddingTask(title: "Аксессуары", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💍"),
        WeddingTask(title: "Манекен для платья", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🧵"),
        WeddingTask(title: "Подвязка", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🩱"),

        WeddingTask(title: "Коррекция бровей", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "✨"),
        WeddingTask(title: "Ресницы", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "👁️"),

        WeddingTask(title: "Маникюр", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💅"),
        WeddingTask(title: "Педикюр", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🦶"),

        WeddingTask(title: "Косметолог", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "💆‍♀️"),
        WeddingTask(title: "Эпиляция", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🪒"),

        WeddingTask(title: "Чистка зубов", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🦷"),

        WeddingTask(title: "Нижнее белье", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🩱"),
        WeddingTask(title: "Верхняя одежда/накидка/плед", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🧥"),

        WeddingTask(title: "Духи", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "🌸"),
        WeddingTask(title: "Зонт", isCompleted: false, dueDate: nil, category: .brideChecklist, emoji: "☔")
    ]

    // MARK: - Задачи для жениха
    static let groomTasks: [WeddingTask] = [
        WeddingTask(title: "Костюм", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "🤵"),
        WeddingTask(title: "Рубашка", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "👔"),
        WeddingTask(title: "Вторая рубашка", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "👕"),
        WeddingTask(title: "Обувь", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "👞"),
        WeddingTask(title: "Галстук/бабочка", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "🎀"),
        WeddingTask(title: "Ремень", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "🧢"),
        WeddingTask(title: "Носки", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "🧦"),

        WeddingTask(title: "Прическа/борода", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "💇‍♂️"),
        WeddingTask(title: "Косметолог", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "💆‍♂️"),

        WeddingTask(title: "Чистка зубов", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "🦷"),
        WeddingTask(title: "Коррекция бровей", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "✨"),

        WeddingTask(title: "Маникюр", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "💅"),
        WeddingTask(title: "Верхняя одежда/плед", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "🧥"),

        WeddingTask(title: "Зонт", isCompleted: false, dueDate: nil, category: .groomCheckList, emoji: "☔")
    ]

    // MARK: - Всё вместе
    static var allTasks: [WeddingTask] {
        commonTasks + brideTasks + groomTasks
    }
}
