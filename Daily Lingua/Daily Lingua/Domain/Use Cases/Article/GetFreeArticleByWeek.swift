//
//  GetFreeArticlebyWeek.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import Foundation

protocol GetFreeArticleByWeekType {
    func execute(week: String) async -> Result <Article, ArticleDomainError>
}

class GetFreeArticleByWeek: GetFreeArticleByWeekType {
    
    private let repository: ArticleRepositoryType
    
    init(repository: ArticleRepositoryType) {
        self.repository = repository
    }
    
    func execute(week: String) async -> Result<Article, ArticleDomainError> {
        let result = await repository.getFreeArticleByWeek(week: week)
        
        guard let article = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(article)
    }
}
