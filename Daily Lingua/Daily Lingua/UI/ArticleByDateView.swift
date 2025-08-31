 //
//  ArticleByDateView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 10/6/25.
//

import SwiftUI

struct ArticleByDateView: View {
    
    @Bindable var viewModel: ArticleByDateViewModel
    
    init(viewModel: ArticleByDateViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Your article for the date 2025-06-06 is:")
            
            Button("Cargar artículos") {
                Task {
                    try await viewModel.fetchArticlesByDate(date: "2025-06-06")
                }
            }
            if viewModel.showSpinner {
                ProgressView().progressViewStyle(.circular )
            } else {
                Text(viewModel.article?.text ?? "No hay artículo")
            }
            
                
        }
    }
}
