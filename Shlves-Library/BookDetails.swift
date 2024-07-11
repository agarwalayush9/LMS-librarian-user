//
//  BookDetails.swift
//  Barcode
//
//  Created by Mohit Kumar Gupta on 11/07/24.
//

import Foundation

struct BookDetails: Decodable {
    let title: String
    
    let description: String?
    // Add more properties as needed
}

enum APIError: Error {
    case invalidResponse
    case networkError(Error)
}

class BookAPI {
    static func fetchDetails(isbn: String, completion: @escaping (Result<BookDetails, APIError>) -> Void) {
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
                if let book = decodedData.items?.first?.volumeInfo {
                    let details = BookDetails(
                        title: book.title,
                        
                        description: book.description
                    )
                    completion(.success(details))
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
    // Add more properties as needed
}
