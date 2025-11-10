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
                    order: index
                )
                context.insert(copy)
            }

            try context.save()
            print("✅ Seeded \(AssignmentData.assignments.count) assignments")
        } catch {
            print("❌ Failed to seed assignments:", error)
        }
    }

    static func seedWeddingTasksIfNeeded(context: ModelContext) {
        do {
            let count = try context.fetchCount(FetchDescriptor<WeddingTask>())
            guard count == 0 else {
                print("ℹ️ Wedding tasks already exist: \(count)")
                return
            }

            for task in WeddingChecklistData.allTasks {
                let copy = WeddingTask(
                    title: task.title,
                    isCompleted: task.isCompleted,
                    dueDate: task.dueDate,
                    category: task.category
                )
                context.insert(copy)
            }

            try context.save()
            print("✅ Seeded \(WeddingChecklistData.allTasks.count) wedding tasks")
        } catch {
            print("❌ Failed to seed wedding tasks:", error)
        }
    }

    static func seedTimingIfNeeded(context: ModelContext) {
        do {
            let count = try context.fetchCount(FetchDescriptor<TimingBlock>())
            guard count == 0 else {
                print("ℹ️ Timing blocks already exist: \(count)")
                return
            }

            // Используем предзаполненные данные
            let sampleBlocks = TimingBlock.sampleData()
            for block in sampleBlocks {
                context.insert(block)
            }

            try context.save()
            print("✅ Seeded \(sampleBlocks.count) timing blocks")
        } catch {
            print("❌ Failed to seed timing blocks:", error)
        }
    }

    static func seedAllIfNeeded(context: ModelContext) {
        seedAssignmentsIfNeeded(context: context)
        seedWeddingTasksIfNeeded(context: context)
        seedTimingIfNeeded(context: context)
    }
}
