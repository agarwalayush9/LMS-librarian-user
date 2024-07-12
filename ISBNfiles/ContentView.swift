import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var bookDetails: BookDetails?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            if let bookDetails = bookDetails {
                BookDetailView(book: bookDetails)
            } else {
                BarcodeScannerView(scannedCode: $scannedCode, onCodeScanned: fetchBookDetails)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func fetchBookDetails() {
        guard let scannedCode = scannedCode else { return }

        BookAPI.fetchDetails(isbn: scannedCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.bookDetails = details
                    self.showAlert = false // Reset showAlert if it was previously shown
                case .failure(let error):
                    if scannedCode.isEmpty {
                        self.alertMessage = "No barcode scanned."
                    } else {
                        self.alertMessage = self.errorMessage(from: error)
                    }
                    self.showAlert = true
                }
            }
        }
    }

    private func errorMessage(from error: APIError) -> String {
        switch error {
        case .invalidResponse:
            return "Failed to fetch book details: Invalid response from server."
        case .networkError(let error):
            return "Failed to fetch book details: Network error \(error.localizedDescription)"
        }
    }
}

struct CContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
