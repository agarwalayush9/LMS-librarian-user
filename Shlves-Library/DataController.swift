import Foundation
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class DataController: ObservableObject {
    @Published var users: [User] = []
    @Published var books: [Book] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    static func safeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }

    static let shared = DataController() // singleton
    private let database = Database.database().reference()

    private init() {
        loadDummyBooks()
    }

    func loadDummyBooks() {
        // Add your dummy books here...
    }

    func isEmailAlreadyInUse(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { methods, error in
            if let error = error {
                print("Error fetching sign in methods: \(error.localizedDescription)")
                completion(false) // Assume email is not in use if error occurs
                return
            }

            // Check if methods array is empty or nil
            if let methods = methods, !methods.isEmpty {
                // Email exists (methods array is not empty)
                completion(true)
            } else {
                // Email does not exist
                completion(false)
            }
        }
    }

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

    func addBook(_ book: Book, completion: @escaping (Result<Void, Error>) -> Void) {
        // Check locally for duplicate books
        if hasDuplicateBook(title: book.bookTitle, author: book.author) {
            showAlert = true
            alertMessage = "Duplicate book found locally."
            completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: alertMessage])))
            return
        }

        // Check against Firebase for duplicate book codes
        database.child("books").child(book.bookCode).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Book with the same bookCode already exists in Firebase
                self.showAlert = true
                self.alertMessage = "Book code already exists in Firebase."
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: self.alertMessage])))
            } else {
                // Add the book to the array and save to the database
                self.books.append(book)
                self.saveBookToDatabase(book) { result in
                    completion(result)
                }
            }
        }
    }

    func hasDuplicateBook(title: String, author: String) -> Bool {
        // Check if a book with the same title and author exists locally
        let duplicateBook = books.first { $0.bookTitle == title && $0.author == author }
        return duplicateBook != nil
    }

    func saveBookToDatabase(_ book: Book, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference()
        let bookRef = ref.child("books").child(book.bookCode)

        // Convert book to dictionary
        let bookData: [String: Any] = [
            "bookCode": book.bookCode,
            "bookCover": book.bookCover,
            "bookTitle": book.bookTitle,
            "author": book.author,
            "genre": book.genre.rawValue,
            "issuedDate": book.issuedDate,
            "returnDate": book.returnDate,
            "status": book.status,
            "quantity": book.quantity ?? 1,
            "description": book.description,
            "publisher": book.publisher,
            "publishedDate": book.publishedDate,
            "pageCount": book.pageCount,
            "averageRating": book.averageRating
        ]

        // Save book data to Realtime Database
        bookRef.setValue(bookData) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        database.child("books").observeSingleEvent(of: .value) { snapshot in
            guard let booksDict = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                return
            }

            var books: [Book] = []

            for (_, dict) in booksDict {
                guard
                    let bookCode = dict["bookCode"] as? String,
                    let bookCover = dict["bookCover"] as? String,
                    let bookTitle = dict["bookTitle"] as? String,
                    let author = dict["author"] as? String,
                    let genreString = dict["genre"] as? String,
                    let issuedDate = dict["issuedDate"] as? String,
                    let returnDate = dict["returnDate"] as? String,
                    let status = dict["status"] as? String,
                    let quantity = dict["quantity"] as? Int,
                    let description = dict["description"] as? String,
                    let publisher = dict["publisher"] as? String,
                    let publishedDate = dict["publishedDate"] as? String,
                    let pageCount = dict["pageCount"] as? Int,
                    let averageRating = dict["averageRating"] as? Double
                   
                else {
                    print("Failed to parse book data.")
                    continue
                }

                guard let genre = Genre(rawValue: genreString) else {
                    print("Failed to parse genre.")
                    continue
                }

                let book = Book(
                    bookCode: bookCode,
                    bookCover: bookCover,
                    bookTitle: bookTitle,
                    author: author,
                    genre: genre,
                    issuedDate: issuedDate,
                    returnDate: returnDate,
                    status: status,
                    quantity: quantity,
                    description: description,
                    publisher: publisher,
                    publishedDate: publishedDate,
                    pageCount: pageCount,
                    averageRating: averageRating
                   
                )

                books.append(book)
            }

            print("Fetched \(books.count) books.")
            completion(.success(books))
        }
    }
    
    
    func addEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id.uuidString
        
        // Check if the event ID already exists
        database.child("events").child(eventID).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Event ID already exists
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Event ID is already in use."])))
            } else {
                // Add the event to the database
                self.saveEventToDatabase(event) { result in
                    completion(result)
                }
            }
        }
    }

    private func saveEventToDatabase(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id.uuidString
        let eventDictionary = event.toDictionary()
        
        // Save event to database
        database.child("events").child(eventID).setValue(eventDictionary) { error, _ in
            if let error = error {
                print("Failed to save event: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Event saved successfully.")
                completion(.success(()))
            }
        }
    }
    
    
    func fetchTotalRevenue(completion: @escaping (Result<Int, Error>) -> Void) {
            database.child("events").observeSingleEvent(of: .value) { snapshot in
                guard let eventsDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }

                var totalRevenue: Int = 0

                for (_, dict) in eventsDict {
                    guard let revenue = dict["revenue"] as? Int else {
                        print("Failed to parse event revenue.")
                        continue
                    }

                    totalRevenue += revenue
                }

                print("Total revenue: \(totalRevenue)")
                completion(.success(totalRevenue))
            }
        }

    
    func fetchNumberOfBooks(completion: @escaping (Result<Int, Error>) -> Void) {
        database.child("books").observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                completion(.failure(error as! Error))
                return
            }
            
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                // If there are no books or the snapshot cannot be casted to [String: Any]
                completion(.success(0))
                return
            }
            
            // Get the count of children under "books" node
            let numberOfBooks = snapshotDict.count
            completion(.success(numberOfBooks))
        }
    }
    
    
    func fetchNumberOfMembers(completion: @escaping (Result<Int, Error>) -> Void) {
        database.child("members").observeSingleEvent(of: .value) { snapshot, error in
            if let error = error {
                completion(.failure(error as! Error))
                return
            }
            
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                // If there are no books or the snapshot cannot be casted to [String: Any]
                completion(.success(0))
                return
            }
            
            // Get the count of children under "books" node
            let numberOfBooks = snapshotDict.count
            completion(.success(numberOfBooks))
        }
    }
    
    
    func fetchNumberOfEvents(completion: @escaping (Result<Int, Error>) -> Void) {
        database.child("events").observeSingleEvent(of: .value) { snapshot in
            guard let snapshotDict = snapshot.value as? [String: Any] else {
                completion(.success(0))
                return
            }
            
            let numberOfEvents = snapshotDict.count
            completion(.success(numberOfEvents))
            print(numberOfEvents)
        }
    }
    
    
    func fetchUpcomingEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        database.child("events")
            .queryOrdered(byChild: "date")
            .queryLimited(toLast: 4)
            .observeSingleEvent(of: .value) { snapshot in
                guard let eventsDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }

                do {
                    let events = try self.parseEvents(from: eventsDict)
                    completion(.success(events))
                } catch {
                    completion(.failure(error))
                }
            }
    }

    
   
    private func parseEvent(from dict: [String: Any]) throws -> Event? {
        // Extract values with conditional binding
        guard
            let name = dict["name"] as? String,
            let host = dict["host"] as? String,
            let dateInterval = dict["date"] as? TimeInterval,
            let timeInterval = dict["time"] as? TimeInterval,
            let address = dict["address"] as? String,
            let duration = dict["duration"] as? String,
            let description = dict["description"] as? String,
            let tickets = dict["tickets"] as? Int,
            let imageName = dict["imageName"] as? String,
            let fees = dict["fees"] as? Int,
            let revenue = dict["revenue"] as? Int,
            let status = dict["status"] as? String
        else {
            // Print missing or invalid keys
            let keyMissing = [
                "name": dict["name"],
                "host": dict["host"],
                "dateInterval": dict["dateInterval"],
                "timeInterval": dict["timeInterval"],
                "address": dict["address"],
                "duration": dict["duration"],
                "description": dict["description"],
                "tickets": dict["tickets"],
                "imageName": dict["imageName"],
                "fees": dict["fees"],
                "revenue": dict["revenue"],
                "status": dict["status"]
            ]
            
            print("Failed to parse event data. Missing or invalid key/value: \(keyMissing)")
            return nil
        }

        // Parse date and time
        let date = Date(timeIntervalSince1970: dateInterval)
        let time = Date(timeIntervalSince1970: timeInterval)

        // Parse registered members if available
        var registeredMembers: [User] = []
        if let registeredMembersArray = dict["registeredMembers"] as? [[String: Any]] {
            for memberDict in registeredMembersArray {
                guard
                    let name = memberDict["name"] as? String,
                    let email = memberDict["email"] as? String,
                    let lastName = memberDict["lastName"] as? String,
                    let phoneNumber = memberDict["phoneNumber"] as? Int
                else {
                    print("Failed to parse registered member data.")
                    continue
                }
                let user = User(name: name, lastName: lastName, email: email, phoneNumber: phoneNumber)
                registeredMembers.append(user)
            }
        }

        // Return Event object
        return Event(
            name: name,
            host: host,
            date: date,
            time: time,
            address: address,
            duration: duration,
            description: description,
            registeredMembers: registeredMembers,
            tickets: tickets,
            imageName: imageName,
            fees: fees,
            revenue: revenue,
            status: status
        )
    }


    private func parseEvents(from eventsDict: [String: [String: Any]]) throws -> [Event] {
        var events: [Event] = []

        for (_, dict) in eventsDict {
            if let event = try parseEvent(from: dict) {
                events.append(event)
            }
        }

        // Sort events by date and time descending
        events.sort { $0.date > $1.date || ($0.date == $1.date && $0.time > $1.time) }

        return events
    }

    
    func fetchLastFourBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        database.child("books")
            .queryOrderedByKey()
            .queryLimited(toLast: 4)
            .observe(.value) { snapshot in
                guard let booksDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }

                var books: [Book] = []

                for (_, dict) in booksDict {
                    guard
                        let bookCode = dict["bookCode"] as? String,
                        let bookCover = dict["bookCover"] as? String,
                        let bookTitle = dict["bookTitle"] as? String,
                        let author = dict["author"] as? String,
                        let genreString = dict["genre"] as? String,
                        let issuedDate = dict["issuedDate"] as? String,
                        let returnDate = dict["returnDate"] as? String,
                        let status = dict["status"] as? String,
                        let quantity = dict["quantity"] as? Int,
                        let description = dict["description"] as? String,
                        let publisher = dict["publisher"] as? String,
                        let publishedDate = dict["publishedDate"] as? String,
                        let pageCount = dict["pageCount"] as? Int,
                        let averageRating = dict["averageRating"] as? Double
                    else {
                        print("Failed to parse book data.")
                        continue
                    }

                    guard let genre = Genre(rawValue: genreString) else {
                        print("Failed to parse genre.")
                        continue
                    }

                    let book = Book(
                        bookCode: bookCode,
                        bookCover: bookCover,
                        bookTitle: bookTitle,
                        author: author,
                        genre: genre,
                        issuedDate: issuedDate,
                        returnDate: returnDate,
                        status: status,
                        quantity: quantity,
                        description: description,
                        publisher: publisher,
                        publishedDate: publishedDate,
                        pageCount: pageCount,
                        averageRating: averageRating
                    )

                    books.append(book)
                }

                completion(.success(books))
            }
    }

}
