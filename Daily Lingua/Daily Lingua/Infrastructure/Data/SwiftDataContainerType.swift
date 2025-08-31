//
//  SwiftDataContainerType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/6/25.
//

import Foundation

protocol SwiftDataContainerType {
    @MainActor func fetchArticles(week: String) async -> [ArticleData]
    @MainActor func insert(_ articleList: [ArticleData], forWeek: String) async
    @MainActor func deleteArticlesForWeek(for week: String) async
}
