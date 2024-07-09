//
//  Shlves_LibraryApp.swift
//  Shlves-Library
//
//  Created by Ayush Agarwal on 03/07/24.
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

@main
struct Shlves_LibraryApp: App {
    // Register AppDelegate for Firebase setup
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                        LibrarianDashboard(isLoggedIn: $isLoggedIn)
                    } else {
                        LoginPageView(isLoggedIn: $isLoggedIn) 
                    }
       }
    }
}
