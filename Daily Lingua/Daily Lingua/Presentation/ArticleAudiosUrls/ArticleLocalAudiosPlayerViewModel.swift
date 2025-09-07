//
//  ArticleLocalAudiosPlayerViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 3/7/25.
//

import Foundation

@Observable
class ArticleLocalAudiosPlayerViewModel {
    
    private let getArticleLocalAudiosByIdType: GetArticleLocalAudiosByIdType
    private let audioPlayerManager: AudioPlayerManagerType
    private let articleId: String
    var articles: [ArticleLocalAudios] = []
    var showSpinner: Bool = false
    var isPlaying: Bool = false
    
    init(getArticleLocalAudiosByIdType: GetArticleLocalAudiosByIdType, audioPlayerManager: AudioPlayerManagerType, articleId: String) {
        self.getArticleLocalAudiosByIdType = getArticleLocalAudiosByIdType
        self.audioPlayerManager = audioPlayerManager
        self.articleId = articleId
    }
    
    func onAppear() {
        showSpinner = true
        Task {
            let result = await getArticleLocalAudiosByIdType.execute(articleId: articleId)
            guard case .success(let article) = result else {
                print("Domain ArticleLocalAudios Error: \(result)")
                return
            }
            Task { @MainActor in
                showSpinner = false
                self.articles.append(article)
            }
        }
    }
    
    
    func playAudio(url: URL){
        isPlaying = true
        defer { isPlaying = false }
        let result = audioPlayerManager.play(url)
        if case .failure(let error) = result {
            print("Domain AudioPlayerManager Error: \(error)")
        }
    }
    
    func stopAudio(){
        isPlaying = false
        audioPlayerManager.stop()
    }
}
