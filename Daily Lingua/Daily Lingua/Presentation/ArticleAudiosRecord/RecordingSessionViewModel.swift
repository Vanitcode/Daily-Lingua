//
//  RecordingSessionViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 3/9/25.
//

import Foundation
import Observation

@Observable
class RecordingSessionViewModel {
        
    var isRecording: Bool = false
    var currentAnswerNumber: Int? = nil
    var article: Article
    
    var errorMessage: String? = nil
    var articleAudiosRecord: ArticleAudiosRecord? = nil
    
    //Fields and values for the FakeWave
    var audioLevels: [CGFloat] = Array(repeating: 20, count: 30)
    private var timer: Timer?
    
    private let startRecordingAnswer: StartRecordingAnswerType
    private let stopRecordingAnswer: StopRecordingAnswerType
    private let fetchAudiosRecord: FetchAudiosRecordType
    
    init(startRecordingAnswer: StartRecordingAnswerType, stopRecordingAnswer: StopRecordingAnswerType, fetchAudiosRecord: FetchAudiosRecordType, article: Article) {
        self.startRecordingAnswer = startRecordingAnswer
        self.stopRecordingAnswer = stopRecordingAnswer
        self.fetchAudiosRecord = fetchAudiosRecord
        self.article = article
    }
    
    func onAppear() {
        Task {
            let result = await fetchAudiosRecord.execute(for: article.id)
            guard case .success(let articleAudios) = result else {
                print("Domain ArticleLocalAudios Error: \(result)")
                return
            }
            Task { @MainActor in
                self.articleAudiosRecord = articleAudios
            }
        }
    }
    
    @MainActor
    func startRecording(answerNumber: Int) async {
        errorMessage = nil
        currentAnswerNumber = answerNumber
        
        let result = await startRecordingAnswer.execute(articleId: article.id, answerNumber: answerNumber)
        switch result {
        case .success:
            startFakeWaveform()
            isRecording = true
        case .failure(let error):
            isRecording = false
            errorMessage = "There was an error starting the recording: \(error)"
        }
    }
    
    @MainActor
    func stopRecording() async {
        stopFakeWaveform()
        errorMessage = nil
        guard let answerNumber = currentAnswerNumber else { return }
        
        let result = await stopRecordingAnswer.execute(articleId: article.id, answerNumber: answerNumber)
        
        switch result {
        case .success(let updatedArticle):
            isRecording = false
            currentAnswerNumber = nil
            articleAudiosRecord = updatedArticle
        case .failure(let error):
            errorMessage = "There was an error stopping the recording: \(error)"
        }
    }
    
    @MainActor
    func fetchAudios() async {
        
        errorMessage = nil
        let result = await fetchAudiosRecord.execute(for: article.id)
        
        if case .success(let existingArticle) = result {
            articleAudiosRecord = existingArticle
        } else {
            errorMessage = "Could not fetch the audio recordings"
        }
        
    }
    
    // MARK: - Functions for the FakeWave
    private func startFakeWaveform() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }
            let randomLevel = CGFloat.random(in: 10...100)
            self.audioLevels.removeFirst()
            self.audioLevels.append(randomLevel)
        }
    }

    private func stopFakeWaveform() {
        timer?.invalidate()
        timer = nil
    }
}


