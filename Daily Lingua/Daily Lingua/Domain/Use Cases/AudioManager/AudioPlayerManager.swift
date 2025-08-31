//
//  AudioPlayerManager.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 2/7/25.
//

import Foundation

protocol AudioPlayerManagerType {
    func play(_ url: URL) -> Result <Void, AudioPlayerError>
    func stop()
}

class AudioPlayerManager: AudioPlayerManagerType {
    
    private let player: AudioPlayerType
    
    init(player: AudioPlayerType) {
        self.player = player
    }
    
    func play(_ url: URL) -> Result <Void, AudioPlayerError>{
        return player.play(from: url)
        
    }
    
    func stop(){
        player.stop()
    }
}
