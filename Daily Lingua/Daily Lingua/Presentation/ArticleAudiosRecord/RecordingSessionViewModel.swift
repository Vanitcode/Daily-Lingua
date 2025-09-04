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
    var currentArticleId = "HBwVVgl6kn3elVjfI8jr"
    
    var errorMessage: String? = nil
    var articleAudiosRecord: ArticleAudiosRecord? = nil
    
    private let startRecordingAnswer: StartRecordingAnswerType
    private let stopRecordingAnswer: StopRecordingAnswerType
    private let fetchAudiosRecord: FetchAudiosRecordType
    
    init(startRecordingAnswer: StartRecordingAnswerType, stopRecordingAnswer: StopRecordingAnswerType, fetchAudiosRecord: FetchAudiosRecordType) {
        self.startRecordingAnswer = startRecordingAnswer
        self.stopRecordingAnswer = stopRecordingAnswer
        self.fetchAudiosRecord = fetchAudiosRecord
    }
    
    @MainActor
    func startRecording(answerNumber: Int) async {
        errorMessage = nil
        currentAnswerNumber = answerNumber
        
        let result = await startRecordingAnswer.execute(articleId: currentArticleId, answerNumber: answerNumber)
        switch result {
        case .success:
            isRecording = true
        case .failure(let error):
            isRecording = false
            errorMessage = "There was an error starting the recording: \(error)"
        }
    }
    
    @MainActor
    func stopRecording() async {
        errorMessage = nil
        guard let answerNumber = currentAnswerNumber else { return }
        
        let result = await stopRecordingAnswer.execute(articleId: currentArticleId, answerNumber: answerNumber)
        
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
    func fetchAudios() {
        
        errorMessage = nil
        let result =  fetchAudiosRecord.execute(for: currentArticleId)
        
        if case .success(let existingArticle) = result {
            articleAudiosRecord = existingArticle
        } else {
            errorMessage = "Could not fetch the audio recordings"
        }
        
    }
}
