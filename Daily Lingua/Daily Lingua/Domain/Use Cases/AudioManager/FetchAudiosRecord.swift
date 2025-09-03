//
//  FetchAudiosRecord.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 3/9/25.
//

import Foundation

protocol FetchAudiosRecordType {
    func execute(for articleId: String) -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError>
}

class FetchAudiosRecord: FetchAudiosRecordType {
    
    private let repository: ArticleAudiosRecordRepositoryType
    
    init(repository: ArticleAudiosRecordRepositoryType) {
        self.repository = repository
    }
    
    func execute(for articleId: String) -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        let result = repository.getAudiosRecord(for: articleId)
        return parseResult(result)
    }
    
    private func parseResult(_ result: Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError>) -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        
        guard let articleAudioRecord = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(articleAudioRecord)
    }
}
