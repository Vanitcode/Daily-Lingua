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
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            return .success(())
        } catch {
            return .failure(.playError)
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
