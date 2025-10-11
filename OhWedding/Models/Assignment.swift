//
//  Assignment.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import SwiftData
import Foundation

@Model
final class Assignment {
    @Attribute(.unique) var id: UUID
    var title: String
    var detail: String
    var isCompleted: Bool
    var dueDate: Date?
    var order: Int

    init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        isCompleted: Bool = false,
        dueDate: Date? = nil,
        order: Int = 0
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.order = order
    }
}
