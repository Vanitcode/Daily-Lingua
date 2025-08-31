//
//  ArticlesByWeekViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import Foundation

@Observable
class ArticlesByWeekViewModel {
    
    private let fetchArticlesByWeek: FetchArticlesByWeekType
    private let checkArticlesByWeek: CheckArticlesByWeekType
    var articles: [Article] = []
    var showSpinner: Bool = false
    
    init(fetchArticlesByWeek: FetchArticlesByWeekType, checkArticlesByWeek: CheckArticlesByWeekType) {
        self.fetchArticlesByWeek = fetchArticlesByWeek
        self.checkArticlesByWeek = checkArticlesByWeek
    }
    
    
    func onAppear() {
        Task{
            showSpinner = true
            
            //let result = await getFreeArticleByWeek.execute(week: WeekIdCalculator.currentWeekId())
            let result = await checkArticlesByWeek.execute(week: "2025-W23")
            manageResult(result)
            showSpinner = false
        }
    }
    
    func onRefresh() {
        Task{
            showSpinner = true
            
            //let result = await getFreeArticleByWeek.execute(week: WeekIdCalculator.currentWeekId())
            let result = await fetchArticlesByWeek.execute(week: "2025-W23")
            manageResult(result)
            showSpinner = false
        }
    }
    
    private func manageResult(_ result: Result<[Article], ArticleDomainError>) {
        switch result {
        case .success(let articles):
            self.articles = articles
        case .failure(let error):
            print("Domain Article Error: \(error)")
        }
    }
}
