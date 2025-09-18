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
    private let cacheAudiosDataSource: CacheAudiosDataSourceType
    
    init(recordManagerDataSource: AVRecordManagerDataSourceType, errorMapper: ArticleRecordsDomainMapperError, cacheAudiosDataSource: CacheAudiosDataSourceType) {
        self.recordManagerDataSource = recordManagerDataSource
        self.errorMapper = errorMapper
        self.cacheAudiosDataSource = cacheAudiosDataSource
    }
    
    func startRecordingAnswer(for articleId: String, answerNumber: Int) async -> Result<Void, ArticleAudiosRecordDomainError> {
        
        let startRecordingResult = await recordManagerDataSource.startRecording()
        guard case .success() = startRecordingResult else {
            guard case .failure(let error) = startRecordingResult else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(())
    }
    
    func stopRecordingAnswer(for articleId: String, answerNumber: Int) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        let stopRecordingResult = await recordManagerDataSource.stopRecording()
        guard case .success(let url) = stopRecordingResult else {
            guard case .failure(let error) = stopRecordingResult else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        var record = await cacheAudiosDataSource.getRecords(for: articleId)
        if record == nil {
            record = ArticleAudiosRecord(articleId: articleId, answer1_path: nil, answer2_path: nil, answer3_path: nil)
        }
        switch answerNumber {
        case 0: record = ArticleAudiosRecord(articleId: articleId, answer1_path: url, answer2_path: record?.answer2_path, answer3_path: record?.answer3_path)
        case 1: record = ArticleAudiosRecord(articleId: articleId, answer1_path: record?.answer1_path, answer2_path: url, answer3_path: record?.answer3_path)
        case 2: record = ArticleAudiosRecord(articleId: articleId, answer1_path: record?.answer1_path, answer2_path: record?.answer2_path, answer3_path: url)
            default: break
        }
        await cacheAudiosDataSource.saveRecords(record!, for: articleId)
        return .success(record!)
    }
    
    func cancelRecording() async -> Result<Void, ArticleAudiosRecordDomainError> {
        let cancelRecordingResult = await recordManagerDataSource.cancelRecording()
        guard case .success = cancelRecordingResult else {
            guard case .failure(let error) = cancelRecordingResult else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: error))
        }
        return .success(())
    }
    
    func getAudiosRecord(for articleId: String) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        guard let audioRecordResult = await cacheAudiosDataSource.getRecords(for: articleId) else {
            return .failure(.gettingEntityFailed)
        }
            return .success(audioRecordResult)
    }
}
