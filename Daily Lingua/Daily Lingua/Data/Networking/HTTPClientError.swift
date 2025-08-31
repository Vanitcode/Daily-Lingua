//
//  HTTPClientError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

enum HTTPClientError: Error {
    case clientError
    case serverError
    case generic
    case parsingError
    case badURL
    case responseError
    
    var description: String {
        switch self {
        case .clientError: return "HTTPClientError.clientError"
        case .serverError: return "HTTPClientError.serverError"
        case .generic: return "HTTPClientError.generic"
        case .parsingError: return "HTTPClientError.parsingError"
        case .badURL: return "HTTPClientError.badURL"
        case .responseError: return "HTTPClientError.responseError"
        }
    }

}
