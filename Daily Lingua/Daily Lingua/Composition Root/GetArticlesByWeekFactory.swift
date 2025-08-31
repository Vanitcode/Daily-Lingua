//
//  GetArticleByDateFactory.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 10/6/25.
//

import Foundation

class GetArticlesByWeekFactory {
    static func create() -> ArticlesByWeekView {
        return ArticlesByWeekView(viewModel: createViewModel(), createPracticeSheetView: GetArticleAudiosUrlsFactory())
    }
    
    private static func createViewModel() ->  ArticlesByWeekViewModel {
        return ArticlesByWeekViewModel(fetchArticlesByWeek: createFetchArticlesUseCase(),checkArticlesByWeek: createCheckArticlesUseCase())
    }
    
    private static func createCheckArticlesUseCase() -> CheckArticlesByWeekType {
        return CheckArticlesByWeek(repository: createRepository())
    }
    
    private static func createFetchArticlesUseCase() -> FetchArticlesByWeekType {
        return FetchArticlesByWeek(repository: createRepository())
    }
    
    private static func createRepository() -> ArticleRepositoryType {
        return  ArticleRepository(apiDataSource: createAPIDataSourceArticle(),
                          errorMapper: ArticleDomainErrorMapper(),
                                  articleDomainMapper: ArticleDomainMapper(), cacheDataSource: createCacheDataSource(), metadataDataSource: createMetaDataDataSource())
    }
        
    private static func createCacheDataSource() -> CacheDataSourceType {
        return StrategyCacheArticle(temporalCache: InMemoryCacheArticleDataSource.shared, persistanceCache: createPersistanceCacheDataSource())
    }
    
    private static func createMetaDataDataSource() -> MetadataDataSourceType {
        return SwiftMetadataDataSource(container: SwiftDataContainer.shared)
    }
    
    private static func createPersistanceCacheDataSource() -> CacheDataSourceType {
        return SwiftDataCacheArticleDataSource(container: SwiftDataContainer.shared)
    }
    
    private static func createAPIDataSourceArticle() -> ApiDataSourceArticleType {
        let httpClient = URLSessionHTTPClient(urlResolver: URLSessionResolver())
        return APIArticleDataSource(httpClient: httpClient)
    }
}
