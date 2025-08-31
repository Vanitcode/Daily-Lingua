//
//  ApiDataSourceArticleType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

protocol ApiDataSourceArticleType {
    func getArticleByDate(date: String) async -> Result<ArticleDTO, HTTPClientError>
    func getFreeArticleByWeek(week: String) async -> Result<ArticleDTO, HTTPClientError>
    func getArticlesByWeek(week: String) async -> Result<[ArticleDTO], HTTPClientError>
}
