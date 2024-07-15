import Foundation



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
                if let volumeInfo = decodedData.items?.first?.volumeInfo {
                let bookCoverString = volumeInfo.imageLinks?.thumbnail?.absoluteString ?? ""
                               
                let book = Book(
                                   bookCode: isbn, // Use ISBN as bookCode for example
                                   bookCover: bookCoverString,
                                   bookTitle: volumeInfo.title,
                                   author: volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author",
                                   genre: .Fiction, // Example genre
                                   issuedDate: "2023-01-01", // Example issued date
                                   returnDate: "2023-02-01", // Example return date
                                   status: "Available", // Example status
                                   quantity: 1, // Example quantity
                                   description: volumeInfo.description ?? "",
                                   publisher: volumeInfo.publisher ?? "",
                                   publishedDate: volumeInfo.publishedDate ?? "",
                                   pageCount: volumeInfo.pageCount ?? 0,
                                   averageRating: volumeInfo.averageRating ?? 0.0
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
    let publisher: String?
    let publishedDate: String?
    let pageCount: Int?
    let averageRating: Double?
    let imageLinks: ImageLinks? // New field for image links
    
    struct ImageLinks: Decodable {
        let thumbnail: URL?
    }
}
