//
//  Extensions.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 24/6/25.
//

import Foundation

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }
}
