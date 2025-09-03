//
//  StartRecordingAnswer.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 3/9/25.
//

import Foundation

protocol StartRecordingAnswerType {
    func execute(articleId: String,answerNumber: Int) async ->
        Result<Void, ArticleAudiosRecordDomainError>
}

class StartRecordingAnswer: StartRecordingAnswerType {
    
    private let repository: ArticleAudiosRecordRepositoryType
    
    init(repository: ArticleAudiosRecordRepositoryType) {
        self.repository = repository
    }
    
    func execute(articleId: String, answerNumber: Int) async ->
    Result<Void, ArticleAudiosRecordDomainError> {
        let result = await repository.startRecordingAnswer(for: articleId, answerNumber: answerNumber)
        return parseResult(result)
    }
    
    private func parseResult(_ result: Result<Void, ArticleAudiosRecordDomainError>) -> Result<Void, ArticleAudiosRecordDomainError> {
        
        guard let startinResult = try? result.get() else {
            guard case .failure(let error) = result else {
                return .failure(.generic)
            }
            return .failure(error)
        }
        
        return .success(())
    }
}
