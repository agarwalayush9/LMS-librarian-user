//
//  DataController.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 04/07/24.
//

import Foundation
import FirebaseDatabase

class DataController
{
    
    var users: [User] = []
    var books: [Book] = []
    
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    static let shared = DataController() // singleton
    private let database = Database.database().reference()
    
    private init()
    {
        loadDummyBooks()
    }
    
    
    func loadDummyBooks() {
        let book1 = Book(bookCode: "978-3-16-148410-0", bookCover: "book_cover", bookTitle: "The Great Gatsby", author: "F. Scott Fitzgerald", genre: [.Fiction, .Literature], issuedDate: "2024-01-01", returnDate: "2024-01-15", status: "Available")
        let book2 = Book(bookCode: "978-0-7432-7356-5", bookCover: "book_cover", bookTitle: "To Kill a Mockingbird", author: "Harper Lee", genre: [.Fiction, .HistoricalFiction], issuedDate: "2024-02-01", returnDate: "2024-02-15", status: "Issued")
        let book3 = Book(bookCode: "978-0-452-28423-4", bookCover: "book_cover", bookTitle: "1984", author: "George Orwell", genre: [.Fiction, .ScienceFiction], issuedDate: "2024-03-01", returnDate: "2024-03-15", status: "Available")
        let book4 = Book(bookCode: "978-0-7432-7357-2", bookCover: "book_cover", bookTitle: "Pride and Prejudice", author: "Jane Austen", genre: [.Fiction, .Romance], issuedDate: "2024-04-01", returnDate: "2024-04-15", status: "Available")
        let book5 = Book(bookCode: "978-0-7432-7358-9", bookCover: "book_cover", bookTitle: "The Hobbit", author: "J.R.R. Tolkien", genre: [.Fantasy, .Fiction], issuedDate: "2024-05-01", returnDate: "2024-05-15", status: "Issued")
        let book6 = Book(bookCode: "978-0-7432-7359-6", bookCover: "book_cover", bookTitle: "Harry Potter and the Sorcerer's Stone", author: "J.K. Rowling", genre: [.Fantasy, .YoungAdult], issuedDate: "2024-06-01", returnDate: "2024-06-15", status: "Available")
        let book7 = Book(bookCode: "978-0-7432-7360-2", bookCover: "book_cover", bookTitle: "The Catcher in the Rye", author: "J.D. Salinger", genre: [.Fiction, .Literature], issuedDate: "2024-07-01", returnDate: "2024-07-15", status: "Issued")
        let book8 = Book(bookCode: "978-0-7432-7361-9", bookCover: "book_cover", bookTitle: "Brave New World", author: "Aldous Huxley", genre: [.ScienceFiction, .Fiction], issuedDate: "2024-08-01", returnDate: "2024-08-15", status: "Available")
        let book9 = Book(bookCode: "978-0-7432-7362-6", bookCover: "book_cover", bookTitle: "Moby Dick", author: "Herman Melville", genre: [.Fiction, .Literature], issuedDate: "2024-09-01", returnDate: "2024-09-15", status: "Available")
        let book10 = Book(bookCode: "978-0-7432-7363-3", bookCover: "book_cover", bookTitle: "War and Peace", author: "Leo Tolstoy", genre: [.Fiction, .HistoricalFiction], issuedDate: "2024-10-01", returnDate: "2024-10-15", status: "Issued")
        
        books.append(contentsOf: [book1, book2, book3, book4, book5, book6, book7, book8, book9, book10])
        
        
    }

    func addUser(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
            let safeEmail = DataController.safeEmail(email: user.email)
            
            // Check if the user email already exists
            database.child("users").child(safeEmail).observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    // User email already exists
                    completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Email is already in use."])))
                } else {
                    // Add the user to the array and save to the database
                    self.users.append(user)
                    self.saveUserToDatabase(user) { result in
                        completion(result)
                    }
                }
            }
        }
        
        private func saveUserToDatabase(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
            let safeEmail = DataController.safeEmail(email: user.email)
            let userDictionary = user.toDictionary()
            database.child("users").child(safeEmail).setValue(userDictionary) { error, _ in
                if let error = error {
                    print("Failed to save user: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("User saved successfully.")
                    completion(.success(()))
                }
            }
        }
    
    func addBook(_ book: Book, completion: @escaping (Result<Void, Error>) -> Void) {
            // Check if the book with the same bookCode already exists
            database.child("books").child(book.bookCode).observeSingleEvent(of: .value) { snapshot in
                if snapshot.exists() {
                    // Book with the same bookCode already exists
                    completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Book code already exists."])))
                } else {
                    // Add the book to the array and save to the database
                    self.books.append(book)
                    self.saveBookToDatabase(book) { result in
                        completion(result)
                    }
                }
            }
        }
    
    
    private func saveBookToDatabase(_ book: Book, completion: @escaping (Result<Void, Error>) -> Void) {
            let bookDictionary = book.toDictionary()
            database.child("books").child(book.bookCode).setValue(bookDictionary) { error, _ in
                if let error = error {
                    print("Failed to save book: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Book saved successfully.")
                    completion(.success(()))
                }
            }
        }
    
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        database.child("books").observeSingleEvent(of: .value) { snapshot in
            guard let booksDict = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                return
            }
            
            var books: [Book] = []
            
            for (_, dict) in booksDict {
                guard
                    let bookCode = dict["bookCode"] as? String,
                    let bookCover = dict["bookCover"] as? String,
                    let bookTitle = dict["bookTitle"] as? String,
                    let author = dict["author"] as? String,
                    let genreStrings = dict["genre"] as? [String],
                    let issuedDate = dict["issuedDate"] as? String,
                    let returnDate = dict["returnDate"] as? String,
                    let status = dict["status"] as? String
                else {
                    print("Failed to parse book data.")
                    continue
                }
                
                // Convert genre strings to Genre enum array
                let genres = genreStrings.compactMap { Genre(rawValue: $0) }
                
                let book = Book(
                    bookCode: bookCode,
                    bookCover: bookCover,
                    bookTitle: bookTitle,
                    author: author,
                    genre: genres,
                    issuedDate: issuedDate,
                    returnDate: returnDate,
                    status: status
                )
                
                books.append(book)
            }
            
            print("Fetched \(books.count) books.")
            completion(.success(books))
        }
    }

    
    
}
