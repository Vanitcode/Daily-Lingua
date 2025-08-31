//
//  ArticleAudiosUrlsRepositoryType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

protocol ArticleAudiosUrlsRepositoryType {
    func getUrls(for articleId: String) async -> Result<ArticleAudiosUrls,ArticleAudiosUrlsDomainError>
}
