//
//  AddBookOptionsView.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 12/07/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddBookOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddBookDetails = false
    @State private var showingISBN = false
    @State private var showingDocumentPicker = false //New state variable
    var addBook: (Book) -> Void
    var books: [Book] // Pass existing books
    
    
    

    var body: some View {
        NavigationView {
            VStack {
                Text("Add Books")
                    .font(.custom("DMSans-ExtraBold", size: 32))
                    .fontWeight(.bold)

                VStack(spacing: 30) {
                    NavigationLink(destination: ContentView(), isActive: $showingISBN) {
                        Button(action: {
                            // Action for ISBN Code Scanning
                            showingISBN = true
                        }) {
                            VStack {
                                Image(systemName: "barcode.viewfinder")
                                    .font(.system(size: 65))
                                    .foregroundColor(.black)
                                    .padding(.bottom)

                                Text("Using ISBN Code Scanning")
                                    .font(.custom("DMSans-Bold", size: 20))
                                    .foregroundColor(.black)
                            }
                            .padding(.all, 20)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3))
                        }
                    }

                    Button(action: {
                        // Show document picker
                        showingDocumentPicker = true
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 65))
                                .foregroundColor(.black)
                                .padding(.bottom)
                            Text("Batch Upload (CSV, Spreadsheet)")
                                .font(.custom("DMSans-Bold", size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.all, 20)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3))
                    }
                    .sheet(isPresented: $showingDocumentPicker) {
                        DocumentPickerView(didPickFile: handleDocumentPicked)
                    }

                    Button(action: {
                        showingAddBookDetails = true
                    }) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 65))
                                .foregroundColor(.black)
                                .padding(.bottom)
                            Text("Enter Details Manually")
                                .font(.custom("DMSans-Bold", size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.all, 20)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3))
                    }
                    .sheet(isPresented: $showingAddBookDetails) {
                        AddBookDetailsView(addBook: addBook, books: books)
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: 500) // Limit the width of the pop-up
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }

    private func handleDocumentPicked(_ url: URL) {
        // Handle the selected document URL (e.g., parse the CSV or spreadsheet file)
        do {
            let data = try Data(contentsOf: url)
            if url.pathExtension == "csv" {
                parseCSV(data)
            } else {
                // Handle spreadsheet parsing if needed
            }
        } catch {
            print("Failed to read file: \(error.localizedDescription)")
        }
    }

    private func parseCSV(_ data: Data) {
        // Parse the CSV data and add books
        let content = String(data: data, encoding: .utf8) ?? ""
        let rows = content.split(separator: "\n")
        for row in rows {
            let columns = row.split(separator: ",")
            if columns.count >= 9 {
                let book = Book(
                    id: UUID(),
                    bookCode: String(columns[0]),
                    bookCover: String(columns[1]),
                    bookTitle: String(columns[2]),
                    author: String(columns[3]),
                    genre: Genre(rawValue: String(columns[4])) ?? .Fiction,
                    issuedDate: String(columns[5]),
                    returnDate: String(columns[6]),
                    status: String(columns[7]),
                    quantity: Int(columns[8]) ?? 0,
                    publisher: String(columns[9]),
                    publishedDate: String(columns[10]),
                    pageCount: Int(columns[11]) ?? 0,
                    averageRating: Double(columns[12]) ?? 0.0
                )
                addBook(book)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddBookOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookOptionsView(addBook: { _ in }, books: [])
    }
}


class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    var parent: DocumentPickerView

    init(parent: DocumentPickerView) {
        self.parent = parent
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        parent.didPickFile(selectedFileURL)
    }
}

struct DocumentPickerView: UIViewControllerRepresentable {
    var didPickFile: (URL) -> Void

    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.commaSeparatedText, UTType.spreadsheet])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
