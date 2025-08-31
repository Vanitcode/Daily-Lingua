//
//  ArticleAudiosRecordRepositoryType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

protocol ArticleAudiosRecordRepositoryType {
    func saveAudioRecordAnswer(for articleId: String, answer: Int) async -> Result<Void, ArticleAudiosRecordDomainError>
}
