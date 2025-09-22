//
//  TabBarPracticeView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 19/9/25.
//

import SwiftUI

enum TabBarMode {
    case completed
    case userAudio(ChatMessage)
}

struct TabBarPracticeView: View {
    
    let mode: TabBarMode
    
    var startRecording: (() -> Void)? = nil // Start Record
    var stopRecording: (() -> Void)? = nil // Stop Record
    var cancelRecording: (() -> Void)? = nil // Cancel Record
    var sendReport: (() -> Void)? = nil // Send records to report
    
    var body: some View {
        HStack {
            switch mode {
            case .completed:
                Button(action: { sendReport?() }) {
                    Image(systemName: "square.and.arrow.up.badge.checkmark")
                        .resizable()
                        .frame(width: 66, height: 66)
                        .foregroundColor(.blue)
                }

            case .userAudio(let message):
                if case .userAudio(_, let status, _) = message.type {
                    switch status {
                    case .initial:
                        Button(action: { startRecording?() }) {
                            Image(systemName: "mic.circle.fill")
                                .resizable()
                                .frame(width: 66, height: 66)
                                .foregroundColor(.green)
                        }

                    case .recording:
                        
                        Button(action: { stopRecording?()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .frame(width: 66, height: 66)
                                .foregroundColor(.blue)
                            }.padding(.horizontal)
                        
                        Button(action: {
                            cancelRecording?()
                        }) {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.gray)
                        }.padding(.horizontal)

                    case .recorded:
                        HStack {
                            Button(action: { startRecording?() }) {
                                Image(systemName: "mic.circle.fill")
                                    .resizable()
                                    .frame(width: 66, height: 66)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
    }
}

#Preview {

}
