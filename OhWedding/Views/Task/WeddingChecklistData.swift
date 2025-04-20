//
//  WeddingChecklistData.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import Foundation

struct WeddingChecklistData {
    /// Общие задачи, относящиеся ко всей свадьбе
    static let commonTasks: [WeddingTask] = [
        WeddingTask(title: "Кольца", isCompleted: false, dueDate: Date(), category: .general),
        WeddingTask(title: "Брачная ночь", isCompleted: false, dueDate: Date(), category: .general)
    ]

    /// Задачи для невесты (все имеют категорию .coupleChecklist)
    static let brideTasks: [WeddingTask] = [
        WeddingTask(title: "Платье", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Второе платье (полегче)", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Туфли", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Сменная обувь", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Фата", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Заколка", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Бельё", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Утренний образ", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Утренний образ подруг", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Вечерний образ", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Прическа/укладка", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Макияж", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Укладка", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Аксессуары", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Манекен для платья", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Подвязка", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Коррекция бровей", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Ресницы", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Маникюр", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Педикюр", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Косметолог", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Эпиляция", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Отбеливание/чистка зубов", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Нижнее белье", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Верхняя одежда/накидка/плед", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Духи", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Зонт", isCompleted: false, dueDate: Date(), category: .coupleChecklist)
    ]

    /// Задачи для жениха (также с категорией .coupleChecklist)
    static let groomTasks: [WeddingTask] = [
        WeddingTask(title: "Костюм", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Рубашка", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Вторая рубашка (на смену)", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Обувь", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Галстук/бабочка/платок", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Ремень", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Носки", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Прическа/укладка/борода", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Косметолог", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Отбеливание/чистка зубов", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Коррекция бровей", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Маникюр", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Верхняя одежда/накидка/плед", isCompleted: false, dueDate: Date(), category: .coupleChecklist),
        WeddingTask(title: "Зонт", isCompleted: false, dueDate: Date(), category: .coupleChecklist)
    ]

    /// Все задачи из чек-листа
    static var allTasks: [WeddingTask] {
        commonTasks + brideTasks + groomTasks
    }
}
