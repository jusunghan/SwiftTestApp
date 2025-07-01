//
//  UserViewModel.swift
//  TestApp
//
//  Created by Jusung Han on 6/4/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var currentUser: User?
    private var db = Firestore.firestore()

    func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error)")
                return
            }

            guard let data = snapshot?.data() else {
                print("No user data found")
                return
            }

            let name = data["name"] as? String ?? "Unknown"
            let age = data["age"] as? Int ?? 0

            DispatchQueue.main.async {
                self.currentUser = User(id: uid, name: name, age: age)
            }
        }
    }
    
    // Admin methods
    // ✅ Create
    func addUser(name: String, age: Int) {
        db.collection("users").addDocument(data: [
            "name": name,
            "age": age
        ])
    }

    // ✅ Read
    func fetchUsers() {
            db.collection("users").getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching documents: \(error)")
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        print("No documents found.")
                        return
                    }

                    print("Fetched \(documents.count) users.")

                    self.users = documents.map { doc in
                        let data = doc.data()
                        print("Document: \(doc.documentID), data: \(data)")
                        return User(
                            id: doc.documentID,
                            name: data["name"] as? String ?? "Unknown",
                            age: data["age"] as? Int ?? 0
                        )
                    }
                }
    }

    // ✅ Update
    func updateUser(id: String, newAge: Int) {
        db.collection("users").document(id).updateData(["age": newAge])
    }

    // ✅ Delete
    func deleteUser(id: String) {
        db.collection("users").document(id).delete()
    }
}
