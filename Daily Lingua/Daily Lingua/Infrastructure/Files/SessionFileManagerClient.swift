//
//  SessionFileManagerClient.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

class SessionFileManagerClient: FileManagerClient {
    
    private let session: FileManager
    private let httpClient: HTTPClient
    
    init(session: FileManager, httpClient: HTTPClient) {
        self.session = session
        self.httpClient = httpClient
    }
    
    func makeRequest(for url: String) async -> Result<URL,FileManagerClientError> {
        guard let url = URL(string: url) else {
            return .failure(.badRemoteURL)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                return .failure(.badRemoteURL)
            }

            let documentsURL = session.urls(for: .documentDirectory, in: .userDomainMask).first!

            let filename = url.lastPathComponent

            let localFileURL = documentsURL.appendingPathComponent(filename)

            try data.write(to: localFileURL)

            // Devolver URL local
            return .success(localFileURL)
        } catch {
            return .failure(.creationError)
        }
    }
}
