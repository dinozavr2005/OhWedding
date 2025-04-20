import Foundation

struct Expense: Identifiable {
    let id = UUID()
    var title: String
    var amount: Double
    var category: ExpenseCategory
    var date: Date
    var isPaid: Bool
    var notes: String
}

enum ExpenseCategory: String, CaseIterable {
    case venue = "Место"
    case catering = "Кейтеринг"
    case decoration = "Декор"
    case attire = "Одежда"
    case photo = "Фото"
    case music = "Музыка"
    case transport = "Транспорт"
    case other = "Другое"
    
    var icon: String {
        switch self {
        case .venue: return "building.2"
        case .catering: return "fork.knife"
        case .decoration: return "sparkles"
        case .attire: return "tshirt"
        case .photo: return "camera"
        case .music: return "music.note"
        case .transport: return "car"
        case .other: return "square.grid.2x2"
        }
    }
} 