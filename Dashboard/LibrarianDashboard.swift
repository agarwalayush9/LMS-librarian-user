//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    @State private var showMenu = false
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Hello")
                    .font(.system(size: 40, weight: .heavy, design: .default ))
                    
            }
            .navigationTitle("Khvaab Library")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: "sidebar.left")
                    })
                }
            }
        }
    }
}

#Preview {
    LibrarianDashboard()
}
