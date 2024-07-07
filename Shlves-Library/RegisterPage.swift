//
//  RegisterPage.swift
//  Shlves-Library
//
//  Created by Ayush Agarwal on 04/07/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct RegisterPage: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToLogin = false

    var body: some View {
        HStack {
            if navigateToLogin {
                LoginPageView()
            } else {
                // Left side image
                Image("librarian")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right side form
                VStack(alignment: .leading, spacing: 20) {
                    // Logo and title
                    HStack {
                        Image("Logo")
                            .resizable()
                            .frame(width: 36.75, height: 37.5)
                        Text("Shelves")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red:0.4, green:0.2, blue:0.1)) // Assuming LogoColor is defined in Assets
                    }
                    
                    Text("Librarian Registration")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red:0.4, green:0.2, blue:0.1)) // Assuming TitleColor is defined in Assets
                    
                    Text("Please enter your details.")
                        .foregroundColor(Color(red:0.4, green:0.2, blue:0.1))
                    
                    // Name field
                    Text("Name")
                        .foregroundColor(Color.gray)
                    TextField("Enter your name", text: $name)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    
                    // Email field
                    Text("Email")
                        .foregroundColor(Color.gray)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                    
                    // Phone Number field
                    Text("Phone Number")
                        .foregroundColor(Color.gray)
                    TextField("Enter your number", text: $phoneNumber)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .padding(.bottom, 15)
                    
                    // Register button
                    Button(action: {
                        guard !name.isEmpty, !email.isEmpty, let phoneNumber1 = Int(phoneNumber) else {
                            alertMessage = "Please fill in all fields correctly."
                            showAlert = true
                            return
                        }
                        
                        let user = User(name: name, email: email, phoneNumber: phoneNumber1)
                        DataController.shared.addUser(user) { result in
                            switch result {
                            case .success:
                                alertMessage = "Registration successful!"
                            case .failure(let error):
                                alertMessage = error.localizedDescription
                            }
                            showAlert = true
                        }
                        
                        phoneNumber = ""
                        email = ""
                        name = ""
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red:0.4, green:0.2, blue:0.1)) // Assuming ButtonColor is defined in Assets
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                            if alertMessage == "Registration successful!" {
                                navigateToLogin = true
                            }
                        })
                    }
                    
                    // Login button
                    Button(action: {
                        navigateToLogin = true
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    RegisterPage()
}
