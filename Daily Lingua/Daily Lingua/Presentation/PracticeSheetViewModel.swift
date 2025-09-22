//
//  PracticeSheetViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 12/9/25.
//

import Foundation
import CoreGraphics

@Observable
class PracticeSheetViewModel {
    
    //Use Cases
    private let getArticleLocalAudiosById: GetArticleLocalAudiosByIdType
    private let audioPlayerManager: AudioPlayerManagerType
    private let startRecordingAnswer: StartRecordingAnswerType
    private let stopRecordingAnswer: StopRecordingAnswerType
    private let fetchAudiosRecord: FetchAudiosRecordType
    
    var article: Article
    
    var articleLocalAudios: ArticleLocalAudios? = nil
    var articleAudiosRecord: ArticleAudiosRecord? = nil
    @MainActor var messages: [ChatMessage] = []
    @MainActor var nowPlayingURL: URL? = nil
    @MainActor var state: State = .initialLoading

    //Fields and values for the FakeWave
    var audioLevels: [CGFloat] = Array(repeating: 20, count: 30)
    private var timer: Timer?
    
    init(getArticleLocalAudiosById: GetArticleLocalAudiosByIdType, audioPlayerManager: AudioPlayerManagerType, startRecordingAnswer: StartRecordingAnswerType, stopRecordingAnswer: StopRecordingAnswerType, fetchAudiosRecord: FetchAudiosRecordType, article: Article) {
        self.getArticleLocalAudiosById = getArticleLocalAudiosById
        self.audioPlayerManager = audioPlayerManager
        self.startRecordingAnswer = startRecordingAnswer
        self.stopRecordingAnswer = stopRecordingAnswer
        self.fetchAudiosRecord = fetchAudiosRecord
        self.article = article
    }
    
    @MainActor
    func onAppear() {
        messages = []
        self.state = .initialLoading

        Task {
            async let localAudiosResult = getArticleLocalAudiosById.execute(articleId: article.id)
            async let recordResult = fetchAudiosRecord.execute(for: article.id)

            let (res1, res2) = await (localAudiosResult, recordResult)

            switch res1 {
            case .success(let resultArticleLocalAudios):
                self.articleLocalAudios = resultArticleLocalAudios
            case .failure:
                self.state = .error("Remote error")
                return
            }

            if case .success(let articleRecordsAudios) = res2 {
                self.articleAudiosRecord = articleRecordsAudios
            } else {
                self.articleAudiosRecord = nil
            }
            self.rebuildMessages()
            if let local = self.articleLocalAudios {
                if self.nextUnrecordedQuestionIndex() == nil {
                    self.state = .completed
                } else {
                    self.state = .ready(articleLocalAudios: local)
                }
            }
        }
    }
    
    @MainActor
    func startRecording(for questionIndex: Int) async {
        if nowPlayingURL != nil {
            audioPlayerManager.stop()
            nowPlayingURL = nil
        }
        startFakeWaveform()
        self.state = .recordingAnswer(number: questionIndex)

        guard let index = messages.firstIndex(where: {
            if case let .userAudio(_, _, qIndex) = $0.type, qIndex == questionIndex { return true }
            return false
        }) else {
            return
        }

        let result = await startRecordingAnswer.execute(articleId: article.id, answerNumber: questionIndex)

        switch result {
        case .success:
            messages[index].type = .userAudio(
                url: URL(filePath: ""),
                status: .recording,
                questionIndex: questionIndex
            )
        case .failure:
            messages[index].type = .userAudio(
                url: URL(filePath: ""),
                status: .initial,
                questionIndex: questionIndex
            )
        }
    }

    @MainActor
    func stopRecording(for questionIndex: Int) async {
        stopFakeWaveform()
        self.state = .recordingAnswerStopped(number: questionIndex)

        let result = await stopRecordingAnswer.execute(articleId: article.id, answerNumber: questionIndex)

        switch result {
        case .success(let updatedArticle):
            self.articleAudiosRecord = updatedArticle

            self.rebuildMessages()

            if nextUnrecordedQuestionIndex() == nil {
                self.state = .completed
            } else if let local = self.articleLocalAudios {
                self.state = .ready(articleLocalAudios: local)
            }

        case .failure:
            if let index = messages.firstIndex(where: {
                if case let .userAudio(_, _, qIndex) = $0.type, qIndex == questionIndex { return true }
                return false
            }) {
                messages[index].type = .userAudio(
                    url: URL(fileURLWithPath: ""),
                    status: .initial,
                    questionIndex: questionIndex
                )
            }
        }
    }
    
    @MainActor
    func fetchAudios() async {
        
        let result = await fetchAudiosRecord.execute(for: article.id)
        
        if case .success(let existingArticle) = result {
            articleAudiosRecord = existingArticle
        } else {
            print("Could not fetch the audio recordings")
        }
        
    }
    
    @MainActor
    private func rebuildMessages() {
        guard let local = articleLocalAudios else {
            print("No se pudo obtener el audio local para el artículo")
            return
        }
        print("Creando mensaje de sistema con audioURL:", local.article_path)

        var newMessages: [ChatMessage] = []
        newMessages.append(ChatMessage(id: "article", type: .systemTextLarge(article.text, local.article_path)))

        let questionTexts = [article.question1, article.question2, article.question3]
        let questionURLs = [local.question1_path, local.question2_path, local.question3_path]

        var encounteredUnrecorded = false

        for i in 0..<3 {
            if encounteredUnrecorded { break }

            newMessages.append(ChatMessage(id: "q\(i)-system", type: .systemTextShort(questionTexts[i], questionURLs[i])))

            if let answerURL = articleAudiosRecord?.answerURL(for: i) {
                newMessages.append(ChatMessage(id: "q\(i)-user", type: .userAudio(url: answerURL, status: .recorded, questionIndex: i)))
            } else {
                newMessages.append(ChatMessage(id: "q\(i)-user", type: .userAudio(url: URL(fileURLWithPath: ""), status: .initial, questionIndex: i)))
                encounteredUnrecorded = true
            }
        }

        messages = newMessages
    }

    @MainActor
    private func nextUnrecordedQuestionIndex() -> Int? {
        for i in 0..<3 {
            if articleAudiosRecord?.answerURL(for: i) == nil {
                return i
            }
        }
        return nil
    }
    @MainActor
    private func isRecordingState(_ state: State) -> Bool {
        switch state {
        case .recordingAnswer(_), .recordingAnswerStopped(_):
            return true
        default:
            return false
        }
    }
    
    @MainActor func playAudio(url: URL){
        let result = audioPlayerManager.play(url)
        if case .failure(let error) = result {
            print("Domain AudioPlayerManager Error: \(error)")
            return
        } 
        nowPlayingURL = url
        if !isRecordingState(state) {
            self.state = .playingAudio
        }
    }
    
    @MainActor func stopAudio(){
        audioPlayerManager.stop()
        nowPlayingURL = nil
        if !isRecordingState(state) {
            self.state = .stopPlayingAudio
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
    
    enum State {
        case initialLoading
        case ready(articleLocalAudios: ArticleLocalAudios)

        case playingAudio
        case stopPlayingAudio
        case recordingAnswer(number: Int)
        case recordingAnswerStopped(number: Int)
        case answerRecorded(number: Int)

        case completed

        case error(String)
    }

}

