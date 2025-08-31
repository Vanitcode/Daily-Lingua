//
//  Daily_LinguaApp.swift
//  Daily Lingua
//
//  Created by Jose Carlos Valenzuela Nieto on 28/5/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


//Vistas temporales hasta que tenga su Factory
let reportsView = ReportsView()
let userView = UserView()

@main
struct Daily_LinguaApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView(reportsView: reportsView, userView: userView, mainPageArticlesView: MainPageFactory.create())
        }
    }
}
