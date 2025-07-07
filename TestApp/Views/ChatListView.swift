//
//  ChatListView.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject private var viewModel: ChatListViewModel
    @State private var showParticipantSelection = false
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ChatListViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.chats) { chat in
                NavigationLink(destination: ChatView(chatId: chat.id, currentUserId: viewModel.userId)) {
                    ChatRowView(chat: chat, currentUserId: viewModel.userId)
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showParticipantSelection = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                    .accessibilityLabel("New Chat")
                }
            }
            .sheet(isPresented: $showParticipantSelection) {
                ParticipantSelectionView { selectedIds in
                    var participants = selectedIds
                    participants.append(viewModel.userId)  // Add yourself
                    
                    viewModel.createChat(with: participants) { newChatId in
                        if let chatId = newChatId {
                            showParticipantSelection = false
                            // Optionally navigate to new chat
                        }
                    }
                }
            }
        }
    }
}

struct ChatRowView: View {
    let chat: Chat
    let currentUserId: String
    
    var body: some View {
        HStack {
            // For demo: show number of participants except current user
            Text(chat.displayNames?.joined(separator: ", ") ?? "Loading...")
            .font(.headline)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(chat.lastMessage ?? "No messages yet")
                    .lineLimit(1)
                    .foregroundColor(.primary)
                if let date = chat.lastUpdated {
                    Text(date, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 150, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}
