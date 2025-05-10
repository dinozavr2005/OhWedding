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
        WeddingTask(title: "Кольца", isCompleted: false, dueDate: Date(), category: .weddingChecklist),
        WeddingTask(title: "Брачная ночь", isCompleted: false, dueDate: Date(), category: .weddingChecklist)
    ]

    /// Задачи для невесты (все имеют категорию .coupleChecklist)
    static let brideTasks: [WeddingTask] = [
        WeddingTask(title: "Платье", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Второе платье (полегче)", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Туфли", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Сменная обувь", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Фата", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Заколка", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Бельё", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Утренний образ", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Утренний образ подруг", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Вечерний образ", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Прическа/укладка", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Макияж", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Укладка", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Аксессуары", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Манекен для платья", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Подвязка", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Коррекция бровей", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Ресницы", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Маникюр", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Педикюр", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Косметолог", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Эпиляция", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Отбеливание/чистка зубов", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Нижнее белье", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Верхняя одежда/накидка/плед", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Духи", isCompleted: false, dueDate: Date(), category: .brideChecklist),
        WeddingTask(title: "Зонт", isCompleted: false, dueDate: Date(), category: .brideChecklist)
    ]

    /// Задачи для жениха (также с категорией .coupleChecklist)
    static let groomTasks: [WeddingTask] = [
        WeddingTask(title: "Костюм", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Рубашка", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Вторая рубашка (на смену)", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Обувь", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Галстук/бабочка/платок", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Ремень", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Носки", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Прическа/укладка/борода", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Косметолог", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Отбеливание/чистка зубов", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Коррекция бровей", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Маникюр", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Верхняя одежда/накидка/плед", isCompleted: false, dueDate: Date(), category: .groomCheckList),
        WeddingTask(title: "Зонт", isCompleted: false, dueDate: Date(), category: .groomCheckList)
    ]

    /// Все задачи из чек-листа
    static var allTasks: [WeddingTask] {
        commonTasks + brideTasks + groomTasks
    }
}
