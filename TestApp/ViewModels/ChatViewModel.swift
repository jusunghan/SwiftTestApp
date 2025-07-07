//
//  ChatViewModel.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//

import Firebase
import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageText: String = ""
    @Published var currentUserId: String
    
    private let chatId: String
    private let messageService = MessageService()
    
    private var listener: ListenerRegistration?
    
    init(chatId: String, currentUserId: String) {
        self.chatId = chatId
        self.currentUserId = currentUserId
        listenForMessages()
    }
    
    private func listenForMessages() {
        listener = messageService.listenForMessages(chatId: chatId) { [weak self] messages in
            DispatchQueue.main.async {
                self?.messages = messages
            }
        }
    }
    
    func sendMessage() {
        let trimmed = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messageService.sendMessage(chatId: chatId, message: trimmed, senderId: currentUserId) { [weak self] error in
            if error == nil {
                DispatchQueue.main.async {
                    self?.newMessageText = ""
                }
            }
        }
    }
    
    deinit {
        messageService.stopListening(listener)
    }
}
