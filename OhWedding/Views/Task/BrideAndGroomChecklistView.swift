//
//  BrideAndGroomChecklistView.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 13.04.2025.
//

import SwiftUI

struct BrideAndGroomChecklistView: View {
    var body: some View {
        List {
            // Секция "Общее" – берем общие задачи из WeddingChecklistData
            Section(header: Text("Общее")
                        .font(.headline)
                        .foregroundColor(.indigo)) {
                ForEach(WeddingChecklistData.commonTasks) { task in
                    Label(task.title, systemImage: "gift.fill")
                }
            }

            // Секция "Невеста" – берем задачи для невесты
            Section(header: Text("Невеста")
                        .font(.headline)
                        .foregroundColor(.pink)) {
                ForEach(WeddingChecklistData.brideTasks) { task in
                    Label(task.title, systemImage: "heart.fill")
                        .foregroundColor(.pink)
                }
            }

            // Секция "Жених" – берем задачи для жениха
            Section(header: Text("Жених")
                        .font(.headline)
                        .foregroundColor(.blue)) {
                ForEach(WeddingChecklistData.groomTasks) { task in
                    Label(task.title, systemImage: "suit.heart.fill")
                        .foregroundColor(.blue)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Чек-лист жених и невеста")
    }
}

#Preview {
    NavigationView {
        BrideAndGroomChecklistView()
    }
}
