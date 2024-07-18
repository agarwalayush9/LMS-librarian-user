//
//  NotificationScreen.swift
//  Shlves-Library
//
//  Created by Anay Dubey on 17/07/24.
//

import SwiftUI

struct NotificationScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Notifications")
                    .padding()
            }
            .navigationBarTitle("Notifications", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the modal
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
}

struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}
