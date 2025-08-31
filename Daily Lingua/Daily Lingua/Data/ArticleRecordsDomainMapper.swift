//
//  ArticleRecordsDomainMapper.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 4/8/25.
//

import Foundation

class ArticleRecordsDomainMapper {
    func map(dto: ArticleAudiosRecordDTO) -> ArticleAudiosRecord {
        return ArticleAudiosRecord(articleId: dto.articleId, answer1_path: dto.answer1_path, answer2_path: dto.answer2_path, answer3_path: dto.answer3_path)
    }
}
