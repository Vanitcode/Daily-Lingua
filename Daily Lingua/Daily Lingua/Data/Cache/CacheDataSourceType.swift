//
//  CacheDataSourceType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 19/6/25.
//

import Foundation

protocol CacheDataSourceType {
    func getArticlesByWeek(week: String) async -> [Article]
    func saveArticleList(_ articles: [Article], week: String) async
}
