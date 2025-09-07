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

extension SwiftDataContainer: SwiftDataAudiosContainerType {
    
    @MainActor
    func fetchArticleAudios(for articleId: String) async -> ArticleAudioAnswersData? {
        let predicate = #Predicate<ArticleAudioAnswersData> { $0.articleId == articleId }
        let descriptor = FetchDescriptor<ArticleAudioAnswersData>(predicate: predicate)
        
        guard let articleAudios = try? context.fetch(descriptor).first else {
            return nil
        }
        return articleAudios
    }
    
    @MainActor
    func insert(_ articleAudioAnswers: ArticleAudioAnswersData, articleId: String) async {
        
        let existingArticleAudioAnswer = await fetchArticleAudios(for: articleId)
        
        if existingArticleAudioAnswer != nil {
            // Updating the fields
            existingArticleAudioAnswer!.answer1 = articleAudioAnswers.answer1
            existingArticleAudioAnswer!.answer2 = articleAudioAnswers.answer2
            existingArticleAudioAnswer!.answer3 = articleAudioAnswers.answer3
            try? context.save()
        } else {
            //Creating the new ArticleAudioAnswer
            context.insert(articleAudioAnswers)
                    try? context.save()
        }
    }
    
    func deleteAudioAnswers(for articleId: String) async {
        guard let existingArticleAudioAnswer = await fetchArticleAudios(for: articleId) else {
            return
        }
        context.delete(existingArticleAudioAnswer)
        try? context.save()
    }
    
    
}
