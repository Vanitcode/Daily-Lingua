//
//  AVAudioPlayerManager.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 2/7/25.
//

import Foundation
import AVFoundation


class AVAudioPlayerManager: AudioPlayerType {
    
    private var player: AVAudioPlayer?
    private let queue = DispatchQueue(label: "audio.playback.queue")
    
    func play(from url: URL) -> Result<Void, AudioPlayerError> {
        stop()
        do {
            guard FileManager.default.fileExists(atPath: url.path) else {
                print("Audio file not found at path: \(url.path)")
                return .failure(.playError)
            }

            try configureAudioSession()

            // Diagnostics
            let session = AVAudioSession.sharedInstance()
            print("[Audio] Category: \(session.category.rawValue), Route: \(session.currentRoute.outputs.map { $0.portType.rawValue })")

            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            let started = player?.play() ?? false
            if !started {
                print("AVAudioPlayer failed to start playing.")
                return .failure(.playError)
            }
            return .success(())
        } catch {
            print("Failed to configure audio session or player: \(error)")
            return .failure(.playError)
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
    
    func configureAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setActive(true, options: [])
    }
}

