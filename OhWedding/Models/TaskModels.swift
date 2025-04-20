import Foundation

struct WeddingTask: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var category: TaskCategory
}

enum TaskCategory: String, CaseIterable {
    case general        = "Общее"
    case venue          = "Место"
    case vendors        = "Подрядчики"
    case attire         = "Одежда"
    case decoration     = "Декор"
    case food           = "Еда"
    case music          = "Музыка"
    case photo          = "Фото"
    case transport      = "Транспорт"

    // Новые категории
    case recommendations  // Рекомендации
    case coupleChecklist  // Чек-лист жених и невеста
    case brideTasks       // Задание для невесты
    case weddingChecklist // Чек-лист для свадьбы

    var icon: String {
        switch self {
        case .general: return "list.bullet"
        case .venue: return "building.2"
        case .vendors: return "person.2"
        case .attire: return "tshirt"
        case .decoration: return "sparkles"
        case .food: return "fork.knife"
        case .music: return "music.note"
        case .photo: return "camera"
        case .transport: return "car"
        case .recommendations: return "star" // пример
        case .coupleChecklist: return "checkmark.circle" // пример
        case .brideTasks: return "heart" // пример
        case .weddingChecklist: return "bookmark" // пример
        }
    }
}
