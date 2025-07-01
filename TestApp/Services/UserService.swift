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
}
