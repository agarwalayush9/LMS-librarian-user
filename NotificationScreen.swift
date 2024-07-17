//
//  NotificationScreen.swift
//  Shlves-Library
//
//  Created by Mohit Kumar Gupta on 17/07/24.
//

import SwiftUI

struct NotificationCard: View {
    var title: String
    var message: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 2)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Divider()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct NotificationScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .padding()

                ScrollView {
                    VStack(spacing: 10) {
                        NotificationCard(title: "Dummy Notification", message: "This is a dummy notification message.")
                        NotificationCard(title: "Another Notification", message: "This is another dummy notification message.")
                        // Add more NotificationCard views as needed
                    }
                    .padding()
                }
            }
            
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

