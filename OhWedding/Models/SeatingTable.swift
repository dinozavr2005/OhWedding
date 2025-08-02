//
//  SeatingTable.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 29.07.2025.
//

import Foundation

struct SeatingTable: Identifiable {
    let id = UUID()
    var name: String            // Например: "Стол 1", "VIP", "Семья невесты"
    var guests: [Guest]          // ID гостей, посаженных за стол
    var capacity: Int
    var shape: TableShape
}

enum TableShape: String, CaseIterable, Identifiable {
    case round = "Круглый"
    case rectangular = "Прямоугольный"
    case square = "Квадратный"
    case oval = "Овальный"

    var id: String { rawValue }
}
