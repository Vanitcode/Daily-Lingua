//
//  ArticleByDateRepositoryType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

protocol ArticleRepositoryType {
    func getArticleByDate(date: String) async -> Result<Article,ArticleDomainError>
    func getFreeArticleByWeek(week: String) async -> Result<Article,ArticleDomainError>
    func checkArticlesByWeek(week: String) async -> Result<[Article],ArticleDomainError>
    func fetchArticlesByWeek(week: String) async -> Result<[Article],ArticleDomainError>
}
