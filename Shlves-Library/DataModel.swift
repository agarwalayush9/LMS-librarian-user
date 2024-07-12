import Foundation

struct User
{
    var name: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    func toDictionary() -> [String: Any] {
            return [
                "name": name,
                "lastName": lastName,
                "email": email,
                "phoneNumber": phoneNumber,
                "status": "Approval Pending",
                "userId": "********",
                "password": "********",
            ]
        }
}

struct Book: Identifiable, Codable {
    var id = UUID()
    var bookCode: String
    let bookCover: String
    let bookTitle: String
    let author: String
    let genre: Genre
    let issuedDate: String
    let returnDate: String
    let status: String
    var quantity: Int?
    var description: String?
    let publisher: String?
    let publishedDate: String?
    let pageCount: Int?
    let averageRating: Double?
    
    
    
    func toDictionary() -> [String: Any] {
            return [
                "id": id.uuidString,
                "bookCode": bookCode,
                "bookCover": bookCover,
                "bookTitle": bookTitle,
                "author": author,
                "genre": genre.rawValue,
                "issuedDate": issuedDate,
                "returnDate": returnDate,
                "status": status,
                "quantity": quantity ?? 0,
                "description": description ?? "",
                "publisher": publisher ?? "",
                "publishedDate": publishedDate ?? "",
                "pageCount": pageCount ?? 0,
                "averageRating": averageRating ?? 0.0,
                
            ]
        }
}

enum Genre: String, Codable {
    case Horror
    case Mystery
    case Fiction
    case Finance
    case Fantasy
    case Business
    case Romance
    case Psychology
    case YoungAdult
    case SelfHelp
    case HistoricalFiction
    case NonFiction
    case ScienceFiction
    case Literature
}
