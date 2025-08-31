//
//  ArticleAudiosRecordDomainError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

enum ArticleAudiosRecordDomainError: Error {
    case generic
    
    var description: String {
        switch self {
        case .generic: return "ArticleAudiosRecordDomainError.generic"
        }
    }
}
