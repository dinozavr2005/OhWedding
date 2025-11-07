import Foundation
import SwiftData

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var advance: Double
    var categoryRaw: String
    var subcategoryRaw: String?
    var date: Date
    var notes: String

    init(id: UUID = UUID(),
         title: String,
         amount: Double,
         advance: Double = 0,
         category: ExpenseCategory,
         subcategory: String? = nil,
         date: Date,
         isPaid: Bool = false,
         notes: String = "") {
        self.id = id
        self.title = title
        self.amount = amount
        self.advance = advance
        self.categoryRaw = category.rawValue
        self.subcategoryRaw = subcategory
        self.date = date
        self.notes = notes
    }

    /// Удобное свойство для работы с enum
    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }
    var subcategory: String {
        get { subcategoryRaw ?? "" }
        set { subcategoryRaw = newValue }
    }
    var debt: Double {
        max(amount - advance, 0)
    }

    var isPaid: Bool {
        debt == 0
    }
}

enum ExpenseCategory: String, CaseIterable {
    case banquet = "Банкет"
    case invitation = "Приглашение"
    case creativeTeam = "Творческая команда"
    case welcome = "Welcome"
    case showProgram = "Шоу-программа"
    case videoProduction = "Видеопродукты"
    case direction = "Режиссура"
    case morning = "Утро"
    case other = "Другое"

    var icon: String {
        switch self {
        case .banquet: return "fork.knife"
        case .invitation: return "envelope"
        case .creativeTeam: return "person.3"
        case .welcome: return "hand.wave"
        case .showProgram: return "sparkles"
        case .videoProduction: return "video"
        case .direction: return "theatermasks"
        case .morning: return "sunrise"
        case .other: return "square.grid.2x2"
        }
    }

    var subcategories: [String] {
        switch self {
        case .banquet:
            return ["Аренда локации", "Еда+Напитки", "Алкоголь", "Питание персонала"]
        case .invitation:
            return ["Сайт", "Картинка", "Печать", "Доставка"]
        case .creativeTeam:
            return ["Ведущий", "Диджей", "Техническое обеспечение","Декорации", "Видеограф","Фотограф", "Торт", "Кавер-группа/Вокалист", "Организация", "Продление", "Аниматоры"]
        case .welcome:
            return ["Интерактивные локации/Наполнение", "Фуршет", "Музыка"]
        case .showProgram:
            return ["Выступления", "Конферансье"]
        case .videoProduction:
            return ["LOVE STORY", "Ролики \"до свадьбы\"", "Ролики с гостями на свадьбе", "SDE", "Футажи и заставки"]
        case .direction:
            return ["Появление молодых", "Первый танец", "Танец с папой", "Танец с мамой", "Появление торта", "Подарки друг другу", "Ползунки", "Финал вечера"]
        case .morning:
            return ["Аренда локаций утра", "Декор утра невесты", "Реквизит", "Аренда машины", "Фуршет"]
        case .other:
            return ["Прочее"]
        }
    }
}
