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
    let bookCode: String
    let bookCover: String
    let bookTitle: String
    let author: String
    let genre: [Genre]
    let issuedDate: String
    let returnDate: String
    let status: String
    var quantity: Int?
    
    func toDictionary() -> [String: Any] {
            return [
                "id": id.uuidString,
                "bookCode": bookCode,
                "bookCover": bookCover,
                "bookTitle": bookTitle,
                "author": author,
                "genre": genre.map { $0.rawValue },
                "issuedDate": issuedDate,
                "returnDate": returnDate,
                "status": status
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

//  MARK: Struct for Graphs
struct Event {
    var id = UUID()
    var name: String
    var host: String
    var date: Date
    var time: Time
    var address: String
    var duration: String
    var specialGuest: String?
    var category: String?
    var description: String
    var registeredMembers: [User]
    var tickets: Int
    var imageName: String
    var fees: Int
    var revenue: Int
    var status: String
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "name": name,
            "host": host,
            "date": date,
            "time": time.toDictionary(),
            "address": address,
            "duration": duration,
            "specialGuest": specialGuest ?? "",
            "category": category ?? "",
            "description": description,
            "registeredMembers": registeredMembers.map { $0.toDictionary() },
            "tickets": tickets,
            "imageName": imageName,
            "fees": fees,
            "revenue": revenue,
            "status": status
        ]
    }
}

struct Time: Codable {
    var hours: Int
    var minutes: Int
    
    func toDictionary() -> [String: Int] {
        return [
            "hours": hours,
            "minutes": minutes
        ]
    }
}
