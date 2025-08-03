//
//  SeatingTable.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 29.07.2025.
//

import Foundation

class SeatingTable: Identifiable {
    var id: UUID
    var name: String
    var guests: [Guest]
    var capacity: Int
    var shape: TableShape

    init(id: UUID = UUID(), name: String, guests: [Guest] = [], capacity: Int, shape: TableShape) {
        self.id = id
        self.name = name
        self.guests = guests
        self.capacity = capacity
        self.shape = shape
    }
}

enum TableShape: String, CaseIterable, Identifiable {
    case round = "Круглый"
    case rectangular = "Прямоугольный"
    case square = "Квадратный"
    case oval = "Овальный"

    var id: String { rawValue }
}
