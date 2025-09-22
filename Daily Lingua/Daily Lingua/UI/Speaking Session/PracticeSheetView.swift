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
    @State private var didReachCompleted = false

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
                    Task { viewModel.onAppear() }
                }

            default:
                VStack(spacing: 0) {
                    messagesList
                    tabBarSection
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear { viewModel.onAppear() }
        .onChange(of: String(describing: viewModel.state)) { _, _ in
            if case .completed = viewModel.state {
                didReachCompleted = true
            }
        }
        .navigationTitle("Training")
    }

    // MARK: - Messages List
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    SessionArticlePresentationView(article: viewModel.article)

                    ForEach(viewModel.messages) { message in
                        messageView(for: message)
                    }
                }
                .padding(.vertical)
            }
            .onChange(of: viewModel.messages) { _, newValue in
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

    @ViewBuilder
    private func messageView(for message: ChatMessage) -> some View {
        switch message.type {
        case .systemTextLarge(let text, let audioURL):
            ChatMessageView(isSystemmessage: true, message: message,
                            onAction1: { viewModel.playAudio(url: audioURL) }) {
                Text(text).font(.body)
            }

        case .systemTextShort(let text, let audioURL):
            ChatMessageView(isSystemmessage: true, message: message,
                            onAction1: { viewModel.playAudio(url: audioURL) }) {
                Text(text)
            }

        case .userAudio(let audioUrl, let status, let qIndex):
            ChatMessageView(isSystemmessage: false, message: message,
                            onAction1: {
                if status == .recorded || status == .initial {
                    Task { await viewModel.startRecording(for: qIndex) }
                } else if status == .recording {
                    Task { await viewModel.stopRecording(for: qIndex) }
                }
            }, onAction2: {
                if status == .recorded {
                    Task { viewModel.playAudio(url: audioUrl) }
                }
            }) {
                userAudioStatusView(status: status)
            }
        }
    }

    private func userAudioStatusView(status: UserAudioRecorderStatus) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            switch status {
            case .initial:
                Text("You can start recording your answer.")
                    .italic()
                    .foregroundStyle(.secondary)
            case .recording:
                Text("Recording...")
                    .foregroundStyle(.red)
            case .recorded:
                Text("Recorded response. You can try again if you want.")
                    .bold()
            }
        }
    }

    // MARK: - TabBar Section
    @ViewBuilder
    private var tabBarSection: some View {
        if didReachCompleted {
            TabBarPracticeView(
                mode: .completed,
                sendReport: { print("Se mandará el informe, etc.") }
            )
        } else {
            switch viewModel.state {
            case .completed:
                TabBarPracticeView(
                    mode: .completed,
                    sendReport: { print("Se mandará el informe, etc.") }
                )

            default:
                if let recordingMessage = viewModel.messages.last(where: { message in
                    if case let .userAudio(_, status, _) = message.type {
                        return status == .recording
                    }
                    return false
                }), case let .userAudio(_, _, qIndex) = recordingMessage.type {
                    TabBarPracticeView(
                        mode: .userAudio(recordingMessage),
                        startRecording: { Task { await viewModel.startRecording(for: qIndex) } },
                        stopRecording: { Task { await viewModel.stopRecording(for: qIndex) } },
                        cancelRecording: { Task { await viewModel.stopRecording(for: qIndex) } }
                    )
                } else if let lastUserAudioMessage = viewModel.messages.last(where: { message in
                    if case .userAudio = message.type { return true }
                    return false
                }), case let .userAudio(_, status, qIndex) = lastUserAudioMessage.type {
                    TabBarPracticeView(
                        mode: .userAudio(lastUserAudioMessage),
                        startRecording: {
                            if status == .initial || status == .recorded {
                                Task { await viewModel.startRecording(for: qIndex) }
                            }
                        },
                        stopRecording: {
                            if status == .recording {
                                Task { await viewModel.stopRecording(for: qIndex) }
                            }
                        },
                        cancelRecording: { Task { await viewModel.stopRecording(for: qIndex) } }
                    )
                }
            }
        }
    }
}

