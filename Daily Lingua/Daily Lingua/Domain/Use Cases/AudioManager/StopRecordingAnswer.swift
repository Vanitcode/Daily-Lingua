//
//  StopRecordingAnswer.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 3/9/25.
//

import Foundation

protocol StopRecordingAnswerType {
    func execute(articleId:String, answerNumber:Int) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError>
}

class StopRecordingAnswer: StopRecordingAnswerType {
    
    private let repository: ArticleAudiosRecordRepositoryType
    
    init(repository: ArticleAudiosRecordRepositoryType) {
        self.repository = repository
    }
    
    func execute(articleId: String, answerNumber: Int) async -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        let result = await repository.stopRecordingAnswer(for: articleId, answerNumber: answerNumber)
        return parseResult(result)
    }
    
    private func parseResult(_ result: Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError>) -> Result<ArticleAudiosRecord, ArticleAudiosRecordDomainError> {
        
        guard let articleAudioRecord = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        return .success(articleAudioRecord)
    }

}
