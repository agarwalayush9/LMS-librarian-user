//
//  BookDetails.swift
//  Barcode
//
//  Created by Mohit Kumar Gupta on 11/07/24.
//

import Foundation

//struct BookDetails: Decodable {
//    let title: String
//    
//    let description: String?
//    // Add more properties as needed
//}

enum APIError: Error {
    case invalidResponse
    case networkError(Error)
}

class BookAPI {
    static func fetchDetails(isbn: String, completion: @escaping (Result<Book, APIError>) -> Void) {
        let baseUrl = "https://www.googleapis.com/books/v1/volumes"
        let queryItems = [
            URLQueryItem(name: "q", value: "isbn:\(isbn)")
        ]
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(.failure(.invalidResponse))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(GoogleBooksResponse.self, from: data)
                if let bookInfo = decodedData.items?.first?.volumeInfo {
                    let book = Book(
                        bookCode: isbn,
                        bookCover: bookInfo.imageLinks?.thumbnail ?? "",
                        bookTitle: bookInfo.title,
                        author: bookInfo.authors?.first ?? "Unknown",
                        genre: [], // Provide genre if available
                        issuedDate: "",
                        returnDate: "",
                        status: "available",
                        description: bookInfo.description ?? ""
                    )
                    completion(.success(book))
                } else {
                    completion(.failure(.invalidResponse))
                }
            } catch {
                completion(.failure(.invalidResponse))
            }
        }.resume()
    }
}
struct GoogleBooksResponse: Decodable {
    let items: [GoogleBook]?
}

struct GoogleBook: Decodable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Decodable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Decodable {
    let thumbnail: String?
}
