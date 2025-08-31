//
//  AudioPlayerError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 2/7/25.
//

import Foundation

enum AudioPlayerError: Error {
    case playError
    case stopError
    case noPlayerInitialized
    case stopFailed
    
    var description: String {
        switch self {
        case .playError: return "playError"
        case .stopError: return "stopError"
        case .noPlayerInitialized: return "noPlayerInitialized"
        case .stopFailed: return "stopFailed"
        }
    }
}
