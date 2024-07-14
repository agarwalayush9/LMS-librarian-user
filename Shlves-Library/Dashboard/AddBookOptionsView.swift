import SwiftUI
import UniformTypeIdentifiers

struct AddBookOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddBookDetails = false
    @State private var showingISBN = false
    @State private var showingDocumentPicker = false
    @State private var showingCSVBookPreview = false
    @State private var parsedBooks: [Book] = []
    @State private var errorMessage: String?
    @State private var showAlert = false
    var addBook: (Book) -> Void
    var books: [Book]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Books")
                    .font(.custom("DMSans-ExtraBold", size: 32))
                    .fontWeight(.bold)
                VStack(spacing: 30) {
                    NavigationLink(destination: ContentView(), isActive: $showingISBN) {
                        Button(action: {
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
                    .sheet(isPresented: $showingCSVBookPreview) {
                        CSVBookPreviewView(books: parsedBooks, addBook: addBook)
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
            .frame(maxWidth: 500)
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func handleDocumentPicked(_ url: URL) {
        do {
            guard url.startAccessingSecurityScopedResource() else {
                errorMessage = "Couldn't access the file."
                showAlert = true
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }
            
            let data = try Data(contentsOf: url)
            print("Data loaded from file:", String(data: data, encoding: .utf8) ?? "nil")  // Debug print
            if url.pathExtension == "csv" {
                parseCSV(data)
            } else {
                errorMessage = "Unsupported file type. Only CSV files are supported."
                showAlert = true
            }
        } catch {
            errorMessage = "Failed to read file: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    private func parseCSV(_ data: Data) {
        let content = String(data: data, encoding: .utf8) ?? ""
        print("CSV content:", content)  // Debug print
        let rows = content.split(separator: "\n")
        var books = [Book]()
        
        for row in rows {
            let columns = row.split(separator: ",", omittingEmptySubsequences: false)
            if columns.count >= 4 {  // Check for minimum necessary columns
                let book = Book(
                    id: UUID(),
                    bookCode: String(columns[safe: 0] ?? ""),
                    bookCover: String(columns[safe: 1] ?? ""),
                    bookTitle: String(columns[safe: 2] ?? ""),
                    author: String(columns[safe: 3] ?? ""),
                    genre: Genre(rawValue: String(columns[safe: 4] ?? "")) ?? .Fiction,
                    issuedDate: String(columns[safe: 5] ?? ""),
                    returnDate: String(columns[safe: 6] ?? ""),
                    status: String(columns[safe: 7] ?? ""),
                    quantity: Int(columns[safe: 8] ?? "") ?? 0,
                    //                    publisher: columns[safe: 9] ?? "",
                    //                    publishedDate: columns[safe: 10] ?? "",
                    pageCount: Int(columns[safe: 11] ?? "") ?? 0,
                    averageRating: Double(columns[safe: 12] ?? "") ?? 0.0
                )
                books.append(book)
            } else {
                print("Skipping row: \(row) due to insufficient columns.")
            }
        }
        
        print("Parsed books:", books)  // Debug print
        parsedBooks = books
        if parsedBooks.isEmpty {
            errorMessage = "No valid books found in the CSV file."
            showAlert = true
        } else {
            showingCSVBookPreview = true
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
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            let documentTypes = [UTType.commaSeparatedText.identifier, UTType.spreadsheet.identifier]
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: documentTypes.map { UTType($0)! })
            picker.delegate = context.coordinator
            picker.allowsMultipleSelection = false
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
        
        class Coordinator: NSObject, UIDocumentPickerDelegate {
            var parent: DocumentPickerView
            
            init(_ parent: DocumentPickerView) {
                self.parent = parent
            }
            
            func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                guard let selectedFileURL = urls.first else { return }
                parent.didPickFile(selectedFileURL)
            }
            
            func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                // Handle the cancellation if needed
            }
        }
    }
    
    
    struct CSVBookPreviewView: View {
        let books: [Book]
        var addBook: (Book) -> Void
        @Environment(\.presentationMode) var presentationMode
        @State private var selectedBooks = Set<UUID>()
        
        var body: some View {
            VStack {
                Text("Select Books to Add")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top)
                
                List(selection: $selectedBooks) {
                    ForEach(books, id: \.id) { book in
                        HStack() {
                            Text(book.bookCode)
                                .font(.headline)
                            Text(book.bookTitle)
                                .font(.subheadline)
                            Text(book.author)
                                .font(.subheadline)
                            
                            
                        }
                        .padding(.vertical, 10)
                    }
                }
                .listStyle(.plain) // Ensures the list doesn't use a sidebar style
                
                HStack {
                    Spacer()
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    
                    Button("Add") {
                        for id in selectedBooks {
                            if let book = books.first(where: { $0.id == id }) {
                                addBook(book)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .disabled(selectedBooks.isEmpty)
                    
                    Spacer()
                }
                .padding(.bottom)
            }
            .padding()
        }
    }
    
    
    
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
