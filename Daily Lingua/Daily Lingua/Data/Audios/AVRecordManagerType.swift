//
//  AVRecordManagerType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/8/25.
//

import Foundation

protocol AVRecordManagerType {
    func startRecording() async -> Result<Void, AVRecordManagerError>
    func stopRecording() async -> Result<URL, AVRecordManagerError>
    func cancelRecording() async -> Result<Void, AVRecordManagerError>
}
