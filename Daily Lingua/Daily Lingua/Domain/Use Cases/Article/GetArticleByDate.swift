//
//  GetArticleByDate.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

protocol GetArticleByDateType {
    func execute(date: String) async -> Result<Article,ArticleDomainError>
}

class GetArticleByDate: GetArticleByDateType {
    
    private let repository: ArticleRepositoryType
    
    init(repository: ArticleRepositoryType) {
        self.repository = repository
    }
    
    func execute(date: String) async -> Result<Article,ArticleDomainError> {
        let result = await repository.getArticleByDate(date: date)
        
        guard let article = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(article)
    }
}
