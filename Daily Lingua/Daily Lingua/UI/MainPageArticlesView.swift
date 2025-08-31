//
//  MainPageArticlesView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 26/6/25.
//

import SwiftUI

struct MainPageArticlesView: View {
    var articlesByWeekView: ArticlesByWeekView

    var body: some View {
        NavigationStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Articles for the Week")
                        .font(.title2)
                        .padding(.top)
                    articlesByWeekView
                }
                .padding()
            
        }
    }
}
