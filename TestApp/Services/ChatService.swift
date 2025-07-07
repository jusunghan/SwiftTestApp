//
//  ChatService.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//

import FirebaseFirestore
import Firebase

class ChatService {
    private let db = Firestore.firestore()
    func createChat(with participants: [String], completion: @escaping (String?) -> Void) {
        let chatRef = db.collection("chats").document() // new doc with auto ID
        let data: [String: Any] = [
            "participants": participants,
            "lastMessage": "",
            "lastUpdated": Timestamp()
        ]
        
        chatRef.setData(data) { error in
            if let error = error {
                print("Failed to create chat: \(error)")
                completion(nil)
            } else {
                completion(chatRef.documentID)
            }
        }
    }
    
    func listenForChats(forUser userId: String, completion: @escaping ([Chat]) -> Void) -> ListenerRegistration {
        // Query chats where user is a participant, ordered by lastUpdated desc
        let listener = db.collection("chats")
            .whereField("participants", arrayContains: userId)
            .order(by: "lastUpdated", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching chats: \(error?.localizedDescription ?? "unknown error")")
                    completion([])
                    return
                }
                
                let chats = documents.compactMap { doc -> Chat? in
                    let data = doc.data()
                    guard let participants = data["participants"] as? [String] else { return nil }
                    let lastMessage = data["lastMessage"] as? String
                    let lastUpdatedTimestamp = data["lastUpdated"] as? Timestamp
                    let lastUpdated = lastUpdatedTimestamp?.dateValue()
                    
                    return Chat(id: doc.documentID,
                                participants: participants,
                                lastMessage: lastMessage,
                                lastUpdated: lastUpdated)
                }
                completion(chats)
            }
        return listener
    }
    
    func stopListening(_ listener: ListenerRegistration?) {
        listener?.remove()
    }
    
    func resolveUsernames(for userIds: [String], completion: @escaping ([String: String]) -> Void) {
        guard !userIds.isEmpty else {
            completion([:])
            return
        }

        db.collection("users")
        .whereField(FieldPath.documentID(), in: userIds)
        .getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else {
                print("Error resolving user names: \(error?.localizedDescription ?? "unknown")")
                completion([:])
                return
            }

            let result = docs.reduce(into: [String: String]()) { dict, doc in
                let data = doc.data()
                print(data)
                let name = data["name"] as? String ?? "Unknown"
                dict[doc.documentID] = name
            }
            completion(result)
        }
    }
}
