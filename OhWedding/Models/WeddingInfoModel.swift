import Foundation
import SwiftData

@Model
final class WeddingInfo {
    var groomName: String
    var brideName: String
    var weddingDate: Date
    var budget: Double

    init(
        groomName: String = "",
        brideName: String = "",
        weddingDate: Date = Date(),
        budget: Double = 0
    ) {
        self.groomName = groomName
        self.brideName = brideName
        self.weddingDate = weddingDate
        self.budget = budget
    }
}
