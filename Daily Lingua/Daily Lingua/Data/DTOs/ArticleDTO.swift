//
//  ArticleDTO.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

struct ArticleDTO: Codable {
    let id: String
    let article: String
    let article_audio_url: String
    let date: String
    let isFree: Bool
    let question1: String
    let question1_audio_url: String
    let question2: String
    let question2_audio_url: String
    let question3: String
    let question3_audio_url: String
    let title: String
    let title_audio_url: String
    let topics: String
    let weekId: String
    
    enum CodingKeys: String, CodingKey {
        case id, article, article_audio_url, date, isFree, question1, question1_audio_url, question2, question2_audio_url, question3, question3_audio_url, title, title_audio_url, topics, weekId
    }
}
