//
//  EventsDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 10/07/24.
//

import SwiftUI

struct EventsDashboard: View {
    @State private var menuOpened = false
    var body: some View {
        NavigationStack {
            ZStack{
                Text("Hello")
                
                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                    .transition(.offset(x: menuOpened ? -UIScreen.main.bounds.width : 0))

                }

            }
            //navigation Bar Mark ~zek
            .navigationTitle("Manager Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation{
                            menuOpened.toggle()
                        }
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.black)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Add action for books vertical button
                    }, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.black)
                    })
                }
            }//Navigation bar ends    ~
        }
    }
    func toggleMenu() {
        withAnimation(.easeInOut){
        menuOpened.toggle()
        }
    }
}

#Preview {
    EventsDashboard()
}
