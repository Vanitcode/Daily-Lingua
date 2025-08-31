//
//  FreeArticleByWeekView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 17/6/25.
//

import SwiftUI

struct FreeArticleByWeekView: View {
    
    @Bindable var viewModel: FreeArticleByWeekViewModel
    
    init(viewModel: FreeArticleByWeekViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Your free article for the week 2025-W23 is:")
            
            if viewModel.showSpinner {
                ProgressView().progressViewStyle(.circular )
            } else {
                Text(viewModel.article?.text ?? "No hay artículo")
            }
        }.onAppear() {
            viewModel.onAppear()
        }
    }
}
