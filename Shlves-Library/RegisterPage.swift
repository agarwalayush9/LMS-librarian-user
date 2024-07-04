//
//  RegisterPage.swift
//  Shlves-Library
//
//  Created by Ayush Agarwal on 04/07/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct RegisterPage: View {
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var phoneNumber: String = ""

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
                
                Text("Librarian Registration")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red:0.4,green:0.2,blue:0.1)) // Assuming TitleColor is defined in Assets
                
                Text("Please enter your details.")
                    .foregroundColor(Color(red:0.4,green:0.2,blue:0.1))
                
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
                
                
                // Password field
                
                    Text("Phone Number")
                        .foregroundColor(Color.gray)
                    TextField("Enter your number", text: $phoneNumber)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8).padding(.bottom, 15)
                
                
                Button(action: {
                    
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red:0.4,green:0.2,blue:0.1)) // Assuming ButtonColor is defined in Assets
                        .cornerRadius(8)
                }
                
                
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
    
    
}





#Preview {
    RegisterPage()
}
