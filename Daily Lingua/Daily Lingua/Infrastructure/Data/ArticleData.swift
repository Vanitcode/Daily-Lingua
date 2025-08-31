//
//  ArticleData.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/6/25.
//

import Foundation
import SwiftData

@Model
class ArticleData {
    var id: String
    var title: String
    var text: String
    var question1: String
    var question2: String
    var question3: String
    var week: String
    
    init(id: String, title: String, text: String, question1: String, question2: String, question3: String, week: String) {
        self.id = id
        self.title = title
        self.text = text
        self.question1 = question1
        self.question2 = question2
        self.question3 = question3
        self.week = week
    }
}
