//
//  AVRecordManagerDataSource.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 4/8/25.
//

import Foundation

class AVRecordManagerDataSource: AVRecordManagerDataSourceType {
    
    private let recordManager: AVRecordManagerType
    
    init(recordManager: AVRecordManagerType) {
        self.recordManager = recordManager
    }
    
    func startRecording() async -> Result<Void, AVRecordManagerError> {
        return await recordManager.startRecording()
    }
    
    func stopRecording() async -> Result<URL, AVRecordManagerError> {
        return await recordManager.stopRecording()
    }
    
    func cancelRecording() async -> Result<Void, AVRecordManagerError> {
        return await recordManager.cancelRecording()
    }

}
