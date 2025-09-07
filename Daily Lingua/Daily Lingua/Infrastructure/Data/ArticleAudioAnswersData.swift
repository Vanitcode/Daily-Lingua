//
//  ArticleAudioAnswersData.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 5/9/25.
//

import Foundation
import SwiftData

@Model
class ArticleAudioAnswersData {
    @Attribute(.unique) var articleId: String
    var answer1: String?
    var answer2: String?
    var answer3: String?
    
    init(articleId: String, answer1: String? = nil, answer2: String? = nil, answer3: String? = nil) {
        self.articleId = articleId
        self.answer1 = answer1
        self.answer2 = answer2
        self.answer3 = answer3
    }
}
