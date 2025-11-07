import Foundation
import SwiftData

@Model
final class WeddingInfo {
    var groomName: String
    var brideName: String
    var weddingDate: Date

    init(
        groomName: String = "",
        brideName: String = "",
        weddingDate: Date = Date()
    ) {
        self.groomName = groomName
        self.brideName = brideName
        self.weddingDate = weddingDate
    }
}
