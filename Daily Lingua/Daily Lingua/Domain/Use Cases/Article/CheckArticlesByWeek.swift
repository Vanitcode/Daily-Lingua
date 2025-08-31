//
//  CheckArticlesByWeek.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 27/6/25.
//

import Foundation

protocol CheckArticlesByWeekType{
    func execute(week: String) async -> Result<[Article],ArticleDomainError>
}

class CheckArticlesByWeek: CheckArticlesByWeekType {
    
    private let repository: ArticleRepositoryType
    
    init(repository: ArticleRepositoryType) {
        self.repository = repository
    }
    
    func execute(week: String) async -> Result<[Article], ArticleDomainError> {
        let result = await repository.checkArticlesByWeek(week: week)
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
