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
    
    let uuid = UUID() // Unique indentifier for this ViewModel
    
    deinit {
        print("DELETING ViewModel - ID: \(uuid)")
    }
    
    init(getArticleLocalAudiosByIdType: GetArticleLocalAudiosByIdType, audioPlayerManager: AudioPlayerManagerType, articleId: String) {
        self.getArticleLocalAudiosByIdType = getArticleLocalAudiosByIdType
        self.audioPlayerManager = audioPlayerManager
        self.articleId = articleId
        print("STARTING ViewModel - ID: \(uuid) for article: \(articleId)")
    }
    
    func onAppear() {
        showSpinner = true
        print("WORKING for the ViewModel: \(uuid)")
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
        print("WORKING for the ViewModel: \(uuid)")
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
