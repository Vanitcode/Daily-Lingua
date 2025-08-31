//
//  URLSessionResolver.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 10/6/25.
//

import Foundation

class URLSessionResolver {
    func resolve(statusCode: Int) -> HTTPClientError  {
       guard statusCode < 500 else {
           return .clientError
        }
        return .serverError
    }
    
    func resolve(error: Error) -> HTTPClientError {
        return .generic
    }
}
