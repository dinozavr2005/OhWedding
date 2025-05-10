//
//  Assignment.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 10.05.2025.
//

import Foundation

struct Assignment {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    var dueDate: Date?
}
