//
//  Chat.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//
import Foundation

struct Chat: Identifiable {
    var id: String                // Firestore document ID
    var participants: [String]    // User IDs in this chat
    var lastMessage: String?      // Optional preview of last message
    var lastUpdated: Date?        // When last message was sent
    
    var displayNames: [String]? // optional names to be filled in
}
