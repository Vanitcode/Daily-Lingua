//
//  FreeArticleByWeekViewModel.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import Foundation

@Observable
class FreeArticleByWeekViewModel {
    
    private let getFreeArticleByWeek: GetFreeArticleByWeekType
    var article: Article?
    var showSpinner: Bool = false
    
    init(getFreeArticleByWeek: GetFreeArticleByWeekType) {
        self.getFreeArticleByWeek = getFreeArticleByWeek
    }
    
    func onAppear() {
        Task {
            showSpinner = true
            
            //let result = await getFreeArticleByWeek.execute(week: WeekIdCalculator.currentWeekId())
            let result = await getFreeArticleByWeek.execute(week: "2025-W23")
            
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
}
