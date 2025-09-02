//
//  ArticleAudiosRecordDomainError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

enum ArticleAudiosRecordDomainError: Error {
    case generic
    case startRecordingFailed
    case stopRecordingFailed
    case cancelRecordingFailed
    case gettingEntityFailed
    
    var description: String {
        switch self {
        case .generic:
            return "ArticleAudiosRecordDomainError.generic"
        case .startRecordingFailed:
            return "ArticleAudiosRecordDomainError.startRecordingFailed"
        case .stopRecordingFailed:
            return "ArticleAudiosRecordDomainError.stopRecordingFailed"
        case .cancelRecordingFailed:
            return "ArticleAudiosRecordDomainError.cancelRecordingFailed"
        case .gettingEntityFailed:
            return "ArticleAudiosRecordDomainError.gettingEntityFailed"
        }
    }
}
