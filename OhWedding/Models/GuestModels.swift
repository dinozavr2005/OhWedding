
import SwiftUI

struct Guest: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var group: String
    var phone: String
    var status: GuestStatus
    var plusOne: Bool
    var dietaryRestrictions: String
    var notes: String  
}

enum GuestStatus: String, CaseIterable {
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
