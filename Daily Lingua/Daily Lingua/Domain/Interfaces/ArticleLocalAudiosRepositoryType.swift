//
//  ArticleLocalAudiosRepositoryType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 30/6/25.
//

import Foundation

protocol ArticleLocalAudiosRepositoryType {
    func getLocalAudios(for articleId: String) async -> Result<ArticleLocalAudios, ArticleLocalAudiosDomainError>
}
