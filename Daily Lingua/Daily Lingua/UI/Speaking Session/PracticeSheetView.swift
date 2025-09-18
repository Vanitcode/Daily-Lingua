//
//  PracticeSheetView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import SwiftUI
import Observation

struct PracticeSheetView: View {
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    @State private var viewModel: PracticeSheetViewModel
    
    init(viewModel: PracticeSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel

        VStack {
            switch viewModel.state {
            case .initialLoading:
                ProgressView("Loading...")
                    .progressViewStyle(.circular)
                
            case .error(let message):
                Button("Start Answer \(message)") {
                    Task {
                        viewModel.onAppear()
                    }
                }
                
            default:
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            SessionArticlePresentationView(article: viewModel.article)
                            ForEach(viewModel.messages) { message in
                                switch message.type {
                                case .systemTextLarge(let text, let audioURL):
                                    ChatMessageView(isSystemmessage: true,
                                                    onAction2: { _ in
                                        viewModel.playAudio(url: audioURL)
                                    }) {
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
                                    
                                case .userAudio(let audioUrl, let status, let qIndex):
                                    ChatMessageView(isSystemmessage: false,
                                                    onAction1: { _ in
                                        Task {
                                            await viewModel.startRecording(for: qIndex)
                                        }
                                    },
                                                    onAction2: { _ in
                                        if status == .recorded {
                                            viewModel.playAudio(url: audioUrl)
                                        } else if status == .recording {
                                            Task {
                                                await viewModel.stopRecording(for: qIndex)
                                            }
                                        }
                                    },
                                                    onAction3: { _ in
                                        Task {
                                            viewModel.playAudio(url: audioUrl)
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
                    .onChange(of: viewModel.messages) { oldValue, newValue in
                        if let lastID = newValue.last?.id {
                            withAnimation(.easeInOut) {
                                proxy.scrollTo(lastID, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        if let lastID = viewModel.messages.last?.id {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                    }
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
