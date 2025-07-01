//
//  Untitled.swift
//  TestApp
//
//  Created by Jusung Han on 6/19/25.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel = UserViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignOutAlert = false

    var body: some View {
        VStack(spacing: 20) {
            if let user = viewModel.currentUser {
                Text("Welcome, \(user.name)!")
                    .font(.largeTitle)
                Text("Age: \(user.age)")
                    .font(.title2)
                    .foregroundColor(.gray)
                Button("Sign Out") {
                    // Show confirmation alert instead of signing out directly
                    showSignOutAlert = true
                }
                .alert(isPresented: $showSignOutAlert) {
                    Alert(
                        title: Text("Confirm Sign Out"),
                        message: Text("Are you sure you want to sign out?"),
                        primaryButton: .destructive(Text("Sign Out")) {
                            authViewModel.signOut()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                NavigationLink(destination: UploadView()) {
                    Text("Go to Upload")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            } else {
                ProgressView("Loading profile...")
            }
        }
        .onAppear {
            viewModel.fetchCurrentUser()
        }
        .navigationTitle("My Profile")
        .padding()
    }
}
