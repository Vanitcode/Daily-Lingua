//
//  FileManagerClientError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/7/25.
//

import Foundation

enum FileManagerClientError: Error {
    case badRemoteURL
    case creationError
    case readingError
}
