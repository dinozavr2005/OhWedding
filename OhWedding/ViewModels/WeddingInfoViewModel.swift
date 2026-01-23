//
//  WeddingInfoViewModel.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 19.10.2025.
//

import Foundation
import SwiftData

@MainActor
final class WeddingInfoViewModel: ObservableObject {
    @Published var info: WeddingInfo?

    init() {}

    // MARK: - Загрузка
    func loadInfo(using context: ModelContext) {
        if let existing = try? context.fetch(FetchDescriptor<WeddingInfo>()).first {
            self.info = existing
        } else {
            let new = WeddingInfo()
            context.insert(new)
            try? context.save()
            self.info = new
        }
    }

    // MARK: - Обновления
    func update(using context: ModelContext,
                groom: String,
                bride: String,
                date: Date) {
        guard let info else { return }
        info.groomName = groom
        info.brideName = bride
        info.weddingDate = date
        save(context)
        objectWillChange.send()
    }

    private func save(_ context: ModelContext) {
        try? context.save()
    }
}

extension WeddingInfoViewModel {
    var daysUntilWedding: Int? {
        guard let info, let date = info.weddingDate else { return nil }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let weddingDay = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: today, to: weddingDay).day
    }

    var weddingTitle: String {
        guard let info = info else { return "Жених & Невеста" }
        if !info.groomName.isEmpty && !info.brideName.isEmpty {
            return "\(info.groomName) & \(info.brideName)"
        } else {
            return "Жених & Невеста"
        }
    }
}
