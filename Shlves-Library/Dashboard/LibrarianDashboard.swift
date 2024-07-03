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
            ZStack{
                VStack{
                    Text("Hello, Ankit!")
                      .font(
                        Font.custom("DM Sans", size: 48)
                          .weight(.medium)
                      )
                      .foregroundColor(.black)
                      .frame(maxWidth: .infinity, alignment: .topLeading)
                
            }
                
                sideMenuBar(isShowing: $showMenu)
        }
            .toolbar(showMenu ? .hidden : .visible,
                     for: .navigationBar)
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
        .background(ignoresSafeAreaEdges: .all)
    }
}

#Preview {
    LibrarianDashboard()
}
