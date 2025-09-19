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
    
    func play(from url: URL) -> Result<Void, AudioPlayerError> {
        stop()
        do {
            try configureAudioSession()
            player = try AVAudioPlayer(contentsOf: url)
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
        try session.setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try session.setActive(true)
    }
}
