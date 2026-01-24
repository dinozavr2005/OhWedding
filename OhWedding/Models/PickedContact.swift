//
//  PickedContact.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 23.01.2026.
//

import Foundation

struct PickedContact: Identifiable, Hashable {
    let id: String         // CNContact.identifier
    let name: String
    let phone: String
}
