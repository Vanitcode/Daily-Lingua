//
//  ArticleAudiosRecordRepository.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/7/25.
//

import Foundation

class ArticleAudiosRecordRepository: ArticleAudiosRecordRepositoryType {
    
    private let recordManagerDataSource: AVRecordManagerDataSourceType
    private let errorMapper: ArticleRecordsDomainMapperError
    private let articleRecordsDomainMapper: ArticleRecordsDomainMapper
    
    init(recordManagerDataSource: AVRecordManagerDataSourceType, errorMapper: ArticleRecordsDomainMapperError, articleRecordsDomainMapper: ArticleRecordsDomainMapper) {
        self.recordManagerDataSource = recordManagerDataSource
        self.errorMapper = errorMapper
        self.articleRecordsDomainMapper = articleRecordsDomainMapper
    }
    
    func startRecordingAnswer(for articleId: String, answerNumber: Int) async -> Result<Void, ArticleAudiosRecordDomainError> {
        let startRecordingResult = await recordManagerDataSource.startRecording()
    }
    
    func stopRecordingAnswer(for articleId: String, answerNumber: Int) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        <#code#>
    }
    
    func cancelRecording() async -> Result<Void, ArticleAudiosRecordDomainError> {
        <#code#>
    }
    
    func getAudiosRecord(for articleId: String) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        <#code#>
    }
    
    


}
