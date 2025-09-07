//
//  SwiftDataCacheArticleAudiosDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/9/25.
//

import Foundation

class SwiftDataCacheArticleAudiosDataSource: CacheAudiosDataSourceType {
    
    private let container: SwiftDataAudiosContainerType
    
    init(container: SwiftDataAudiosContainerType) {
        self.container = container
    }
    
    @MainActor
    func getRecords(for articleId: String) async -> ArticleAudiosRecord? {
        let articleAudioRecords = await container.fetchArticleAudios(for: articleId)
        guard let articleRecords = await container.fetchArticleAudios(for: articleId) else {
            return nil
        }
        return ArticleAudiosRecord(
            articleId: articleRecords.articleId,
            answer1_path: stringToFileURL(articleRecords.answer1),
            answer2_path: stringToFileURL(articleRecords.answer2),
            answer3_path: stringToFileURL(articleRecords.answer3)
        )
    }
    private func stringToFileURL(_ path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(fileURLWithPath: path)
    }
    
    @MainActor
    func saveRecords(_ record: ArticleAudiosRecord, for articleId: String) async {
        let  articleAudioAnswersData =  ArticleAudioAnswersData(
            articleId: articleId,
            answer1: record.answer1_path?.absoluteString,
            answer2: record.answer2_path?.absoluteString,
            answer3: record.answer3_path?.absoluteString,
        )
        await container.deleteAudioAnswers(for: articleId)
        await container.insert(articleAudioAnswersData, articleId: articleId)
    }
    
    @MainActor
    func deleteRecord(for articleId: String) async {
        await container.deleteAudioAnswers(for: articleId)
    }
    
    
    
}
