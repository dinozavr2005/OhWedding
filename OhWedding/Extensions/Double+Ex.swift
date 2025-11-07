//
//  Double+Ex.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 26.10.2025.
//

import Foundation

extension Double {
    /// Форматирует число с автоматическими разделителями тысяч и знаком ₽
    var formattedCurrency: String {
        self.formatted(
            .currency(code: "RUB")
                .locale(Locale(identifier: "ru_RU"))
                .precision(.fractionLength(0))
        )
    }

    /// Просто число с пробелами (без знака ₽)
    var formattedNumber: String {
        self.formatted(.number.grouping(.automatic))
    }
}
