//
//  ArticleRecordsDomainMapperError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 2/9/25.
//

import Foundation

class ArticleRecordsDomainMapperError {
    func map(error: AVRecordManagerError) -> ArticleAudiosRecordDomainError {
        return .generic
    }
}
