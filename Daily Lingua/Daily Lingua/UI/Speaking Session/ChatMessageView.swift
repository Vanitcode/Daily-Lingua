//
//  ChatMessageView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 8/9/25.
//

import SwiftUI

struct ChatMessageView<Content: View>: View {
    
    var isSystemmessage: Bool
    var message: ChatMessage
    var onAction1: (() -> Void)? = nil // To listen
    var onAction2: (() -> Void)? = nil // For recording actions
    //var onAction3: (() -> Void)? = nil
    
    @ViewBuilder var content: Content

    var body: some View {
        HStack {
            if isSystemmessage {
                bubble
                Spacer(minLength: 60)
            } else {
                Spacer(minLength: 60)
                bubble
            }
        }
        .padding(.horizontal)
    }

    private var bubble: some View {
        let colors = bubbleColors(isSystemMessage: isSystemmessage)
        let button1Image = button1Image(message: message)
        let button2Image = button2Image(message: message)
        

        return VStack(alignment: isSystemmessage ? .leading : .trailing) {
            Image(systemName: isSystemmessage ? "brain" : "person")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(.horizontal)

            VStack(alignment: isSystemmessage ? .leading : .trailing) {
                content
                HStack {
                    Button(action: {
                        onAction1?()
                    }) {
                        Image(systemName: button1Image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(8)
                    }
                    Button(action: {
                        onAction2?()
                    }) {
                        Image(systemName: button2Image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(8)
                    }
//                    Button(action: {
//                        onAction3?()
//                    }) {
//                        Image(systemName: "repeat")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 18, height: 18)
//                            .padding(8)
//                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: isSystemmessage ? .leading : .trailing)
            .padding()
            .background(colors.background)
            .foregroundStyle(colors.foreground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(alignment: isSystemmessage ? .bottomLeading : .bottomTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(isSystemmessage ? 45 : -45))
                    .offset(x: isSystemmessage ? -10 : 10, y: 10)
                    .foregroundStyle(colors.background)
            }
        }
    }

    private func bubbleColors(isSystemMessage: Bool) -> (background: Color, foreground: Color) {
        if isSystemMessage {
            return (
                background: Color(red: 242/255, green: 244/255, blue: 247/255),
                foreground: .black
            )
        } else {
            return (
                background: Color(red: 87/255, green: 109/255, blue: 244/255),
                foreground: .white
            )
        }
    }
    
    private func button1Image(message: ChatMessage) -> String {
        switch message.type {
        case .systemTextLarge:
            return "speaker.wave.2"
        case .systemTextShort:
            return "speaker.wave.2"
        case .userAudio(_, let status, _):
            switch status {
            case .initial:
                return "mic"
            case .recording:
                return "stop.circle"
            case .recorded:
                return "repeat.circle"
            }
        }
    }
    
    private func button2Image(message: ChatMessage) -> String {
        switch message.type {
        case .systemTextLarge:
            return ""
        case .systemTextShort:
            return ""
        case .userAudio(_, let status, _):
            switch status {
            case .recorded:
                return "play.circle"
            default:
                return ""
            }
        }
    }
}


#Preview {
//    ChatMessageView(isSystemmessage: true) {
//        Text("Hi")
//        Image(systemName: "star.fill")
//            .foregroundStyle(.yellow)
//        Text("This bubble can take everything")
//    }
//    ChatMessageView(isSystemmessage: false) {
//        Text("Hallo")
//        Image(systemName: "star.fill")
//            .foregroundStyle(.yellow)
//        Text("Alles geht gut")
//    }
}

