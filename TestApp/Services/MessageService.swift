//
//  MessageService.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//
import FirebaseFirestore
import Firebase

class MessageService {
    private let db = Firestore.firestore()
    
    func listenForMessages(chatId: String, completion: @escaping ([Message]) -> Void) -> ListenerRegistration {
        let listener = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "unknown error")")
                    completion([])
                    return
                }
                
                let messages = documents.compactMap { doc -> Message? in
                    let data = doc.data()
                    guard
                        let text = data["text"] as? String,
                        let senderId = data["senderId"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else {
                        return nil
                    }
                    return Message(id: doc.documentID,
                                   text: text,
                                   senderId: senderId,
                                   timestamp: timestamp.dateValue())
                }
                completion(messages)
            }
        return listener
    }
    
    func sendMessage(chatId: String, message: String, senderId: String, completion: ((Error?) -> Void)? = nil) {
        let messageData: [String: Any] = [
            "text": message,
            "senderId": senderId,
            "timestamp": Timestamp()
        ]
        
        db.collection("chats")
            .document(chatId)
            .collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                } else {
                    // Update last message on chat doc
                    self.db.collection("chats")
                        .document(chatId)
                        .updateData([
                            "lastMessage": message,
                            "lastUpdated": Timestamp()
                        ])
                }
                completion?(error)
            }
    }
    
    func stopListening(_ listener: ListenerRegistration?) {
        listener?.remove()
    }
}
