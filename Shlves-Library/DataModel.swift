import Foundation

struct User
{
    var firstName: String
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
                "name": firstName,
                "lastName": lastName,
                "email": email,
                "phoneNumber": phoneNumber,

            ]
        }
}

struct Book: Identifiable, Codable, Equatable {
    var id = UUID()
    var bookCode: String
    var bookCover: String
    var bookTitle: String
    var author: String
    var genre: Genre
    var issuedDate: String
    var returnDate: String
    var status: String
    var quantity: Int?
    var description: String?
    var publisher: String?
    var publishedDate: String?
    var pageCount: Int?
    var averageRating: Double?

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

    // Conformance to Equatable
    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Genre: String, Codable, CaseIterable {
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

struct Member {
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: Int
    var subscriptionPlan: String?
    var registeredEvents: [Event]?
    var genre: [Genre]?

    // Additional methods or properties as needed

    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "phoneNumber": phoneNumber
        ]

        if let subscriptionPlan = subscriptionPlan {
            dictionary["subscriptionPlan"] = subscriptionPlan
        }

        if let genre = genre {
            dictionary["genre"] = genre.map { $0.rawValue }
        }

        if let registeredEvents = registeredEvents {
            dictionary["registeredEvents"] = registeredEvents.map { $0.toDictionary() }
        }

        return dictionary
    }
}

struct Event: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var host: String
    var date: Date
    var time: Date
    var address: String
    var duration: String
    var description: String
    var registeredMembers: [Member]
    var tickets: Int
    var imageName: String
    var fees: Int
    var revenue: Int
    var status: String
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "host": host,
            "date": date.timeIntervalSince1970, // Convert Date to TimeInterval
            "time": time.timeIntervalSince1970,
            "address": address,
            "duration": duration,
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



struct Location: Codable {
    var latitude: Double
    var longitude: Double
    
    func toDictionary() -> [String: Double] {
        return [
            "latitude": latitude,
            "longitude": longitude
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

