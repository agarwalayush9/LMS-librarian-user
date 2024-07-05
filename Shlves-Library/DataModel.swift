//
//  DataModel.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 04/07/24.
//

import Foundation

struct User
{
    var name: String
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
                "email": email,
                "phoneNumber": phoneNumber
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
