//
//  FileManagerDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

class FileManagerDataSource: FileManagerDataSourceType {
    
    private let fileManager: FileManagerClient
    
    init(fileManager: FileManagerClient) {
        self.fileManager = fileManager
    }
    
    func getLocalAudios(from remoteURL: String) async -> Result<URL, FileManagerClientError> {
        
        let localURL = await fileManager.makeRequest(for: remoteURL)
        
        guard case .success(let url) = localURL else {
            return .failure(.creationError)
        }
        return .success(url)
    }
}
