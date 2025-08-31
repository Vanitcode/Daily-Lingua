//
//  ArticleByDateViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 10/6/25.
//

import Foundation

@Observable
class ArticleByDateViewModel {
     
    private let getArticleByDate: GetArticleByDateType
    var article: Article?
    var showSpinner: Bool = false
    
    init(getArticleByDate: GetArticleByDateType) {
        self.getArticleByDate = getArticleByDate
    }
    
    func fetchArticlesByDate(date: String) async throws {
        showSpinner = true
        let result = await getArticleByDate.execute(date: date)
        switch result {
        case .success(let article):
            print("Article received: \(article)")
            self.article = article
        case .failure(let error):
            print("Domain Article Error: \(error)")
        }
        showSpinner = false
    }
}
