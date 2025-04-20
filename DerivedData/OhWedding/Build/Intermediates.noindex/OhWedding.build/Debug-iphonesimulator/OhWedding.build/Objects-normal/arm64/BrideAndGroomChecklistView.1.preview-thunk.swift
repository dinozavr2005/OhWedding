import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/vladimir/Documents/Programing/OhWedding/OhWedding/OhWedding/Views/Task/BrideAndGroomChecklistView.swift", line: 1)
//
//  BrideAndGroomChecklistView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct BrideAndGroomChecklistView: View {
    // Пример статических списков:
    // (реальные данные можно тянуть из ViewModel или из JSON)
    private let brideTasks = [
        "Платье",
        "Второе платье (по желанию)",
        "Фата",
        "Завок",
        "Бельё",
        "Утренний образ",
        "Обувь"
        // Добавьте остальные пункты...
    ]

    private let groomTasks = [
        "Костюм",
        "Рубашка",
        "Запасная рубашка (на случай)",
        "Обувь",
        "Галстук/бабочка/платок",
        "Ремень",
        "Носки"
        // Добавьте остальные пункты...
    ]

    var body: some View {
        List {
            Section(header: Text(__designTimeString("#14936_0", fallback: "Невеста"))) {
                ForEach(brideTasks, id: \.self) { task in
                    Label(task, systemImage: __designTimeString("#14936_1", fallback: "heart")) // или просто Text(task)
                }
            }

            Section(header: Text(__designTimeString("#14936_2", fallback: "Жених"))) {
                ForEach(groomTasks, id: \.self) { task in
                    Label(task, systemImage: __designTimeString("#14936_3", fallback: "suitcase")) // или просто Text(task)
                }
            }
        }
        .navigationTitle(__designTimeString("#14936_4", fallback: "Чек-лист жених и невеста"))
    }
}

#Preview {
    NavigationView {
        BrideAndGroomChecklistView()
    }
}
