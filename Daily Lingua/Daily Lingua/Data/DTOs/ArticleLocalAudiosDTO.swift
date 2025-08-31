//
//  ArticleLocalAudiosDTO.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

struct ArticleLocalAudiosDTO: Codable {
    let articleId: String
    let title_path: URL
    let article_path: URL
    let question1_path: URL
    let question2_path: URL
    let question3_path: URL
}
