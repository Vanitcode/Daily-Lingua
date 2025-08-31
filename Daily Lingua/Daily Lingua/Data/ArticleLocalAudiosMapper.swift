//
//  ArticleLocalAudiosMapper.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

class ArticleLocalAudiosMapper {
    func map(from dto: ArticleAudiosUrlsDTO, with localURLs: [String: URL]) -> ArticleLocalAudios {
        
        return ArticleLocalAudios(
            articleId: dto.id,
            title_path: localURLs[dto.title_audio_url]!,
            article_path: localURLs[dto.article_audio_url]!,
            question1_path: localURLs[dto.question1_audio_url]!,
            question2_path: localURLs[dto.question2_audio_url]!,
            question3_path: localURLs[dto.question3_audio_url]!
        )
    }
}
