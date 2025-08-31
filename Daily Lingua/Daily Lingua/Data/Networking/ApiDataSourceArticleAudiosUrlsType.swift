//
//  ApiDataSourceArticleAudiosUrlsType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

protocol ApiDataSourceArticleAudiosUrlsType {
    func getArticleAudiosUrlsById(articleId: String) async -> Result<ArticleAudiosUrlsDTO, HTTPClientError>
}
