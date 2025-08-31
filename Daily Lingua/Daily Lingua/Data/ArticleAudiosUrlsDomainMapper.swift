//
//  ArticleAudiosUrlsDomainMapper.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

class ArticleAudiosUrlsDomainMapper {
    func map(dto: ArticleAudiosUrlsDTO) -> ArticleAudiosUrls {
        return ArticleAudiosUrls(id: dto.id, title_audio_url: dto.title_audio_url, article_audio_url: dto.article_audio_url, question1_audio_url: dto.question1_audio_url, question2_audio_url: dto.question2_audio_url, question3_audio_url: dto.question3_audio_url)
    }
}
