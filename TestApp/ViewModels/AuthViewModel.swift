//
//  AuthViewModel.swift
//  TestApp
//
//  Created by Jusung Han on 6/12/25.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false

    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
        Auth.auth().addStateDidChangeListener { _, user in
            self.isLoggedIn = user != nil
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            completion(error)
        }
    }
    
    func signUp(email: String, password: String, name: String, age: Int, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to create user:", error.localizedDescription)
                completion(error)
            } else if let user = result?.user {
                let userData = User(id: user.uid, name: name, age: age)
                UserService().createUserRecord(user: userData) { firestoreError in
                    completion(firestoreError)
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.isLoggedIn = false
    }
}
