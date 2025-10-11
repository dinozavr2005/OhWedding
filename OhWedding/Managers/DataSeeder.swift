//
//  DataSeeder.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 09.10.2025.
//

import SwiftUI
import SwiftData

struct DataSeeder {
    static func seedAssignmentsIfNeeded(context: ModelContext) {
        do {
            let count = try context.fetchCount(FetchDescriptor<Assignment>())
            guard count == 0 else {
                print("ℹ️ Assignments already exist: \(count)")
                return
            }

            for (index, assignment) in AssignmentData.assignments.enumerated() {
                let copy = Assignment(
                    title: assignment.title,
                    detail: assignment.detail,
                    isCompleted: assignment.isCompleted,
                    dueDate: assignment.dueDate,
                    order: index   // 👈 сохраняем индекс
                )
                context.insert(copy)
            }

            try context.save()
            print("✅ Seeded \(AssignmentData.assignments.count) assignments with order")
        } catch {
            print("❌ Failed to seed assignments:", error)
        }
    }
}
