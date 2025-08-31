//
//  ArticleDomainErrorMapper.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

class ArticleDomainErrorMapper {
    func map(error: HTTPClientError?) -> ArticleDomainError {
        return .generic
    }
}
