//
//  BookCatalogue.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 05/07/24.
//

import SwiftUI

struct AddBookDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var bookTitle = ""
    @State private var author = ""
    @State private var genre = ""
    
    var addBook: (Book) -> Void
    
    var body: some View {
        VStack {
            Text("Enter Book Details")
                .font(.title)
                .padding()

            Form {
                TextField("Book Title", text: $bookTitle)
                TextField("Author", text: $author)
                TextField("Genre", text: $genre)
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
                    let newBook = Book(id: Int.random(in: 1...1000), bookCode: "#\(Int.random(in: 1000000...9999999))", bookCover: "book_cover", bookTitle: bookTitle, author: author, genre: genre, issuedDate: "", returnDate: "", status: "Available")
                    addBook(newBook)
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
    }
}



struct AddBookOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddBookDetails = false
    var addBook: (Book) -> Void

    var body: some View {
        VStack {
            Text("Add Books")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            VStack(spacing: 60) {
                Button(action: {
                    // Action for ISBN Code Scanning
                }) {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 40))
                        Text("Using ISBN Code Scanning")
                            .font(.headline)
                    }
                    .padding(.all, 40)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.orange, lineWidth: 2))
                }

                Button(action: {
                    // Action for Batch Upload
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 40))
                        Text("Batch Upload (CSV, Spreadsheet)")
                            .font(.headline)
                    }
                    .padding(.all, 40)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
                }

                Button(action: {
                    showingAddBookDetails = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 40))
                        Text("Enter Details Manually")
                            .font(.headline)
                    }
                    .padding(.all , 40)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 2))
                }
                .sheet(isPresented: $showingAddBookDetails) {
                    AddBookDetailsView { newBook in
                        addBook(newBook)
                        showingAddBookDetails = false
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 500) // Limit the width of the pop-up
    }
}




struct Book: Identifiable {
    let id: Int
    let bookCode: String
    let bookCover: String
    let bookTitle: String
    let author: String
    let genre: String
    let issuedDate: String
    let returnDate: String
    let status: String
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
    @State private var selectedBooks = Set<Int>()
    @State private var showingAddBookOptions = false
    
    @State private var  books = [
        Book(id: 1, bookCode: "#4235532", bookCover: "book_cover", bookTitle: "Harry Potter And The Cursed Child", author: "J.K. Rowling", genre: "Fantasy Literature", issuedDate: "May 5, 2023", returnDate: "May 5, 2023", status: "Issued"),
        Book(id: 2, bookCode: "#4235533", bookCover: "book_cover", bookTitle: "Harry Potter And The Philosopher's Stone", author: "J.K. Rowling", genre: "Fantasy Literature", issuedDate: "May 6, 2023", returnDate: "May 6, 2023", status: "Returned"),
        Book(id: 3, bookCode: "#4235533", bookCover: "book_cover", bookTitle: "Harry Potter And The Philosopher's Stone", author: "J.K. Rowling", genre: "Fantasy Literature", issuedDate: "May 6, 2023", returnDate: "May 6, 2023", status: "Returned"),
        Book(id: 4, bookCode: "#4235533", bookCover: "book_cover", bookTitle: "Harry Potter And The Philosopher's Stone", author: "J.K. Rowling", genre: "Fantasy Literature", issuedDate: "May 6, 2023", returnDate: "May 6, 2023", status: "Returned"),
        // Add more books here
    ]

    var body: some View {
            NavigationView {
                List {
                    NavigationLink(destination: BooksCatalogue()) {
                        Label("Khvaab Library", systemImage: "books.vertical")
                            .font(.title)
                            .foregroundColor(.brown)
                    }
                    NavigationLink(destination: BooksCatalogue()) {
                        Label("Book Catalogues", systemImage: "book")
                            .font(.title2)
                            .foregroundColor(.brown)
                    }
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Khvaab Library")
               
                ZStack {
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
                                        Text(book.genre)
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
                                        .stroke(Color(red: 1, green: 0.74, blue: 0.28),lineWidth: 4)
                                        .shadow(color: .gray, radius: 5, x: 0, y: 2)
                                )
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                            .sheet(isPresented: $showingAddBookOptions) {
                                AddBookOptionsView { newBook in
                                    books.append(newBook)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Books Catalogues")
            }
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            BooksCatalogue()
        }
    }
