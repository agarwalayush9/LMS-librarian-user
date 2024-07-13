import SwiftUI

struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = []
    @State private var menuOpened = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    // Background view with blur effect when menu is opened
                    backgroundView()
                        .blur(radius: menuOpened ? 10 : 0)
                        .animation(.easeInOut(duration: 0.25), value: menuOpened)
                    
                    // Main content stack
                    VStack {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                // Header row
                                headerRow()
                                
                                // Book rows
                                ForEach(books) { book in
                                    bookRow(book)
                                        .background(selectedBooks.contains(book.id) ? Color(red: 255/255, green: 246/255, blue: 227/255) : Color.clear)
                                        .border(Color(red: 0.32, green: 0.23, blue: 0.06), width: selectedBooks.contains(book.id) ? 2 : 0)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                        .onTapGesture {
                                            toggleSelection(for: book)
                                        }
                                        .transition(.slide)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    // Floating Add button
                    floatingAddButton()
                }
                
                // Side menu
                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30, menuOpened: menuOpened, toggleMenu: toggleMenu)
                        .ignoresSafeArea()
                        .toolbar(.hidden, for: .navigationBar)
                }
            }
            .navigationTitle("Book Catalogue".capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            menuOpened.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add action for books vertical button
                    }) {
                        Image(systemName: "books.vertical")
                            .foregroundColor(.black)
                    }
                }
            }
            .onAppear {
                fetchBooks()
            }
        }
    }
    
    // MARK: - Subviews
    
    private func headerRow() -> some View {
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
        .transition(.slide)
    }
    
    private func bookRow(_ book: Book) -> some View {
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
            AsyncImageLoader(url: book.bookCover)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(book.bookTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(book.author)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(book.genre.rawValue)
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
        .padding(.horizontal)
        .transition(.slide)
    }
    
    private func floatingAddButton() -> some View {
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
                        books.append(newBook)
                    }, books: books)
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
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
    
    private func toggleMenu() {
        menuOpened.toggle()
    }
    
    private func toggleSelection(for book: Book) {
        if selectedBooks.contains(book.id) {
            selectedBooks.remove(book.id)
        } else {
            selectedBooks.insert(book.id)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BooksCatalogue()
    }
}
