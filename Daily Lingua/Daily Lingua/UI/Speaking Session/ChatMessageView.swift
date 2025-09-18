//
//  ChatMessageView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 8/9/25.
//

import SwiftUI

struct ChatMessageView<Content: View>: View {
    
    var isSystemmessage: Bool
    var onAction1: ((Int) -> Void)? = nil
    var onAction2: ((Int) -> Void)? = nil
    var onAction3: ((Int) -> Void)? = nil
    
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

        return VStack(alignment: isSystemmessage ? .leading : .trailing) {
            Image(systemName: isSystemmessage ? "brain" : "person")
                .resizable()
                .frame(width: 32, height: 32)
                .padding(.horizontal)

            VStack(alignment: isSystemmessage ? .leading : .trailing) {
                content
                HStack {
                    Button(action: {
                        onAction1?(1)
                    }) {
                        Image(systemName: "translate")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(8)
                    }
                    Button(action: {
                        onAction2?(2)
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(8)
                    }
                    Button(action: {
                        onAction3?(3)
                    }) {
                        Image(systemName: "repeat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .padding(8)
                    }
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
}


#Preview {
    ChatMessageView(isSystemmessage: true) {
        Text("Hi")
        Image(systemName: "star.fill")
            .foregroundStyle(.yellow)
        Text("This bubble can take everything")
    }
    ChatMessageView(isSystemmessage: false) {
        Text("Hallo")
        Image(systemName: "star.fill")
            .foregroundStyle(.yellow)
        Text("Alles geht gut")
    }
}
