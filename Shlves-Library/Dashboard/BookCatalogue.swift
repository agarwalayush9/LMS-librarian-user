import SwiftUI

struct EditBookView: View {
  @Environment(\.presentationMode) var presentationMode
  @State private var editedBook: Book

  init(book: Book) {
    _editedBook = State(wrappedValue: book)
  }

  var body: some View {
    NavigationView {
      Form {
        TextField("Book Code", text: $editedBook.bookCode)
        TextField("Book Title", text: $editedBook.bookTitle)
        TextField("Author", text: $editedBook.author)
        // ... similar TextFields for other editable properties
        Button("Save") {
          // Update book details using DataController
          // Dismiss edit view
          presentationMode.wrappedValue.dismiss()
        }
      }
      .navigationTitle("Edit Book")
    }
  }
}


struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = []
    @State private var menuOpened = false
    @State private var isLoading = false
    @State private var selectedBook: Book?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ZStack {
                        // Background view with blur effect when menu is opened
                        backgroundView()
                            .blur(radius: menuOpened ? 10 : 0)
                            .animation(.easeInOut(duration: 0.25), value: menuOpened)
                        
                        // Main content stack
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
                                        .onLongPressGesture {
                                            selectedBook = book
                                        }
                                        .transition(.scale)
                                }
                            }
                            .frame(maxWidth: .infinity) // Ensuring LazyVStack takes full width
                        }
                        .frame(maxWidth: .infinity) // Ensuring ScrollView takes full width
                        .refreshable {
                            await refreshBooks()
                        }
                    }
                    .frame(maxWidth: .infinity) // Ensuring ZStack takes full width
                    
                    // Floating Add button
                    
                }
                .frame(maxWidth: .infinity) // Ensuring VStack takes full width
                
                // Side menu
                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30, menuOpened: menuOpened, toggleMenu: toggleMenu)
                        .ignoresSafeArea()
                        .toolbar(.hidden, for: .navigationBar)
                }
                
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding().frame(width: 140, height: 80)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                
                floatingAddButton()
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
                Task {
                    await fetchBooks()
                }
            }
            
            .sheet(item: $selectedBook) { book in
              EditBookView(book: book)
                .onDisappear {
                  // Update books array with edited book details (if saved)
                  if let index = books.firstIndex(where: { $0.id == book.id }) {
                      books[index] = selectedBook ?? book
                  }
                }
            }

            
        }
        .frame(maxWidth: .infinity) // Ensuring NavigationStack takes full width
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
        .frame(maxWidth: .infinity)
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
                    selectedBook = book
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .frame(width: 70,alignment: .center)
                        .fontWeight(.bold)
                }
       
            }
            .frame(maxWidth: 80, alignment: .leading)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
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
    
    private func refreshBooks() async {
        isLoading = true
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        await fetchBooks()
        isLoading = false
    }
    
    private func fetchBooks() async {
        isLoading = true
        // Call DataController to fetch books asynchronously
        await DataController.shared.fetchBooks { result in
            switch result {
            case .success(let fetchedBooks):
                // Update local state with fetched books
                self.books = fetchedBooks
            case .failure(let error):
                print("Failed to fetch books: \(error.localizedDescription)")
                // Handle error as needed
            }
            isLoading = false
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

struct BookDetailsView: View {
    let book: Book
    
    var body: some View {
        VStack(spacing: 20) {
            Text(book.bookTitle)
                .font(.largeTitle)
                .padding()
            
            AsyncImageLoader(url: book.bookCover)
                .frame(width: 150, height: 200)
            
            Text("Author: \(book.author)")
            Text("Genre: \(book.genre.rawValue)")
            Text("Issued Date: \(book.issuedDate)")
            Text("Return Date: \(book.returnDate)")
            Text("Status: \(book.status)")
                .foregroundColor(book.status == "Issued" ? .red : .green)
            Text("Quantity: \(book.quantity ?? 1)") // Display the quantity
            
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BooksCatalogue()
    }
}
