//
//  UserService.swift
//  TestApp
//
//  Created by Jusung Han on 6/12/25.
//

import FirebaseFirestore

class UserService {
    private let db = Firestore.firestore()
    
    func createUserRecord(user: User, completion: @escaping (Error?) -> Void) {
        do {
            let userData: [String: Any] = [
                "id": user.id,
                "name": user.name,
                "age": user.age
            ]
            db.collection("users").document(user.id).setData(userData, merge: true, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
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

            let users = documents.map { doc in
                let data = doc.data()
                print("Document: \(doc.documentID), data: \(data)")
                return User(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "Unknown",
                    age: data["age"] as? Int ?? 0
                )
            }
            
            completion(users)
        }
    }

}
