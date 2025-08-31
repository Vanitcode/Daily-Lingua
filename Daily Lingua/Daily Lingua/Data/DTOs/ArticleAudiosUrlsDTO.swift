//
//  ArticleAudiosUrlsDTO.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

struct ArticleAudiosUrlsDTO: Codable {
    let id: String
    let article_audio_url: String
    let question1_audio_url: String
    let question2_audio_url: String
    let question3_audio_url: String
    let title_audio_url: String
    
    enum CodingKeys: String, CodingKey {
        case id, article_audio_url, question1_audio_url, question2_audio_url, question3_audio_url, title_audio_url
    }
}
