//
//  ArticleAudiosRecordDTO.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/8/25.
//

import Foundation
struct ArticleAudiosRecordDTO {
    let articleId: String
    let answer1_path: URL?
    let answer2_path: URL?
    let answer3_path: URL?
    
    var isComplete: Bool {
        answer1_path != nil && answer2_path != nil && answer3_path != nil
    }
}
