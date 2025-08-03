
import SwiftUI
import SwiftData

@Model
    class Guest {
    @Attribute(.unique)
    var uuid: UUID = UUID()
    var name: String
    var group: String
    var phone: String
    var status: GuestStatus
    var plusOne: Bool
    var dietaryRestrictions: String
    var notes: String

    init(
        name: String,
        group: String,
        phone: String,
        status: GuestStatus,
        plusOne: Bool,
        dietaryRestrictions: String,
        notes: String
    ) {
        self.name = name
        self.group = group
        self.phone = phone
        self.status = status
        self.plusOne = plusOne
        self.dietaryRestrictions = dietaryRestrictions
        self.notes = notes
    }
}



enum GuestStatus: String, CaseIterable, Codable {
    case invited = "Приглашен"
    case confirmed = "Подтвердил"
    case declined = "Отклонил"
    
    var color: Color {
        switch self {
        case .invited: return .gray
        case .confirmed: return .green
        case .declined: return .red
        }
    }
} 
