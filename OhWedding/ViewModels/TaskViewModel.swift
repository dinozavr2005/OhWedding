//
//  TaskViewModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 26.04.2025.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [WeddingTask] = []
    @Published var assignments: [Assignment] = []
    @Published var selectedCategory: TaskCategory?

    init() {
        self.tasks = WeddingChecklistData.allTasks
        self.assignments = AssignmentData.assignments
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

    func toggleAssigmentCompletion(at index: Int) {
        if let assignment = assignments.first(where: { $0.id == assignments[index].id }) {
            if let assignmentIndex = assignments.firstIndex(where: { $0.id == assignment.id }) {
                assignments[assignmentIndex].isCompleted.toggle()  // Переключаем статус выполнения
            }
        }
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
