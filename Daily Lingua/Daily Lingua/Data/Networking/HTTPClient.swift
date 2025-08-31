//
//  HTTPClient.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 6/6/25.
//

import Foundation

protocol HTTPClient {
    func makeRequest(endpoint: String) async -> Result<Data, HTTPClientError>
}
