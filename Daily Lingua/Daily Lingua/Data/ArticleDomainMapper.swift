//
//  ArticleDomainMapper.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

class ArticleDomainMapper {
    func map(dto: ArticleDTO) -> Article {
        return Article(id: dto.id, title: dto.title, text: dto.article, question1: dto.question1, question2: dto.question2, question3: dto.question3)
    }
}
