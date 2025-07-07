//
//  ChatListViewModel.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//

import Foundation
import Combine
import FirebaseFirestore

class ChatListViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    private let _userId: String
    var userId: String { _userId }     // public read-only accessor    private let chatService = ChatService()
    private let chatService = ChatService()
    private var listener: ListenerRegistration?
    
    init(userId: String) {
        self._userId = userId
        listenForChats()
    }
    
    private func listenForChats() {
        listener = chatService.listenForChats(forUser: userId) { [weak self] rawChats in
            guard let self = self else { return }

            // Collect all participant IDs (excluding self)
            let allUserIds = Set(rawChats.flatMap { $0.participants }.filter { $0 != self.userId })

            self.chatService.resolveUsernames(for: Array(allUserIds)) { idToName in
                let enriched = rawChats.map { chat -> Chat in
                    var newChat = chat
                    let otherIds = chat.participants.filter { $0 != self.userId }
                    newChat.displayNames = otherIds.compactMap { idToName[$0] }
                    return newChat
                }

                DispatchQueue.main.async {
                    self.chats = enriched
                }
            }
        }
    }
    
    deinit {
        chatService.stopListening(listener)
    }
    
    func createChat(with participants: [String], completion: @escaping (String?) -> Void) {
        chatService.createChat(with: participants) { chatId in
            completion(chatId)
        }
    }
}
