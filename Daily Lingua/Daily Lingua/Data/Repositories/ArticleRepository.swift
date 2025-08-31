//
//  ArticleRepository.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//
// Orquestador de hacer llamadas, obtener datos y unificarlos

import Foundation

class ArticleRepository: ArticleRepositoryType {
    private let apiDataSource: ApiDataSourceArticleType
    private let errorMapper: ArticleDomainErrorMapper
    private let articleDomainMapper: ArticleDomainMapper
    private let cacheDataSource: CacheDataSourceType
    private let metadataDataSource: MetadataDataSourceType
    
    init(apiDataSource: ApiDataSourceArticleType, errorMapper: ArticleDomainErrorMapper, articleDomainMapper: ArticleDomainMapper, cacheDataSource: CacheDataSourceType, metadataDataSource: MetadataDataSourceType) {
        self.apiDataSource = apiDataSource
        self.errorMapper = errorMapper
        self.articleDomainMapper = articleDomainMapper
        self.cacheDataSource = cacheDataSource
        self.metadataDataSource = metadataDataSource
    }
    
    func getArticleByDate(date: String) async -> Result<Article, ArticleDomainError> {
        
        let articleResult = await apiDataSource.getArticleByDate(date: date)
        
        guard case .success(let article) = articleResult else {
            guard case .failure(let error) = articleResult else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(articleDomainMapper.map(dto: article))

    }
    
    func getFreeArticleByWeek(week: String) async -> Result<Article, ArticleDomainError> {
        
        let articleResult = await apiDataSource.getFreeArticleByWeek(week: week)
        
        guard case .success(let article) = articleResult else {
            guard case .failure(let error) = articleResult else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(articleDomainMapper.map(dto: article))
    }
    
    func fetchArticlesByWeek(week: String) async -> Result<[Article],ArticleDomainError> {
        let result = await apiDataSource.getArticlesByWeek(week: week)
        
        //saving the fetch day
        await metadataDataSource.updateLastFetchDate(for: week)
        
        switch result {
        case .success(let dtoList):
            let articles = dtoList.map { articleDomainMapper.map(dto: $0) }
            await cacheDataSource.saveArticleList(articles, week: week)
            return .success(articles)
        case .failure(let error):
            return .failure(errorMapper.map(error: error))
        }
    }
    
    func checkArticlesByWeek(week: String) async -> Result<[Article], ArticleDomainError> {
        let lastFetchDate = await metadataDataSource.getLastFetchDate(for: week)
        let shouldFetch = shouldFetchFromAPI(lastFetchDate: lastFetchDate)

        if !shouldFetch {
            let articleListCache = await cacheDataSource.getArticlesByWeek(week: week)
            if !articleListCache.isEmpty {
                return .success(articleListCache)
            }
        }
        return await fetchArticlesByWeek(week: week)
    }
    
    private func shouldFetchFromAPI(lastFetchDate: Date?) -> Bool {
        guard let last = lastFetchDate else {
            return true }
        let isSameDay = last.isSameDay(as: Date())
        return !isSameDay
    }
}
