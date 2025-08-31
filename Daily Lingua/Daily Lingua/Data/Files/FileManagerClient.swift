//
//  FileManagerClient.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

protocol FileManagerClient {
    func makeRequest(for url: String) async -> Result<URL,FileManagerClientError>
}
