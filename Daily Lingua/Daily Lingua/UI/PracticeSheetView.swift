//
//  PracticeSheetView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 29/6/25.
//

import SwiftUI

struct PracticeSheetView: View {
    
    @State private var viewModel: ArticleLocalAudiosPlayerViewModel
    
    init(viewModel: ArticleLocalAudiosPlayerViewModel) {
        self.viewModel = viewModel}
    
    var body: some View {
        VStack(spacing: 20) {
            let _ = Self._printChanges()
            Text(viewModel.showSpinner ? "Loading..." : "Ready")
            VStack {
                if viewModel.showSpinner {
                    Text("Loading audios...")
                } else {
                    if viewModel.articles.isEmpty {
                        Text("Something went wrong...")
                    } else {
                        Text(viewModel.articles[0].articleId)
                            .padding()
                            .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)}
                    }
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Audio Manager UI
            HStack(spacing: 30) {
                Button(action: {
                    Task {
                        if !viewModel.articles.isEmpty{
                            let urlString = viewModel.articles[0].article_path
                            viewModel.playAudio(url: urlString)
                    }
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    Task {
                        viewModel.stopAudio()
                    }
                }) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 20)
        }
        
        .onAppear() {
            print("Working with the ViewModel: \(viewModel.uuid)")
            viewModel.onAppear()
        }
        .navigationTitle("Práctica del artículo")
    }
}
