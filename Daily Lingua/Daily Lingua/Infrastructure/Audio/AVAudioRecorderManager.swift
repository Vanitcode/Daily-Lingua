//
//  AVAudioRecorderManager.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 23/7/25.
//

import Foundation
import AVFoundation

// Use of the actor because the AVAudio API has no async implementation
actor AVAudioRecorderManager: AVRecordManagerType {

    private var recorder: AVAudioRecorder?
    private var recordingURL: URL?

    func startRecording() async -> Result<Void, AVRecordManagerError> {
        let granted = await requestMicrophonePermission()
        guard granted else {
            return .failure(.permissionDenied)
        }

        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)

            let fileName = UUID().uuidString + ".wav"
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]

            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.prepareToRecord()
            recorder?.record()

            recordingURL = url
            return .success(())
        } catch {
            return .failure(.startRecordingError)
        }
    }

    func stopRecording() async -> Result<URL, AVRecordManagerError> {
        guard let recorder = recorder, let url = recordingURL else {
            return .failure(.stopRecordingError)
        }

        recorder.stop()
        self.recorder = nil
        return .success(url)
    }

    func cancelRecording() async -> Result<Void, AVRecordManagerError> {
        guard let recorder = recorder, let url = recordingURL else {
            return .failure(.cancelRecordingError)
        }

        recorder.stop()
        recorder.deleteRecording()
        self.recorder = nil

        return .success(())
    }

    private func requestMicrophonePermission() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
