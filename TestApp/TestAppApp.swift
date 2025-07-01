//
//  TestAppApp.swift
//  TestApp
//
//  Created by Jusung Han on 5/28/25.
//

import Firebase
import SwiftUI

@main
struct TestAppApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                NavigationStack {
                    UserProfileView()
                    //ContentView()
                        .environmentObject(authViewModel)
                }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
