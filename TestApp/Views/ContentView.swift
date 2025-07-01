//
//  ContentView.swift
//  TestApp
//
//  Created by Jusung Han on 5/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name = ""
    @State private var age = ""
    @State private var showSignOutAlert = false

    var body: some View {
        NavigationView {
            VStack {
                // Input Fields
                HStack {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Age", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    Button("Add") {
                        if let ageInt = Int(age) {
                            viewModel.addUser(name: name, age: ageInt)
                            name = ""
                            age = ""
                            viewModel.fetchUsers()
                        }
                    }
                    Button("Sign Out") {
                        // Show confirmation alert instead of signing out directly
                        showSignOutAlert = true
                    }
                    .alert(isPresented: $showSignOutAlert) {
                        Alert(
                            title: Text("Confirm Sign Out"),
                            message: Text("Are you sure you want to sign out?"),
                            primaryButton: .destructive(Text("Sign Out")) {
                                authViewModel.signOut()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }.padding()

                // User List
                List {
                    ForEach(viewModel.users) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.name)
                                Text("Age: \(user.age)").font(.subheadline).foregroundColor(.gray)
                            }
                            Spacer()
                            HStack(spacing: 12) {
                                Button(action: {
                                    viewModel.updateUser(id: user.id, newAge: user.age + 1)
                                    viewModel.fetchUsers()
                                }) {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(.plain)

                                Button(action: {
                                    viewModel.deleteUser(id: user.id)
                                    viewModel.fetchUsers()
                                }) {
                                    Image(systemName: "trash.circle")
                                        .font(.title2)
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .contentShape(Rectangle()) // prevent accidental tap forwardin
                    }
                }
            }
            .navigationTitle("Users")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    ContentView()
}
