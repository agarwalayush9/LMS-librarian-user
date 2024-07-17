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
        //addDummyEventsToFirebase()
        fetchUpcomingEvents { result in
            switch result {
            case .success(let events):
                // Handle the fetched events
                print("Fetched upcoming events: \(events)")
                
                // Example: Display or process the fetched events
                for event in events {
                    print("Event Name: \(event.name)")
                    print("Event Date: \(event.date)")
                    print("Event Host: \(event.host)")
                    // Add more properties as needed
                }
                
            case .failure(let error):
                // Handle error
                print("Failed to fetch upcoming events: \(error.localizedDescription)")
            }
        }
        
    }

   
    
    func generateDummyEvents() -> [Event] {
        let users = [
            Member(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: 1234567890),
            Member(firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: 9876543210)
        ]
        
        let users1 = [
            Member(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: 1234567890),
            Member(firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: 9876543210),
            Member(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: 1234567890),
            Member(firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: 9876543210)
        ]
        
        let users2 = [
            Member(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: 1234567890),
            Member(firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: 9876543210),
            Member(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: 1234567890),
            Member(firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: 9876543210),
            Member(firstName: "John", lastName: "Doe", email: "john.doe@example.com", phoneNumber: 1234567890),
            Member(firstName: "Jane", lastName: "Smith", email: "jane.smith@example.com", phoneNumber: 9876543210)
        ]
        
        let events = [
            Event(
                name: "Tech Conference 2024",
                host: "Tech Corp",
                date: randomDate(daysAhead: 10), // Example: Random date 10 days ahead
                time: randomTime(),
                address: "123 Tech Lane, Tech City",
                duration: "3 hours",
                description: "An exciting tech conference with industry leaders.",
                registeredMembers: users,
                tickets: 100,
                imageName: "tech_conference",
                fees: 50,
                revenue: 5000,
                status: "Upcoming"
            ),
            Event(
                name: "Startup Meetup",
                host: "Startup Inc",
                date: randomDate(daysAhead: 15), // Example: Random date 15 days ahead
                time: randomTime(),
                address: "456 Startup Street, Innovation Town",
                duration: "2 hours",
                description: "A meetup for aspiring entrepreneurs.",
                registeredMembers: users1,
                tickets: 80,
                imageName: "startup_meetup",
                fees: 30,
                revenue: 2400,
                status: "Upcoming"
            ),
            Event(
                name: "Developer Workshop",
                host: "Code Academy",
                date: randomDate(daysAhead: 20), // Example: Random date 20 days ahead
                time: randomTime(),
                address: "789 Code Avenue, Developer City",
                duration: "4 hours",
                description: "A workshop for developers to learn new skills.",
                registeredMembers: users2,
                tickets: 50,
                imageName: "developer_workshop",
                fees: 100,
                revenue: 5000,
                status: "Upcoming"
            ),
            Event(
                name: "Business Summit",
                host: "Business Insights",
                date: randomDate(daysAhead: 25), // Example: Random date 25 days ahead
                time: randomTime(),
                address: "10 Business Boulevard, Corporate Town",
                duration: "5 hours",
                description: "An annual gathering of business leaders.",
                registeredMembers: users,
                tickets: 120,
                imageName: "business_summit",
                fees: 80,
                revenue: 9600,
                status: "Upcoming"
            ),
            Event(
                name: "Art Exhibition",
                host: "Artistry Gallery",
                date: randomDate(daysAhead: 30), // Example: Random date 30 days ahead
                time: randomTime(),
                address: "789 Art Avenue, Creative City",
                duration: "3 hours",
                description: "Showcasing contemporary art pieces.",
                registeredMembers: users2,
                tickets: 60,
                imageName: "art_exhibition",
                fees: 40,
                revenue: 2400,
                status: "Upcoming"
            ),
            Event(
                name: "Music Festival",
                host: "Harmony Productions",
                date: randomDate(daysAhead: 40), // Example: Random date 40 days ahead
                time: randomTime(),
                address: "555 Music Street, Entertainment Village",
                duration: "2 days",
                description: "Celebrating music with live performances.",
                registeredMembers: users1,
                tickets: 200,
                imageName: "music_festival",
                fees: 150,
                revenue: 30000,
                status: "Upcoming"
            )
        ]
        
        return events
    }

    // Function to generate a random date in the future
    func randomDate(daysAhead: Int) -> Date {
        let randomOffset = Int.random(in: 1...daysAhead)
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: randomOffset, to: Date()) ?? Date()
    }

    // Function to generate a random time for the same day
    func randomTime() -> Date {
        let calendar = Calendar.current
        let hour = Int.random(in: 0...23)
        let minute = Int.random(in: 0...59)
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
    }

    
    func addDummyEventsToFirebase() {
        let dummyEvents = generateDummyEvents()
        
        for event in dummyEvents {
            addEvent(event) { result in
                switch result {
                case .success:
                    print("Event '\(event.name)' added to Firebase.")
                case .failure(let error):
                    print("Failed to add event '\(event.name)' to Firebase: \(error.localizedDescription)")
                }
            }
        }
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
        let eventID = event.id
        
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
    
    func addPendingEvent(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id
        
        // Check if the event ID already exists
        database.child("PendingEvents").child(eventID).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                // Event ID already exists
                completion(.failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Event ID is already in use."])))
            } else {
                // Add the event to the database
                self.savePendingEventToDatabase(event) { result in
                    completion(result)
                }
            }
        }
    }

    private func saveEventToDatabase(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id
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
    
    private func savePendingEventToDatabase(_ event: Event, completion: @escaping (Result<Void, Error>) -> Void) {
        let eventID = event.id
        let eventDictionary = event.toDictionary()
        
        // Save event to database
        database.child("PendingEvents").child(eventID).setValue(eventDictionary) { error, _ in
            if let error = error {
                print("Failed to save event: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Event saved successfully.")
                completion(.success(()))
            }
        }
    }
   
    
    
    
    func fetchAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
            database.child("events").observeSingleEvent(of: .value) { snapshot in
                guard let eventsDict = snapshot.value as? [String: [String: Any]] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found or failed to cast snapshot value."])))
                    return
                }

                var events: [Event] = []

                for (_, dict) in eventsDict {
                    do {
                        if let event = try self.parseEvent(from: dict) {
                            events.append(event)
                        }
                    } catch {
                        print("Failed to parse event data: \(error.localizedDescription)")
                    }
                }

                print("Fetched \(events.count) events.")
                completion(.success(events))
            }
        }

    func fetchEventFees(completion: @escaping (Result<[Int], Error>) -> Void) {
            fetchAllEvents { result in
                switch result {
                case .success(let events):
                    let fees = events.map { $0.fees }
                    print("Fetched fees: \(fees)")
                    completion(.success(fees))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    
    func fetchEventRevenue(completion: @escaping (Result<[Int], Error>) -> Void) {
           fetchAllEvents { result in
               switch result {
               case .success(let events):
                   let revenue = events.map { $0.revenue }
                   print("Fetched revenue: \(revenue)")
                   completion(.success(revenue))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    func fetchTotalRevenue(completion: @escaping (Result<Int, Error>) -> Void) {
        fetchEventRevenue { result in
            switch result {
            case .success(let revenues):
                let totalRevenue = revenues.reduce(0, +)
                print("Total revenue: \(totalRevenue)")
                completion(.success(totalRevenue))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEventDateTime(completion: @escaping (Result<[Date], Error>) -> Void) {
        fetchAllEvents { result in
            switch result {
            case .success(let events):
                let eventDates = events.map { $0.date }
                print("Fetched event dates and times: \(eventDates)")
                completion(.success(eventDates))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    

    
    func fetchEventTickets(completion: @escaping (Result<[Int], Error>) -> Void) {
            fetchAllEvents { result in
                switch result {
                case .success(let events):
                    let tickets = events.map { $0.tickets }
                    print("Fetched tickets: \(tickets)")
                    completion(.success(tickets))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func fetchRegisteredMembers(completion: @escaping (Result<[Member], Error>) -> Void) {
            fetchAllEvents { result in
                switch result {
                case .success(let events):
                    var registeredUsers: [Member] = []
                    for event in events {
                        registeredUsers.append(contentsOf: event.registeredMembers)
                    }
                    print("Fetched registered users: \(registeredUsers)")
                    completion(.success(registeredUsers))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func fetchRegisteredMembersCount(completion: @escaping (Result<Int, Error>) -> Void) {
            fetchRegisteredMembers { result in
                switch result {
                case .success(let registeredUsers):
                    let userCount = registeredUsers.count
                    print("Total registered users count: \(userCount)")
                    completion(.success(userCount))
                case .failure(let error):
                    completion(.failure(error))
                }
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
        fetchAllEvents { result in
            switch result {
            case .success(let events):
                // Sort events by date and time ascending
                let sortedEvents = events.sorted { event1, event2 in
                    if event1.date == event2.date {
                        return event1.time < event2.time
                    }
                    return event1.date < event2.date
                }
                
                // Limit to the nearest 4 events
                let nearestEvents = Array(sortedEvents.prefix(4))
                
                completion(.success(nearestEvents))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchRegisteredMembersOfNearestEvent(completion: @escaping (Result<Int, Error>) -> Void) {
        fetchUpcomingEvents { result in
            switch result {
            case .success(let events):
                guard let nearestEvent = events.first else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No upcoming events found."])))
                    return
                }
                
                let registeredMemberCount = nearestEvent.registeredMembers.count
                completion(.success(registeredMemberCount))
                
            case .failure(let error):
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
        var registeredMembers: [Member] = []
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
                let user = Member(firstName: name, lastName: lastName, email: email, phoneNumber: phoneNumber)
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


//    private func parseEvents(from eventsDict: [String: [String: Any]]) throws -> [Event] {
//        var events: [Event] = []
//
//        for (_, dict) in eventsDict {
//            if let event = try parseEvent(from: dict) {
//                events.append(event)
//            }
//        }
//
//        // Sort events by date and time descending
//        events.sort { $0.date < $1.date || ($0.date == $1.date && $0.time < $1.time) }
//
//        return events
//    }

    
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
    
    func fetchNotifications(completion: @escaping (Result<[Notification], Error>) -> Void) {
            let notificationsRef = database.child("notifications")

            notificationsRef.observeSingleEvent(of: .value) { snapshot in
                guard let notificationsDict = snapshot.value as? [String: Any] else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No notifications found."])))
                    return
                }

                var notifications: [Notification] = []
                for (_, value) in notificationsDict {
                    if let notificationDict = value as? [String: String],
                       let title = notificationDict["title"],
                       let message = notificationDict["message"] {
                        let notification = Notification(title: title, message: message)
                        notifications.append(notification)
                    }
                }

                completion(.success(notifications))
            }
        }


}
