//
//  ArticleDomainError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

enum ArticleDomainError: Error {
    case generic
    
    var description: String {
        switch self {
        case .generic: return "ArticleDomainError.generic"
        }
    }

}
