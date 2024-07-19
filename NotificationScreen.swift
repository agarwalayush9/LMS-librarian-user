import SwiftUI
import Combine

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading = false
    @Published var errorMessage: String?


    func fetchNotifications() {
        isLoading = true
        DataController.shared.fetchNotifications { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let notifications):
                    self?.notifications = notifications
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


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
        .background(Color.dashboardbg)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

import SwiftUI

struct NotificationScreen: View {
    @StateObject private var viewModel = NotificationViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Text("Notifications")
                    .font(.largeTitle)
                    .padding()

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.notifications) { notification in
                            NotificationCard(title: notification.title, message: notification.message)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(trailing: Button("Done") {
                // Dismiss the modal
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            })
            .onAppear {
                viewModel.fetchNotifications()
            }
        }
    }
}


struct NotificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationScreen()
    }
}

