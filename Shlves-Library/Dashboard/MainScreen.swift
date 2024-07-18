//
//  MainScreen.swift
//  Shlves-Library
//
//  Created by Anay Dubey on 17/07/24.
//

import SwiftUI

struct MainScreen: View {
    @State private var showModal = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Main Screen Content")
                    .padding()
            }
            .navigationBarTitle("Main Screen", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showModal.toggle()
            }) {
                Image(systemName: "bell")
                    .imageScale(.large)
            })
            .sheet(isPresented: $showModal) {
                NotificationScreen()
            }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
