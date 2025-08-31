//
//  StrategyCacheArticle.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/6/25.
//

import Foundation

class StrategyCacheArticle: CacheDataSourceType {
    
    private let temporalCache: CacheDataSourceType
    private let persistanceCache: CacheDataSourceType
    
    init(temporalCache: CacheDataSourceType, persistanceCache: CacheDataSourceType) {
        self.temporalCache = temporalCache
        self.persistanceCache = persistanceCache
    }
    
    func getArticlesByWeek(week: String) async -> [Article] {
        let temporalArticleList = await temporalCache.getArticlesByWeek(week: week)
        if !temporalArticleList.isEmpty {
            return temporalArticleList
        } else {
            let persistanceArticleList = await persistanceCache.getArticlesByWeek(week: week)
            await temporalCache.saveArticleList(persistanceArticleList, week: week)
            return persistanceArticleList
        }
    }
    
    func saveArticleList(_ articles: [Article], week: String) async {
        await temporalCache.saveArticleList(articles, week: week)
        await persistanceCache.saveArticleList(articles, week: week)
    }
    
}
