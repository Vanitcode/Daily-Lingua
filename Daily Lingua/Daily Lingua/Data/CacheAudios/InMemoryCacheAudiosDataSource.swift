//
//  InMemoryCacheAudiosDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 5/9/25.
//

import Foundation

//It must be a singleton. Just one cache on memory
actor InMemoryCacheAudiosDataSource: CacheAudiosDataSourceType {
  
    static let shared: InMemoryCacheAudiosDataSource = InMemoryCacheAudiosDataSource()
    
    private var cache: [String: ArticleAudiosRecord] = [:]
    
    private init() {}
    
    func getRecords(for articleId: String) async -> ArticleAudiosRecord? {
        return cache[articleId]
    }
    
    func saveRecords( _ articleRecords: ArticleAudiosRecord, for articleId: String) async {
        cache[articleId] = articleRecords
    }
    
    func deleteRecord(for articleId: String) async {
        cache.removeValue(forKey: articleId)
    }
}
