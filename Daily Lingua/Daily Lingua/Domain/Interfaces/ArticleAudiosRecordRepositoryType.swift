//
//  ArticleAudiosRecordRepositoryType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

protocol ArticleAudiosRecordRepositoryType {
    func startRecordingAnswer(for articleId: String, answerNumber: Int) async -> Result<Void, ArticleAudiosRecordDomainError>

    func stopRecordingAnswer(for articleId: String, answerNumber: Int) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError>
    
    func cancelRecording() async -> Result<Void, ArticleAudiosRecordDomainError>
    
    func getAudiosRecord(for articleId: String) -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError>
}
