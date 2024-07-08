//
//  UserRecord.swift
//  Shlves-Library
//
//  Created by Mohit Kumar Gupta on 08/07/24.
//

import SwiftUI

struct EditUserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username: String
    @State private var emailID: String
    @State private var membership: String
    @State private var phoneNumber: String
    
    var user: LibraryUser
    var updateUser: (LibraryUser) -> Void
    
    init(user: LibraryUser, updateUser: @escaping (LibraryUser) -> Void) {
        self.user = user
        self._username = State(initialValue: user.username)
        self._emailID = State(initialValue: user.emailID)
        self._membership = State(initialValue: user.membership)
        self._phoneNumber = State(initialValue: user.phoneNumber)
        self.updateUser = updateUser
    }
    
    var body: some View {
        VStack {
            Text("Edit User Details")
                .font(.title)
                .padding()

            Form {
                TextField("Username", text: $username)
                TextField("Email ID", text: $emailID)
                TextField("Membership", text: $membership)
                TextField("Phone Number", text: $phoneNumber)
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    var updatedUser = user
                    updatedUser.username = username
                    updatedUser.emailID = emailID
                    updatedUser.membership = membership
                    updatedUser.phoneNumber = phoneNumber
                    updateUser(updatedUser)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 500) // Limit the width of the pop-up
    }
}

struct AddUserDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var emailID = ""
    @State private var membership = ""
    @State private var phoneNumber = ""
    
    var addUser: (LibraryUser) -> Void
    
    var body: some View {
        VStack {
            Text("Enter User Details")
                .font(.title)
                .padding()

            Form {
                TextField("Username", text: $username)
                TextField("Email ID", text: $emailID)
                TextField("Membership", text: $membership)
                TextField("Phone Number", text: $phoneNumber)
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    let newUser = LibraryUser(id: Int.random(in: 1...1000), username: username, emailID: emailID, membership: membership, phoneNumber: phoneNumber, lastIssuedBook: "None", charges: "0", memberSince: "2023-01-01")
                    addUser(newUser)
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 500) // Limit the width of the pop-up
    }
}

struct LibraryUser: Identifiable {
    let id: Int
    var username: String
    var emailID: String
    var membership: String
    var phoneNumber: String
    var lastIssuedBook: String
    var charges: String
    var memberSince: String
}

struct UsersCatalogue: View {
    @State private var selectedUsers = Set<Int>()
    @State private var showingAddUserDetails = false
    @State private var showingEditUserDetails = false
    @State private var userToEdit: LibraryUser?

    @State private var users = [
        LibraryUser(id: 1, username: "John Doe", emailID: "john@example.com", membership: "Gold", phoneNumber: "0123456789", lastIssuedBook: "Harry Potter", charges: "Rs 0", memberSince: "2022-01-01"),
        LibraryUser(id: 2, username: "Jane Smith", emailID: "jane@example.com", membership: "Silver", phoneNumber: "0123456789", lastIssuedBook: "The Hobbit", charges: "Rs 5", memberSince: "2023-02-02"),
        // Add more users here
    ]

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: UsersCatalogue()) {
                    Label("Khvaab Library", systemImage: "books.vertical")
                        .font(.title)
                        .foregroundColor(.brown)
                }
                NavigationLink(destination: UsersCatalogue()) {
                    Label("User Catalogues", systemImage: "person")
                        .font(.title2)
                        .foregroundColor(.brown)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Khvaab Library")
            
            ZStack {
                VStack {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            HStack {
                                CheckBoxView(
                                    isChecked: Binding<Bool>(
                                        get: { selectedUsers.count == users.count },
                                        set: { isSelected in
                                            if isSelected {
                                                selectedUsers = Set(users.map { $0.id })
                                            } else {
                                                selectedUsers.removeAll()
                                            }
                                        }
                                    )
                                )
                                .frame(width: 50, alignment: .center)
                                
                                Text("User ID")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Username")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Email ID")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Membership")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Phone Number")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Last Issued Book")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Charges")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Member Since")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Actions")
                                    .frame(maxWidth: 80, alignment: .leading)
                            }
                            .font(.headline)
                            .padding(.horizontal)
                            
                            Divider()
                            
                            ForEach(users) { user in
                                HStack {
                                    CheckBoxView(
                                        isChecked: Binding<Bool>(
                                            get: { selectedUsers.contains(user.id) },
                                            set: { isSelected in
                                                if isSelected {
                                                    selectedUsers.insert(user.id)
                                                } else {
                                                    selectedUsers.remove(user.id)
                                                }
                                            }
                                        )
                                    )
                                    .frame(width: 50, alignment: .center)
                                    
                                    Text("\(user.id)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.username)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.emailID)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.membership)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.phoneNumber)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.lastIssuedBook)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.charges)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(user.memberSince)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    HStack {
                                        Button(action: {
                                            userToEdit = user
                                            showingEditUserDetails = true
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Button(action: {}) {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.blue)
                                        }
                                        .contextMenu {
                                            Button(action: {
                                                if let index = users.firstIndex(where: { $0.id == user.id }) {
                                                    users.remove(at: index)
                                                }
                                            }) {
                                                Text("Delete")
                                                Image(systemName: "trash")
                                            }
                                        }
                                    }
                                    .frame(maxWidth: 80, alignment: .leading)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(selectedUsers.contains(user.id) ? Color(red: 255/255, green: 246/255, blue: 227/255) : Color.clear)
                                .border(Color(red: 0.32, green: 0.23, blue: 0.06), width: selectedUsers.contains(user.id) ? 2 : 0)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center the table
                    }
                }
                
                // Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddUserDetails.toggle()
                        }) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                Text("Add a User")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(red: 0.32, green: 0.23, blue: 0.06))
                                    .stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 4)
                                    .shadow(color: .gray, radius: 5, x: 0, y: 2)
                            )
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                        .sheet(isPresented: $showingAddUserDetails) {
                            AddUserDetailsView { newUser in
                                users.append(newUser)
                            }
                        }
                    }
                }
            }
            .navigationTitle("User Catalogues")
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .sheet(item: $userToEdit) { user in
            EditUserDetailsView(user: user) { updatedUser in
                if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
                    users[index] = updatedUser
                }
            }
        }
    }
}

struct ContentVieww_Previews: PreviewProvider {
    static var previews: some View {
        UsersCatalogue()
    }
}
