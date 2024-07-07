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
                "phoneNumber": phoneNumber,
                "status": "Approval Pending",
                "userId": "********",
                "password": "********"
            ]
        }
}
