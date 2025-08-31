//
//  FileManagerDataSourceType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

protocol FileManagerDataSourceType {
    func getLocalAudios(from remoteURL: String) async throws -> Result<URL, FileManagerClientError>
}
