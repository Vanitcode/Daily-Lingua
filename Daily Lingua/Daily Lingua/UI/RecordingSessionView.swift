//
//  RecordingSessionView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 3/9/25.
//

import SwiftUI

struct RecordingSessionView: View {
    private var viewModel: RecordingSessionViewModel

    init(viewModel: RecordingSessionViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Recording Test")
                .font(.title)

            if viewModel.isRecording {
                Text("Recording in progress (Answer \(viewModel.currentAnswerNumber ?? 0))...")
                    .foregroundColor(.red)
            }

            // Show all the answers
            if let record = viewModel.articleAudiosRecord {
                VStack(alignment: .leading, spacing: 8) {
                    if let url1 = record.answer1_path {
                        Text("Answer 1: \(url1.lastPathComponent)")
                            .font(.caption)
                    }
                    if let url2 = record.answer2_path {
                        Text("Answer 2: \(url2.lastPathComponent)")
                            .font(.caption)
                    }
                    if let url3 = record.answer3_path {
                        Text("Answer 3: \(url3.lastPathComponent)")
                            .font(.caption)
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // Buttons for recording the answer
            VStack(spacing: 12) {
                ForEach(1...3, id: \.self) { answerNumber in
                    HStack {
                        Button("Start Answer \(answerNumber)") {
                            Task {
                                await viewModel.startRecording(answerNumber: answerNumber)
                            }
                        }
                        .disabled(viewModel.isRecording)

                        Button("Stop") {
                            Task {
                                await viewModel.stopRecording()
                            }
                        }
                        .disabled(!viewModel.isRecording || viewModel.currentAnswerNumber != answerNumber)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
