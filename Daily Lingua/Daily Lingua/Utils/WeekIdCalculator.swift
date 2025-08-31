//
//  WeekIdCalculator.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import Foundation

struct WeekIdCalculator {
    static func currentWeekId(from date: Date = Date()) -> String {
        let calendar = Calendar(identifier: .iso8601)
        let year = calendar.component(.yearForWeekOfYear, from: date)
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return String(format: "%d-W%02d", year, weekOfYear)
    }
}
