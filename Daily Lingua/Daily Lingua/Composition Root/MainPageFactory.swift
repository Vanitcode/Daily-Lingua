//
//  MainPageFactory.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 4/7/25.
//

import Foundation

class MainPageFactory {
    static func create() -> MainPageArticlesView {
        return MainPageArticlesView(articlesByWeekView: GetArticlesByWeekFactory.create())
    }
}
