import SwiftUI

struct AddBookDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var bookTitle = ""
    @State private var author = ""
    @State private var genre = Genre.Fiction
    @State private var quantity = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
 
    var addBook: (Book) -> Void
    var books: [Book] // Pass existing books

    let genres: [Genre] = [
        .Horror, .Mystery, .Fiction, .Finance, .Fantasy, .Business, .Romance,
        .Psychology, .YoungAdult, .SelfHelp, .HistoricalFiction, .NonFiction,
        .ScienceFiction, .Literature
    ]
    
    var body: some View {
        VStack {
            Text("Enter Book Details")
                .font(.title)
                .padding()

            Form {
                TextField("Book Title", text: $bookTitle)
                TextField("Author", text: $author)
                Picker("Genre", selection: $genre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre.rawValue).tag(genre)
                    }
                }
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad) // Ensure numeric keyboard
            }

            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }

                Button(action: {
                    // Validate quantity input
                    guard let quantityValue = Int(quantity) else {
                        alertMessage = "Please enter a valid numeric quantity."
                        showAlert = true
                        return
                    }
                    
                    // Check if the book already exists
                    if books.contains(where: { $0.bookTitle == bookTitle && $0.author == author }) {
                        alertMessage = "A book with the same title and author already exists."
                        showAlert = true
                        return
                    }

                    let newBook = Book(
                        bookCode: "978-\(Int.random(in: 1000000...9999999))", // Generate random ISBN
                        bookCover: "book_cover",
                        bookTitle: bookTitle.isEmpty ? "Unknown Title" : bookTitle,
                        author: author.isEmpty ? "Unknown Author" : author,
                        genre: [genre],
                        issuedDate: "2024-05-01",
                        returnDate: "2024-06-01",
                        status: "Available",
                        quantity: quantityValue
                    )

                    DataController.shared.addBook(newBook) { result in
                        switch result {
                        case .success:
                            addBook(newBook)
                            presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            print("Failed to add book: \(error.localizedDescription)")
                            // Handle failure case as needed
                        }
                    }
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 500) // Limit the width of the pop-up
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
struct AddBookOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddBookDetails = false
    @State private var showingISBN = false
    var addBook: (Book) -> Void
    var books: [Book] // Pass existing books

    var body: some View {
        NavigationView {
            VStack {
                Text("Add Books")
                    .font(.custom("DMSans-ExtraBold", size: 32))
                    .fontWeight(.bold)
                   

                VStack(spacing: 30) {
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
                    .sheet(isPresented: $showingISBN) {
                        ContentView()
                    }

                    Button(action: {
                        // Action for Batch Upload
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
}


struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(red: 0.32, green: 0.23, blue: 0.06), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 255/255, green: 246/255, blue: 227/255)))
                    .frame(width: 25, height: 25)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color(red: 0.32, green: 0.23, blue: 0.06))
                        .frame(width: 20, height: 20)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = [] // Use @State to hold fetched books
    @State private var menuOpened = false
    
    var body: some View {
        NavigationStack {
//            List {
//                NavigationLink(destination: BooksCatalogue()) {
//                    Label("Shelves Library", systemImage: "books.vertical")
//                        .font(.title)
//                        .foregroundColor(.brown)
//                }
//                NavigationLink(destination: BooksCatalogue()) {
//                    Label("Book Catalogues", systemImage: "book")
//                        .font(.title2)
//                        .foregroundColor(.brown)
//                }
//            }
//            .listStyle(SidebarListStyle())
//            .navigationTitle("Shelves Library")
            
            ZStack {
                
                backgroundView()
                                    .ignoresSafeArea(.all)
                                    .blur(radius: menuOpened ? 10 : 0)
                                    .animation(.easeInOut(duration: 0.25), value: menuOpened)
                
                VStack {
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            HStack {
                                CheckBoxView(
                                    isChecked: Binding<Bool>(
                                        get: { selectedBooks.count == books.count },
                                        set: { isSelected in
                                            if isSelected {
                                                selectedBooks = Set(books.map { $0.id })
                                            } else {
                                                selectedBooks.removeAll()
                                            }
                                        }
                                    )
                                )
                                .frame(width: 50, alignment: .center)
                                
                                Text("Book Code")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Book Cover")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Book Title")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Author")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Genre/Category")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Issued Date")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Return Date")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Book Status")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Actions")
                                    .frame(maxWidth: 80, alignment: .leading)
                            }
                            .font(.headline)
                            .padding(.horizontal)
                            
                            Divider()
                            
                            ForEach(books) { book in
                                HStack {
                                    CheckBoxView(
                                        isChecked: Binding<Bool>(
                                            get: { selectedBooks.contains(book.id) },
                                            set: { isSelected in
                                                if isSelected {
                                                    selectedBooks.insert(book.id)
                                                } else {
                                                    selectedBooks.remove(book.id)
                                                }
                                            }
                                        )
                                    )
                                    .frame(width: 50, alignment: .center)
                                    
                                    Text(book.bookCode)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Image(book.bookCover)
                                        .resizable()
                                        .frame(width: 80, height: 115)
                                        .cornerRadius(5)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(book.bookTitle)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(book.author)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(book.genre.map { $0.rawValue }.joined(separator: ", "))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(book.issuedDate)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(book.returnDate)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(book.status)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(book.status == "Issued" ? .red : .green)
                                    
                                    HStack {
                                        Button(action: {
                                            // Action for edit button
                                        }) {
                                            Image(systemName: "pencil")
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Button(action: {
                                            // Action for more options
                                        }) {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .frame(maxWidth: 80, alignment: .leading)
                                    
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .background(selectedBooks.contains(book.id) ? Color(red: 255/255, green: 246/255, blue: 227/255) : Color.clear)
                                .border(Color(red: 0.32, green: 0.23, blue: 0.06), width: selectedBooks.contains(book.id) ? 2 : 0)
                                DottedDivider()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center the table
                    }
                }
                
                // Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingAddBookOptions.toggle()
                        }) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(.white)
                                Text("Add a Book")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(red: 0.32, green: 0.23, blue: 0.06))
                                    .stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 4)
                                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                            )
                        }
                        
                        
                        .padding(.trailing, 40)
                        .padding(.bottom, 25)
                        .sheet(isPresented: $showingAddBookOptions) {
                            AddBookOptionsView(addBook: { newBook in
                                // Append new book locally and update UI
                                books.append(newBook)
                            }, books: books)
                        }
                        
                    }
                    
                }
                //menuOpened here
                if menuOpened {
                                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30,
                                             menuOpened: menuOpened,
                                             toggleMenu: toggleMenu)
                                    .ignoresSafeArea()
                                    .toolbar(.hidden, for: .navigationBar)
                                    

                                }
            }
            // start here
            .navigationTitle("Book Catalogue".capitalized)
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
                        }
                        .onAppear {
                            // Fetch books from DataController
                            fetchBooks()
                        }
                        .navigationTitle("Books Catalogues")
            .font(.custom("DMSans_18pt-Medium", size: 17))
           //end here
        }
        
        
    }
    
    
    struct DottedDivider: View {
        var body: some View {
            HStack {
                ForEach(0..<150) { _ in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 2, height: 2)
                }
            }
        }
    }
    
    private func fetchBooks() {
        // Call DataController to fetch books asynchronously
        DataController.shared.fetchBooks { result in
            switch result {
            case .success(let fetchedBooks):
                // Update local state with fetched books
                self.books = fetchedBooks
            case .failure(let error):
                print("Failed to fetch books: \(error.localizedDescription)")
                // Handle error as needed
            }
        }
    }
    func toggleMenu(){
        menuOpened.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BooksCatalogue()
    }
}
