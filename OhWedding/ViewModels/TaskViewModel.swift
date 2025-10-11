//
//  TaskViewModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 26.04.2025.
//

import SwiftData
import SwiftUI

@MainActor
class TaskViewModel: ObservableObject {
    @Published var tasks: [WeddingTask] = []
    @Published var assignments: [Assignment] = []
    @Published var selectedCategory: TaskCategory?

    private var context: ModelContext?

    // MARK: - Init
    init() {
        self.tasks = WeddingChecklistData.allTasks
    }

    func updateContext(_ context: ModelContext) {
        self.context = context
        loadAssignments()
    }

    // MARK: - SwiftData loading
    func loadAssignments() {
        guard let context else {
            self.assignments = []
            return
        }

        let descriptor = FetchDescriptor<Assignment>(
            sortBy: [SortDescriptor(\.order, order: .forward)]
        )
        self.assignments = (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - Toggle completion
    func toggleAssigmentCompletion(_ assignment: Assignment) {
        guard let context else {
            self.assignments = []
            return
        }
        assignment.isCompleted.toggle()
        try? context.save()
        loadAssignments()
    }

    // MARK: - Add / Delete
    func addAssignment(title: String, detail: String) {
        guard let context else {
            self.assignments = []
            return
        }
        let newAssignment = Assignment(title: title, detail: detail)
        context.insert(newAssignment)
        try? context.save()
        loadAssignments()
    }

    func deleteAssignment(_ assignment: Assignment) {
        guard let context else {
            self.assignments = []
            return
        }
        context.delete(assignment)
        try? context.save()
        loadAssignments()
    }

    // Возвращает все задачи для выбранной категории (если указана)
    var filteredTasks: [WeddingTask] {
        if let category = selectedCategory {
            return tasks.filter { $0.category == category }
        }
        return tasks
    }

    // Общие вычисляемые свойства для всех задач
    var completedTasks: Int {
        tasks.filter { $0.isCompleted }.count
    }

    var totalTasks: Int {
        tasks.count
    }

    // Рекомендации
    var brideCheckListCompleted: Int {
        tasks.filter { $0.category == .brideChecklist && $0.isCompleted }.count
    }

    var brideCheckListTotal: Int {
        tasks.filter { $0.category == .brideChecklist }.count
    }

    // Чек-лист жених и невеста
    var groomChecklistCompleted: Int {
        tasks.filter { $0.category == .groomCheckList && $0.isCompleted }.count
    }

    var groomChecklistTotal: Int {
        tasks.filter { $0.category == .groomCheckList }.count
    }

    // Задание для невесты
    var brideTasksCompleted: Int {
        assignments.filter { $0.isCompleted }.count
    }

    var brideTasksTotal: Int {
        assignments.count
    }

    // Чек-лист для свадьбы
    var weddingChecklistCompleted: Int {
        tasks.filter { $0.category == .weddingChecklist && $0.isCompleted }.count
    }

    var weddingChecklistTotal: Int {
        tasks.filter { $0.category == .weddingChecklist }.count
    }

    // Методы для изменения задач
    func addTask(_ task: WeddingTask) {
        tasks.append(task)
    }

    func toggleTaskCompletion(_ task: WeddingTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(_ task: WeddingTask) {
        tasks.removeAll { $0.id == task.id }
    }

    func updateTask(_ task: WeddingTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
}
