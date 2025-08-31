//
//  InMemoryCacheArticleDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 19/6/25.
//

import Foundation
 //It must be a singleton. Just one cache on memory
actor InMemoryCacheArticleDataSource: CacheDataSourceType {
    
    static let shared: InMemoryCacheArticleDataSource = InMemoryCacheArticleDataSource()
    
    private var cache: [String :[Article]] = [:]
    
    private init() {}
     
    func getArticlesByWeek(week: String) async -> [Article] {
        return cache[week] ?? []
    }
    
    func saveArticleList(_ articles: [Article], week: String) async {
        self.cache.removeAll()
        self.cache[week] = articles
    }
}
