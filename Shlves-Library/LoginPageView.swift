//
//  LoginPageView.swift
//  Shlves-Library
//
//  Created by Jhanvi Jindal on 03/07/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LoginPageView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false

    var body: some View {
        HStack {
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
                        .foregroundColor(Color(red:0.4,green:0.2,blue:0.1)) // Assuming LogoColor is defined in Assets
                }
                
                Text("Librarian Log in")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red:0.4,green:0.2,blue:0.1)) // Assuming TitleColor is defined in Assets
                
                Text("Welcome back Librarian! Please enter your details.")
                    .foregroundColor(Color(red:0.4,green:0.2,blue:0.1))
                
                // Email field
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(Color.gray)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
                
                // Password field
                VStack(alignment: .leading) {
                    Text("Password")
                        .foregroundColor(Color.gray)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                }
                
                // Remember me and forgot password
                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember for 30 days")
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    
                    Spacer()
                    
                    Button(action: {
                        // Forgot password action
                        // Implement what happens when forgot password is clicked
                        print("Ask Admin for another login credentials")
                        register()
                    }) {
                        Text("Forgot password")
                            .foregroundColor(Color.blue)
                    }
                }
                
                // Sign in button
                Button(action: {
                    // Sign in action
                    // Implement sign in functionality here
                    print("Sign in with email: \(email), password: \(password)")
                }) {
                    Text("Sign in")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor")) // Assuming ButtonColor is defined in Assets
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    func login()
    {
        Auth.auth().signIn(withEmail: email, password: password){
            firebaseResult, error in
            if let e = error {
                print("Invalid Password")
               
            }
            else {
                
            }
        }
    }
    
    func register()
    {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            }
            else {
                print("User signed up successfully")
            }
        }
    }
    
}



struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
