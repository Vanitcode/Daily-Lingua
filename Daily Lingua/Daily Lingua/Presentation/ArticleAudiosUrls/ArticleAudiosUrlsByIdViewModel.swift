//
//  ArticleAudiosUrlsByIdViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import Foundation

@Observable
class ArticleAudiosUrlsByIdViewModel {
    private let getArticleAudioUrlsById: GetArticleAudiosUrlsByIdType
    var articleAudiosUrls: ArticleAudiosUrls?
    var showSpinner: Bool = false
    
    init(getArticleAudioUrlsById: GetArticleAudiosUrlsByIdType, articleId: String, articleAudiosUrls: ArticleAudiosUrls? = nil) {
        self.getArticleAudioUrlsById = getArticleAudioUrlsById
    }
    
    func onAppear(articleId: String) {
        Task {
            showSpinner = true
            let result = await getArticleAudioUrlsById.execute(articleId: articleId)
            manageResult(result)
            showSpinner = false
        }
    }
    
    private func manageResult(_ result: Result<ArticleAudiosUrls, ArticleAudiosUrlsDomainError>) {
        switch result {
        case .success(let articleAudiosUrls):
            self.articleAudiosUrls = articleAudiosUrls
        case .failure(let error):
            print("Domain ArticleAudiosUrls Error: \(error)")
        }
    }
    
}
