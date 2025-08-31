//
//  AVRecordManagerDataSourceType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 1/8/25.
//

import Foundation

protocol AVRecordManagerDataSourceType {
    func startRecording() async -> Result<Void, AVRecordManagerError>
    func stopRecording() async -> Result<String, AVRecordManagerError>
    func cancelRecording() async -> Result<Void, AVRecordManagerError>
}
