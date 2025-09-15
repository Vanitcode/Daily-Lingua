//
//  PracticeSheetView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import SwiftUI

struct PracticeSheetView: View {
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    private var viewModel: PracticeSheetViewModel
    
    init(viewModel: PracticeSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .initialLoading:
                ProgressView("Loading...")
                    .progressViewStyle(.circular)
                
            case .error(let message):
                Text("Error: \(message)")
                
            default:
                ScrollView {
                    LazyVStack(spacing: 16) {
                        SessionArticlePresentationView(article: viewModel.article)
                        ForEach(viewModel.messages) { message in
                            switch message.type {
                            case .systemTextLarge(let text):
                                ChatMessageView(isSystemmessage: true) {
                                    Text(text)
                                        .font(.body)
                                }
                                
                            case .systemTextShort(let text, let audioURL):
                                ChatMessageView(isSystemmessage: true,
                                                onAction2: { _ in
                                    viewModel.playAudio(url: audioURL)
                                }) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(text)
                                        Text("(Touch the speaker to listen)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                            case .userAudio(let url, let status, let qIndex):
                                ChatMessageView(isSystemmessage: false,
                                                onAction1: { _ in
                                    Task {
                                        await viewModel.startRecording(for: qIndex)
                                    }
                                },
                                                onAction2: { _ in
                                    if status == .recorded {
                                        viewModel.playAudio(url: url)
                                    } else if status == .recording {
                                        Task {
                                            await viewModel.stopRecording(for: qIndex)
                                        }
                                    }
                                },
                                                onAction3: { _ in
                                    Task {
                                        await viewModel.startRecording(for: qIndex)
                                    }
                                }) {
                                    VStack(alignment: .trailing, spacing: 4) {
                                        switch status {
                                        case .initial:
                                            Text("Sin respuesta aún")
                                                .italic()
                                                .foregroundStyle(.secondary)
                                        case .recording:
                                            Text("Grabando...")
                                                .foregroundStyle(.red)
                                        case .recorded:
                                            Text("Respuesta grabada")
                                                .bold()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            viewModel.onAppear()
        }
        .navigationTitle("Training")
    }
}
