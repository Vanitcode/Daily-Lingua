//
//  ArticleAudiosUrlsDomainErrorMapper.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

class ArticleAudiosUrlsDomainErrorMapper {
    func map(error: HTTPClientError?) -> ArticleAudiosUrlsDomainError {
        return .generic
    }
}
