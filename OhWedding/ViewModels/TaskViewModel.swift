import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [WeddingTask] = []
    @Published var selectedCategory: TaskCategory?

    init() {
        // Загружаем из модели все задачи.
        self.tasks = WeddingChecklistData.allTasks
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

    // Добавляем вычисляемые свойства для каждой категории

    // Рекомендации
    var recommendationsCompleted: Int {
        tasks.filter { $0.category == .recommendations && $0.isCompleted }.count
    }

    var recommendationsTotal: Int {
        tasks.filter { $0.category == .recommendations }.count
    }

    // Чек-лист жених и невеста
    var coupleChecklistCompleted: Int {
        tasks.filter { $0.category == .coupleChecklist && $0.isCompleted }.count
    }

    var coupleChecklistTotal: Int {
        tasks.filter { $0.category == .coupleChecklist }.count
    }

    // Задание для невесты
    var brideTasksCompleted: Int {
        tasks.filter { $0.category == .brideTasks && $0.isCompleted }.count
    }

    var brideTasksTotal: Int {
        tasks.filter { $0.category == .brideTasks }.count
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
