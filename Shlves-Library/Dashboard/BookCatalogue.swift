import SwiftUI

struct BooksCatalogue: View {
    @State private var selectedBooks = Set<UUID>()
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = [] // Use @State to hold fetched books
    @State private var menuOpened = false

    
    var body: some View {
        NavigationStack {
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
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Image(book.bookCover)
                                        .resizable()
                                        .frame(width: 60, height: 80)
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
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Center the table
                    }
                }.padding(.top, 15)
                
                // call Floating Button here
            
                FloatingButton(showingAddBookOptions: $showingAddBookOptions, addBook: { newBook in
                    // Append new book locally and update UI
                    books.append(newBook)
                }, books: $books)
                
                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                    

                }
            }
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
struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 25, height: 25)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct FloatingButton: View {
    @Binding var showingAddBookOptions: Bool
    var addBook: (Book) -> Void
    @Binding var books: [Book]
    
    var body: some View {
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
                            .shadow(color: .gray, radius: 5, x: 0, y: 2)
                    )
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                .sheet(isPresented: $showingAddBookOptions) {
                    FloatingButton(showingAddBookOptions: $showingAddBookOptions, addBook: addBook, books: $books)
                }
            }
        }
    }
}
