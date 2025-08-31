//
//  AVRecordManagerError.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/8/25.
//

import Foundation

enum AVRecordManagerError: Error {
    case generic
    case startRecordingError
    case stopRecordingError
    case cancelRecordingError
    case permissionDenied
    
    var description: String {
        switch self {
        case .generic:
            return "AVManagerError.genericError"
        case .startRecordingError:
            return "AVManagerError.startRecordingError"
        case .stopRecordingError:
            return "AVManagerError.stopRecordingError"
        case .cancelRecordingError:
            return "AVManagerError.cancelRecordingError"
        case .permissionDenied:
            return "AVManagerError.permissionDenied"
        }
    }

}
