//
//  URLSessionHTTPClient.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    private let urlResolver: URLSessionResolver
    
    init(session: URLSession = .shared, urlResolver: URLSessionResolver) {
        self.session = session
        self.urlResolver = urlResolver
    }
    
    func makeRequest(endpoint: String) async -> Result<Data, HTTPClientError> {
        guard let url = URL(string: endpoint) else {
                    return .failure(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let result = try await session.data(from: url)
            
            guard let response = result.1 as? HTTPURLResponse else {
                return .failure(.responseError)
            }
            
            guard response.statusCode == 200 else {
                return .failure(urlResolver.resolve(statusCode: response.statusCode))
            }
            return .success(result.0)
            
        } catch {
            return .failure(urlResolver.resolve(error: error))
        }
    }
    
}
