//
//  StrategyCacheAudios.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 5/9/25.
//

import Foundation

class StrategyCacheAudios: CacheAudiosDataSourceType {

    private let temporalCache: CacheAudiosDataSourceType
    private let persistentCache: CacheAudiosDataSourceType
    
    init(temporalCache: CacheAudiosDataSourceType, persistentCache: CacheAudiosDataSourceType) {
        self.temporalCache = temporalCache
        self.persistentCache = persistentCache
    }
    
    func getRecords(for articleId: String) async -> ArticleAudiosRecord? {
        if let temporalArticleRecords = await temporalCache.getRecords(for: articleId) {
            return temporalArticleRecords
        }
        guard let persistentArticleRecords = await persistentCache.getRecords(for: articleId) else {
            return nil
        }
        await temporalCache.saveRecords(persistentArticleRecords, for: articleId)
        
        return persistentArticleRecords
    }
    
    func saveRecords(_ record: ArticleAudiosRecord, for articleId: String) async {
        await temporalCache.saveRecords(record, for: articleId)
        await persistentCache.saveRecords(record, for: articleId)
    }
    
    func deleteRecord(for articleId: String) async {
        await temporalCache.deleteRecord(for: articleId)
        await persistentCache.deleteRecord(for: articleId)
    }
}
