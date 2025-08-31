//
//  ArticlesByWeekView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import SwiftUI

struct ArticlesByWeekView: View {
    let viewModel: ArticlesByWeekViewModel
    private let createPracticeSheetView: CreatePracticeSheetView

    init(viewModel: ArticlesByWeekViewModel, createPracticeSheetView: CreatePracticeSheetView) {
        self.viewModel = viewModel
        self.createPracticeSheetView = createPracticeSheetView
    }

    var body: some View {
        VStack {
            HStack {
                Text("Your articles for the week 2025-W23 are:")
                Spacer()
                Button("Refresh") {
                    Task {
                        viewModel.onRefresh()
                    }
                }
            }
            if viewModel.showSpinner {
                ProgressView().progressViewStyle(.circular)
            } else {
                Text("Count of articles: \(viewModel.articles.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                List(viewModel.articles, id: \.id) { article in
                    NavigationLink(destination: createPracticeSheetView.create(articleId: article.id)) {
                        Text(article.title)
                    }
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
