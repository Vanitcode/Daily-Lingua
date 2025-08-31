//
//  GetArticlesByWeek.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import Foundation

protocol FetchArticlesByWeekType{
    func execute(week: String) async -> Result<[Article],ArticleDomainError>
}

class FetchArticlesByWeek: FetchArticlesByWeekType {
    
    private let repository: ArticleRepositoryType
    
    init(repository: ArticleRepositoryType) {
        self.repository = repository
    }
    
    func execute(week: String) async -> Result<[Article], ArticleDomainError> {
        let result = await repository.fetchArticlesByWeek(week: week)
        return parseResult(result)
    }
    
    private func parseResult(_ result: Result<[Article], ArticleDomainError>) -> Result<[Article], ArticleDomainError> {
        
        guard let articles = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(articles)
    }
}
