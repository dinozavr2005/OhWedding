import Foundation
import SwiftData

@Model
final class WeddingInfo {
    var groomName: String
    var brideName: String
    var weddingDate: Date?

    init(
        groomName: String = "",
        brideName: String = "",
        weddingDate: Date? = nil
    ) {
        self.groomName = groomName
        self.brideName = brideName
        self.weddingDate = weddingDate
    }
}
