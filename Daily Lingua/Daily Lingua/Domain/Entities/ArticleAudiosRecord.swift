//
//  ArticleAudiosRecord.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

struct ArticleAudiosRecord {
    let articleId: String
    let answer1_path: URL?
    let answer2_path: URL?
    let answer3_path: URL?
}

extension ArticleAudiosRecord {
    func answerURL(for questionIndex: Int) -> URL? {
        switch questionIndex {
        case 0: return answer1_path
        case 1: return answer2_path
        case 2: return answer3_path
        default: return nil
        }
    }
}
