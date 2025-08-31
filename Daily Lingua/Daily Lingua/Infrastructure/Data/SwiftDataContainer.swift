//
//  SwiftDataContainer.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/6/25.
//

import Foundation
import SwiftData

class SwiftDataContainer {
    
    //Singleton
    static let shared = SwiftDataContainer()
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        let schema = Schema([ArticleData.self, ArticleFetchInfo.self])
        container = try! ModelContainer(for:schema, configurations: [])
        context = ModelContext(container)
    }
}

extension SwiftDataContainer: SwiftDataContainerType {
    
    @MainActor
    func fetchArticles(week: String) async -> [ArticleData] {
        let predicate = #Predicate<ArticleData> { $0.week == week }
        let descriptor = FetchDescriptor<ArticleData>(predicate: predicate)
        
        guard let articles = try? context.fetch(descriptor) else {
            return []
        }
        
        return articles
    }
    
    @MainActor
    func insert(_ articleList: [ArticleData], forWeek week: String) async {
        
        let existingArticles = await fetchArticles(week: week)
        
        if !existingArticles.isEmpty {
            return
        }
        
        articleList.forEach { article in
            context.insert(article)
        }
        try? context.save()
    }
    
    @MainActor
    func deleteArticlesForWeek(for week: String) async {
        let existingArticles = await fetchArticles(week: week)
        
        if existingArticles.isEmpty {
            return
        }
        existingArticles.forEach {
            context.delete($0)
        }
        try? context.save()
    }
}

extension SwiftDataContainer: SwiftDataMetadataContainerType {
    
    @MainActor
    func getLastFetchDate(for week: String) async -> Date? {
        let predicate = #Predicate<ArticleFetchInfo> { $0.week == week }
        let descriptor = FetchDescriptor<ArticleFetchInfo>(predicate: predicate)
        
        await updateLastFetchDate(for: week)
        
        guard let lastFetch = try? context.fetch(descriptor).first?.lastFetch else {
            return nil
        }
        return lastFetch
        
    }
    
    @MainActor
    func updateLastFetchDate(for week: String) async {
        let descriptor = FetchDescriptor<ArticleFetchInfo>(
            predicate: #Predicate { $0.week == week }
        )
        
        if let existing = try? context.fetch(descriptor).first {
            existing.lastFetch = Date()
        } else {
            let info = ArticleFetchInfo(week: week, lastFetch: Date())
            context.insert(info)
        }
        
        try? context.save()
    }
}


