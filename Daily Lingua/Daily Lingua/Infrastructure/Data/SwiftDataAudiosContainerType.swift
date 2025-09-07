//
//  SwiftDataAudiosContainerType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 5/9/25.
//

import Foundation

protocol SwiftDataAudiosContainerType {
    @MainActor func fetchArticleAudios(for articleId: String) async -> ArticleAudioAnswersData?
    @MainActor func insert(_ articleAudioAnswers: ArticleAudioAnswersData, articleId: String) async
    @MainActor func deleteAudioAnswers(for articleId: String) async
}
