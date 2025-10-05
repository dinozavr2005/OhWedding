//
//  SeatingTable.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 29.07.2025.
//

import Foundation
import SwiftData

@Model
final class SeatingTable {
    @Attribute(.unique)
    var uuid: UUID
    var name: String
    @Relationship(deleteRule: .nullify, inverse: \Guest.seatingTable)
    var guests: [Guest]
    var capacity: Int
    var shape: TableShape

    init(uuid: UUID = UUID(), name: String, guests: [Guest] = [], capacity: Int, shape: TableShape) {
        self.uuid = uuid
        self.name = name
        self.guests = guests
        self.capacity = capacity
        self.shape = shape
    }
}

enum TableShape: String, Codable, CaseIterable, Identifiable {
    case round = "Круглый"
    case rectangular = "Прямоугольный"
    case square = "Квадратный"
    case oval = "Овальный"

    var id: String { rawValue }
}
