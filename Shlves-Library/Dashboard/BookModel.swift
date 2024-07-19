//
//  BookModel.swift
//  Shlves-Library
//
//  Created by Ayush Agarwal on 19/07/24.
//

import SwiftUI
import Firebase
import Combine

class BookModel: ObservableObject {
    @Published var borrowedBooks: [GBook] = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    let database = Database.database().reference()

    func fetchIsbnCodes(completion: @escaping (Result<[String: (String, String)], Error>) -> Void) {
        database.child("issue-book").observeSingleEvent(of: .value) { snapshot in
            guard let issueDict = snapshot.value as? [String: [String: [String: Any]]] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value for ISBN status."])))
                return
            }

            var isbnStatusDict: [String: (String, String)] = [:]
            for (email, isbnDict) in issueDict {
                for (isbn, statusDict) in isbnDict {
                    if let status = statusDict["status"] as? String {
                        isbnStatusDict[isbn] = (status, email)
                    }
                }
            }

            completion(.success(isbnStatusDict))
        }
    }

    func fetchBooks(completion: @escaping (Result<[GBook], Error>) -> Void) {
        fetchIsbnCodes { result in
            switch result {
            case .success(let isbnStatusDict):
                let isbnCodes = Array(isbnStatusDict.keys)
                self.fetchBooksFromGoogleAPI(isbnCodes: isbnCodes, isbnStatusDict: isbnStatusDict, completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchBooksFromGoogleAPI(isbnCodes: [String], isbnStatusDict: [String: (String, String)], completion: @escaping (Result<[GBook], Error>) -> Void) {
        let group = DispatchGroup()
        var books: [GBook] = []
        var errors: [Error] = []

        for isbn in isbnCodes {
            group.enter()
            let urlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)"
            
            guard let url = URL(string: urlString) else {
                errors.append(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL for ISBN: \(isbn)"]))
                group.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }

                if let error = error {
                    errors.append(error)
                    return
                }

                guard let data = data else {
                    errors.append(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned for ISBN: \(isbn)"]))
                    return
                }

                do {
                    let bookResponse = try JSONDecoder().decode(GoogleBookResponses.self, from: data)
                    if let googleBook = bookResponse.items.first {
                        if let (status, email) = isbnStatusDict[isbn] {
                            let book = GBook(from: googleBook, isbn: isbn, status: status, email: email)
                            books.append(book)
                        } else {
                            errors.append(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Status not found for ISBN: \(isbn)"]))
                        }
                    }
                } catch {
                    errors.append(error)
                }
            }.resume()
        }

        group.notify(queue: .main) {
            if errors.isEmpty {
                completion(.success(books))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch some or all books."])))
            }
        }
    }

    func fetchBorrowedBooks() {
        fetchBooks { result in
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    self.borrowedBooks = books
                }
            case .failure(let error):
                print("Failed to fetch borrowed books: \(error)")
            }
        }
    }
}

struct GoogleBookResponses: Codable {
    let items: [GoogleBooks]
}

struct GoogleBooks: Codable {
    let id: String
    let volumeInfo: VolumeInfo

    struct VolumeInfo: Codable {
        let title: String
        let authors: [String]?
        let imageLinks: ImageLinks?

        struct ImageLinks: Codable {
            let thumbnail: String
        }
    }
}

struct GBook: Identifiable {
    let id: UUID
    let title: String
    let author: String
    let imageName: String
    let status: String
    let email: String
    let isbn: String

    init(from googleBook: GoogleBooks, isbn: String, status: String, email: String) {
        self.id = UUID()
        self.title = googleBook.volumeInfo.title
        self.author = googleBook.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author"
        self.imageName = googleBook.volumeInfo.imageLinks?.thumbnail ?? ""
        self.status = status
        self.email = email
        self.isbn = isbn
    }
}
