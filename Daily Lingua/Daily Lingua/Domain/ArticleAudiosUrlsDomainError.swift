//
//  ArticleAudiosUrlsDomainError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

enum ArticleAudiosUrlsDomainError: Error {
    case generic
    
    var description: String {
        switch self {
        case .generic: return "ArticleAudiosUrlsDomainError.generic"
        }
    }

}
