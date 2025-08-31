//
//  ArticleAudiosUrlsRepository.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

class ArticleAudiosUrlsRepository: ArticleAudiosUrlsRepositoryType {
    
    private let apiDataSource: ApiDataSourceArticleAudiosUrlsType
    private let errorMapper: ArticleAudiosUrlsDomainErrorMapper
    private let articleAudiosUrlsDomainMapper: ArticleAudiosUrlsDomainMapper
    
    init(apiDataSource: ApiDataSourceArticleAudiosUrlsType, errorMapper: ArticleAudiosUrlsDomainErrorMapper, articleAudiosUrlsDomainMapper: ArticleAudiosUrlsDomainMapper) {
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
        self.articleAudiosUrlsDomainMapper = articleAudiosUrlsDomainMapper
    }
    
    func getUrls(for articleId: String) async -> Result<ArticleAudiosUrls, ArticleAudiosUrlsDomainError> {
        
        let result = await apiDataSource.getArticleAudiosUrlsById(articleId: articleId)
        guard case .success(let articleAudiosUrlsDTO) = result else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(articleAudiosUrlsDomainMapper.map(dto: articleAudiosUrlsDTO))
    }
}
