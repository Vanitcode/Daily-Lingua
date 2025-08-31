//
//  AudioPlayerType.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 2/7/25.
//

import Foundation

protocol AudioPlayerType {
  func play(from url: URL) -> Result<Void, AudioPlayerError>
  func stop()
}
