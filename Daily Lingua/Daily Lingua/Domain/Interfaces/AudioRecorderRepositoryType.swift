//
//  AudioRecorderRepositoryType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation

protocol AudioRecorderRepositoryType {
    func startRecording() async -> Result <Void, AudioRecorderError>
    func stopRecording() async -> Result <String, AudioRecorderError>
    func cancelRecording() async -> Result <Void, AudioRecorderError>
}
