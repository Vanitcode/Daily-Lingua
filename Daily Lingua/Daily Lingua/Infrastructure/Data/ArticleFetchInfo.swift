//
//  ArticleFetchInfo.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 24/6/25.
//

import Foundation
import SwiftData

@Model
class ArticleFetchInfo {
    @Attribute(.unique) var week:String
    var lastFetch: Date
    
    init(week: String, lastFetch: Date) {
        self.week = week
        self.lastFetch = lastFetch
    }
}
