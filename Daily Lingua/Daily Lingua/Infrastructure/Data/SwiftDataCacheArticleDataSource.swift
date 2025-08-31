//
//  SwiftDataCacheArticleDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/6/25.
//

import Foundation

class SwiftDataCacheArticleDataSource: CacheDataSourceType {
    
    private let container: SwiftDataContainerType
    
    init(container: SwiftDataContainerType) {
        self.container = container
    }
    
    @MainActor
    func getArticlesByWeek(week: String) async -> [Article] {
        let articleList = await container.fetchArticles(week: week)
        let articles = articleList.map {
            Article(id: $0.id, title: $0.title, text: $0.text,
                    question1: $0.question1, question2: $0.question2, question3: $0.question3)
        }
        return articles
        
    }
    
    func saveArticleList(_ articles: [Article], week: String) async {
        let articlesData = articles.map { ArticleData(id: $0.id, title: $0.title, text: $0.text, question1: $0.question1, question2: $0.question2, question3: $0.question3, week: week)}
        await container.deleteArticlesForWeek(for: week)
        await container.insert(articlesData, forWeek: week)
    }
    
}
