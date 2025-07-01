//
//  LoginView.swift
//  TestApp
//
//  Created by Jusung Han on 6/12/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var age = ""
    @State private var errorMessage = ""
    @State private var isSignUp = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isSignUp ? "Sign Up" : "Login")
                            .font(.largeTitle)

            if isSignUp {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(isSignUp ? "Create Account" : "Login") {
                if isSignUp {
                    guard let ageInt = Int(age) else {
                        errorMessage = "Please enter a valid age."
                        return
                    }

                    authViewModel.signUp(email: email, password: password, name: name, age: ageInt) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        }
                    }
                } else {
                    authViewModel.login(email: email, password: password) { error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            .padding()

            Button(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up") {
                isSignUp.toggle()
                errorMessage = ""
            }
            .font(.caption)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding()
    }
}
