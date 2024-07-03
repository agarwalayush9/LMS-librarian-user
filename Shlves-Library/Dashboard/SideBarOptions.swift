//
//  SideBarOptions.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import SwiftUI

struct SideBarOptions: View {
    var body: some View {
        VStack{
            Text("Librarian")
                .font(.system(size: 34, weight: .bold, design: .default))
            
            SideMenuBarOptions(optionName: "Overview")
            SideMenuBarOptions(optionName: "Books Inventory")
            LineSeparator()
            Spacer()
            ContactAdminButton()
            
            LibrarianProfile(userName: "Ankit Verma",
                             post: "Librarian",
                              porfileImage: "person.fill"  )
            
        }
    }}

#Preview {
    SideBarOptions()
}
struct SideMenuBarOptions : View {
    
    var optionName : String
    
    var body: some View {
        Text("\(optionName)")
            .font(.system(size: 17, weight: .regular, design: .default))
            .padding(.vertical, 10)
    }
}

struct ContactAdminButton : View {
    var body: some View {
        
        HStack{
            Image(systemName: "headphones")
                .padding(.leading, 8)
            Text("Contact Admin")
                .font(.system(size: 17, weight: .regular, design: .default))
                .padding(.all, 4)
        }
        .padding(.all, 11)
        .frame(width: 232, alignment: .leading)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(Color(red: 0.96, green: 0.35, blue: 0.4), lineWidth: 1)
        )
    }
}

struct LineSeparator : View {
    var body: some View {
        Image(systemName: "Line 2")
            .background(Color.red)
    }
}

struct LibrarianProfile: View {
    var userName : String
    var post : String
    var porfileImage : String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 320, height: 110)
                .foregroundColor(.clear)
                .background(
                )
            HStack(){
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.clear)
                    .background(
                        Image(systemName: "\(porfileImage)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipped()
                    )
                    .cornerRadius(40)
                VStack{
                    Text(userName)
                        .font(.system(size: 16,
                                      weight: .bold,
                                      design: .default))
                        .foregroundStyle(Color.black)
                        .frame(width: .infinity,alignment: .topLeading)
                    Text(post)
                        .font(.system(size: 16,
                                      weight: .bold,
                                      design: .default))
                        .foregroundStyle(Color.gray)
                        .frame(width: .infinity,alignment: .topLeading)

                }
            }
        }
                
        
    }
}
