//
//  ArticleLocalAudiosDomainError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 30/6/25.
//

import Foundation

enum ArticleLocalAudiosDomainError: Error {
    case generic
    case remoteError
    case localError
    var description: String {
        switch self {
        case .generic: return "ArticleLocalAudiosDomainError.generic"
        case .remoteError: return "ArticleLocalAudiosDomainError.remoteError"
        case .localError: return "ArticleLocalAudiosDomainError.localError"
        }
    }
}
