//
//  GetArticleLocalAudiosByI.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 30/6/25.
//

import Foundation

protocol GetArticleLocalAudiosByIdType {
    func execute(articleId: String) async -> Result<ArticleLocalAudios, ArticleLocalAudiosDomainError>
}

class GetArticleLocalAudiosById: GetArticleLocalAudiosByIdType {
    
    private let repository: ArticleLocalAudiosRepositoryType
    
    init(repository: ArticleLocalAudiosRepositoryType) {
        self.repository = repository
    }
    
    func execute(articleId: String) async -> Result<ArticleLocalAudios, ArticleLocalAudiosDomainError> {
        let result = await repository.getLocalAudios(for: articleId)
        return parseResult(result)
    }
    
    private func parseResult(_ result: Result<ArticleLocalAudios, ArticleLocalAudiosDomainError>) -> Result<ArticleLocalAudios, ArticleLocalAudiosDomainError> {
        
        guard let article = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(article)
    }
}
