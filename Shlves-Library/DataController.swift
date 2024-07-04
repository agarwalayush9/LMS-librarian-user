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
    
    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    static let shared = DataController() // singleton
    private let database = Database.database().reference()
    
    
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
    
    
}
