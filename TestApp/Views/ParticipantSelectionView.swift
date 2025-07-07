//
//  ParticipantSelectionView.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//

import SwiftUI

struct ParticipantSelectionView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var users: [User] = []
    @State private var selectedUserIds = Set<String>()
    private let userService = UserService()
    
    var onComplete: ([String]) -> Void
    
    var body: some View {
        NavigationView {
            List(users, id: \.id, selection: $selectedUserIds) { user in
                Text(user.name)
            }
            .navigationTitle("Select Participants")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        onComplete(Array(selectedUserIds))
                        dismiss()
                    }
                    .disabled(selectedUserIds.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                userService.fetchUsers { fetchedUsers in
                    // Optionally filter out current user here if you want
                    DispatchQueue.main.async {
                        self.users = fetchedUsers
                    }
                }
            }
            .environment(\.editMode, .constant(.active)) // enable multiple selection
        }
    }
}
