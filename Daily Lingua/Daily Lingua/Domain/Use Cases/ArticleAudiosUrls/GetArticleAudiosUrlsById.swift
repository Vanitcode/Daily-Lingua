//
//  GetArticleAudiosUrlsById.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

protocol GetArticleAudiosUrlsByIdType{
    func execute(articleId: String) async -> Result<ArticleAudiosUrls,ArticleAudiosUrlsDomainError>
}


class GetArticleAudiosUrlsById: GetArticleAudiosUrlsByIdType {
    
    
    private let repository: ArticleAudiosUrlsRepositoryType
    
    init(repository: ArticleAudiosUrlsRepositoryType) {
        self.repository = repository
    }
    
    func execute(articleId: String) async -> Result<ArticleAudiosUrls, ArticleAudiosUrlsDomainError> {
        let result = await repository.getUrls(for: articleId)
        return parseResult(result)
    }
    
    private func parseResult(_ result: Result<ArticleAudiosUrls, ArticleAudiosUrlsDomainError>) -> Result<ArticleAudiosUrls, ArticleAudiosUrlsDomainError> {
        
        guard let article = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(article)
    }
}
