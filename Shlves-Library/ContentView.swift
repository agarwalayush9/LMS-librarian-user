//
//  ContentView.swift
//  Barcode
//
//  Created by Mohit Kumar Gupta on 11/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var scannedCode: String?
    @State private var book: Book?
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @ObservedObject var dataController = DataController.shared // Use the shared instance of DataController
    
    var body: some View {
        VStack {
            if let book = book {
                BookDetailView(book: book)
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
        
        // Call API to fetch book details using scannedCode (ISBN, etc.)
        BookAPI.fetchDetails(isbn: scannedCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let book):
                    self.book = book
                    self.showAlert = false // Reset showAlert if it was previously shown
                    self.addBookToDatabase(book)
                case .failure(let error):
                    // Show error only if the scannedCode was valid but API fetch failed
                    if scannedCode.isEmpty {
                        // If scannedCode is empty, it means no valid barcode was scanned
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
    
    private func addBookToDatabase(_ book: Book) {
        dataController.addBook(book) { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    print("Book added to database successfully.")
                case .failure(let error):
                    self.alertMessage = "Failed to add book to database: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
}

struct CContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
