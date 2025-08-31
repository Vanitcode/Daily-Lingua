//
//  AudioRecorderError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

enum AudioRecorderError: Error {
    case generic
    case startRecordingError
    case stopRecordingError
    case cancelRecordingError
    case permissionDenied
}
