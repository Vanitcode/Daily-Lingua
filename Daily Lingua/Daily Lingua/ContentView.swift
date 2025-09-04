//
//  ContentView.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 28/5/25.
//

import SwiftUI

struct ContentView: View {
    let reportsView: ReportsView
    let userView: UserView
    let mainPageArticlesView: MainPageArticlesView
    let recordingSessionView: RecordingSessionView
    
    var body: some View {
        TabView {
            Tab("Reports", systemImage: "list.dash") {
                reportsView
            }
            Tab ("MainPageArticles", systemImage: "voiceover") {
                mainPageArticlesView
            }
            Tab ("User", systemImage: "person") {
                userView
            }
            Tab ("Testing features", systemImage: "wrench.and.screwdriver" ) {
                recordingSessionView
            }
        }
    }
}
