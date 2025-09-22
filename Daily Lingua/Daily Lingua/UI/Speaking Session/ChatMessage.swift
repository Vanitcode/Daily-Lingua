//
//  ChatMessage.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 19/9/25.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id: String
    var type: ChatMessageType
}

enum ChatMessageType: Equatable {
    case systemTextLarge(String, URL)
    case systemTextShort(String, URL)
    case userAudio(url: URL, status: UserAudioRecorderStatus, questionIndex: Int)
}

enum UserAudioRecorderStatus: Equatable {
    case initial
    case recording
    case recorded
}
