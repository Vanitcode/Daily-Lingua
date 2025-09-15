//
//  PracticeSheetViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 12/9/25.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    var type: ChatMessageType
}

enum ChatMessageType {
    case systemTextLarge(String)
    case systemTextShort(String, URL)
    case userAudio(url: URL, status: userAudioRecorderStatus, questionIndex: Int)
}

enum userAudioRecorderStatus {
    case initial
    case recording
    case recorded
}


@Observable
class PracticeSheetViewModel {
    
    //Use Cases
    private let getArticleLocalAudiosById: GetArticleLocalAudiosByIdType
    private let audioPlayerManager: AudioPlayerManagerType
    private let startRecordingAnswer: StartRecordingAnswerType
    private let stopRecordingAnswer: StopRecordingAnswerType
    private let fetchAudiosRecord: FetchAudiosRecordType
    
    var article: Article
    
    var articlesLocalAudios: [ArticleLocalAudios] = []
    var articleAudiosRecord: ArticleAudiosRecord? = nil
    var messages: [ChatMessage] = []
    var currentQuestionIndex: Int = 0
    
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
    
    func onAppear() {
        
        Task {
            async let localAudiosResult = getArticleLocalAudiosById.execute(articleId: article.id)
            async let recordResult = fetchAudiosRecord.execute(for: article.id)
            
            let (res1, res2) = await (localAudiosResult, recordResult)
            
            await MainActor.run {
                if case .success(let articleLocalAudios) = res1 {
                    self.articlesLocalAudios.append(articleLocalAudios)
                    self.messages.append(.init(type: .systemTextLarge(article.text)))
                    self.messages.append(.init(type: .systemTextShort(article.question1, articleLocalAudios.question1_path)))
                    showNewQuestion(index: 0, audios: articleLocalAudios)
                } else {
                    print("Error en LocalAudios: \(res1)")
                }
                if case .success(let articleAudios) = res2 {
                    self.articleAudiosRecord = articleAudios
                } else {
                    print("There are no records for this article.")
                }
            }
        }
    }
    
    private func showNewQuestion(index: Int, audios: ArticleLocalAudios) {
        guard index < 3 else { return }
        let questionText = [article.question1, article.question2, article.question3][index]
        let questionAudioURL = [audios.question1_path, audios.question2_path, audios.question3_path][index]

        messages.append(.init(type: .systemTextShort(questionText, questionAudioURL)))
        messages.append(.init(type: .userAudio(url: URL(fileURLWithPath: ""), status: .initial, questionIndex: index)))
        currentQuestionIndex = index
    }
    
    @MainActor
    func startRecording(for questionIndex: Int) async {
        stopFakeWaveform()

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

        guard let index = messages.firstIndex(where: {
            if case let .userAudio(_, _, qIndex) = $0.type, qIndex == questionIndex { return true }
            return false
        }) else {
            return
        }

        let result = await stopRecordingAnswer.execute(articleId: article.id, answerNumber: questionIndex)

        switch result {
        case .success(let updatedArticle):
            articleAudiosRecord = updatedArticle

            if let answerURL = updatedArticle.answerURL(for: questionIndex) {
                messages[index].type = .userAudio(
                    url: answerURL,
                    status: .recorded,
                    questionIndex: questionIndex
                )
            } else {
                messages[index].type = .userAudio(
                    url: URL(filePath: ""),
                    status: .initial,
                    questionIndex: questionIndex
                )
            }

        case .failure:
            messages[index].type = .userAudio(
                url: URL(filePath: ""),
                status: .initial,
                questionIndex: questionIndex
            )
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
    
    func playAudio(url: URL){
        let result = audioPlayerManager.play(url)
        if case .failure(let error) = result {
            print("Domain AudioPlayerManager Error: \(error)")
        }
    }
    
    func stopAudio(){
        audioPlayerManager.stop()
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
        case ready([ArticleLocalAudios])

        
        case playingAudio(number: Int)
        case recordingAnswer(number: Int)
        case answerRecorded(number: Int)

        case completed

        case error(String)
    }

    var state: State = .initialLoading
}
