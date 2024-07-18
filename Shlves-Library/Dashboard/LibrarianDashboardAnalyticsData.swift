//
//  LibrarianDashboardAnalyticsData.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import Foundation
import CoreImage
import SwiftUI

struct Analytics : Identifiable, Equatable{
    
    var id : String{title}
    var title : String
    var value : Double
    var salesDifferencePercentage : Double
    
    static var analytics : [Analytics] =
        [
            
            Analytics(title: "Books Issued", value: 221, salesDifferencePercentage: 2.5)
            
        ]
    
    
    static func updateTotalBooks(count: Int) {
        if let index = analytics.firstIndex(where: { $0.title == "Total Books" }) {
            analytics[index].value = Double(count)
        } else {
            let totalBooksAnalytics = Analytics(title: "Total Books", value: Double(count), salesDifferencePercentage: 0)
            analytics.append(totalBooksAnalytics)
        }
    }
    
    static func updateTotalEvents(count: Int) {
        if let index = analytics.firstIndex(where: { $0.title == "Events Conducted" }) {
            analytics[index].value = Double(count)
        } else {
            let totalBooksAnalytics = Analytics(title: "Events Conducted", value: Double(count), salesDifferencePercentage: 0)
            analytics.append(totalBooksAnalytics)
        }
    }
    
    static func updateTotalRevenue(count: Int) {
        if let index = analytics.firstIndex(where: { $0.title == "Events Revenue" }) {
            analytics[index].value = Double(count)
        } else {
            let totalBooksAnalytics = Analytics(title: "Events Revenue", value: Double(count), salesDifferencePercentage: 0)
            analytics.append(totalBooksAnalytics)
        }
    }
    
    static func updateTotalMembers(count: Int) {
        if let index = analytics.firstIndex(where: { $0.title == "Members Registered" }) {
            analytics[index].value = Double(count)
        } else {
            let totalBooksAnalytics = Analytics(title: "Members Registered", value: Double(count), salesDifferencePercentage: 0)
            analytics.append(totalBooksAnalytics)
        }
    }
}


// struct for menu Items
struct MenuItem: Identifiable{
    var id: String { option }
    var optionIcon : String
    var option: String
    var destination: AnyView
    var isClickable: Bool
}




//putting menuLis in section header
struct Sections : Identifiable{
    var id : String{sectionHeader}
    var sectionHeader : String
    var menuItem : [MenuItem]
    
    static var section : [Sections]{
        [
            Sections(sectionHeader: "OverView", menuItem: [
                MenuItem(optionIcon: "majesticons_library-line", option: "Dashboard", destination: AnyView(LibrarianDashboard()), isClickable: true),
                MenuItem(optionIcon: "complaint", option: "Complaints", destination: AnyView(ComplaintsView()), isClickable: true),
                MenuItem(optionIcon: "events", option: "Events Dashboard", destination: AnyView(EventsDashboard()), isClickable: true),
                MenuItem(optionIcon: "payBills", option: "Make Payouts", destination: AnyView(EmptyView()), isClickable: false),
            ]),
            Sections(sectionHeader: "Books", menuItem: [
                MenuItem(optionIcon: "books", option: "Books Catalogue", destination: AnyView(BooksCatalogue( )), isClickable: true),
                MenuItem(optionIcon: "bookshelf", option: "Books Circulation", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "overdue", option: "Books Overdues/Fines", destination: AnyView(BookOverduesView()), isClickable: true),
                MenuItem(optionIcon: "bill", option: "Fine Management", destination: AnyView(EmptyView()), isClickable: false)
            ])
                ]
    }
}


//MARK: here
struct UpcomingEvent: Identifiable {
    var id = UUID()
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

    static var upcomingEvents: [UpcomingEvent] = []

    static func fetchUpcomingEvents(completion: @escaping () -> Void) {
        DataController.shared.fetchUpcomingEvents { result in
            switch result {
            case .success(let events):
                upcomingEvents = events.map { event in
                    UpcomingEvent(
                        name: event.name,
                        host: event.host,
                        date: event.date,
                        time: event.time,
                        address: event.address,
                        duration: event.duration,
                        description: event.description,
                        registeredMembers: event.registeredMembers,
                        tickets: event.tickets,
                        imageName: event.imageName,
                        fees: event.fees,
                        revenue: event.revenue,
                        status: event.status
                    )
                }
                print("Fetched Upcoming Events: \(upcomingEvents)")
                
                    
                
                completion()
            case .failure(let error):
                print("Failed to fetch upcoming events: \(error.localizedDescription)")
                completion()
            }
        }
    }
}

//MARK: upcoming events -: call on the librarian dashboard

struct UpcomingEventListView: View {
    @State private var events: [UpcomingEvent] = []

    var body: some View {
        VStack {
            ForEach(events) { event in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center) {
                        Image(event.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(.customButton)
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(event.name)
                                .font(.headline)
                                .foregroundColor(.mainFont)
                            
                            Text(event.host)
                                .font(.subheadline)
                                .foregroundColor(.mainFont)
                        }
                        .frame(maxWidth: 145)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.headline)
                                .foregroundColor(.mainFont)
                            
                            Text(formattedDate(event.date)) // Format date correctly
                                .font(.subheadline)
                                .foregroundColor(.mainFont)
                        }.frame(maxWidth: 85)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Price")
                                .font(.headline)
                                .foregroundColor(.mainFont)
                            
                            Text("\(event.fees)") // Display price correctly
                                .font(.subheadline)
                                .foregroundColor(.mainFont)
                        }.frame(maxWidth: 85)
                        
                        Spacer()
                        
                    }
                }
                .padding()
                .background(.clear)
                .cornerRadius(8)
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            fetchEvents()
        }
    }

    private func fetchEvents() {
        UpcomingEvent.fetchUpcomingEvents {
            // Update state variable to trigger view refresh
            self.events = UpcomingEvent.upcomingEvents
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct UpcomingEventListView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventListView()
    }
}


//to here


struct OverDueBookDetails : Identifiable, Equatable{
    
    var id : String{ISBN}
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var userName : String
    var OverDuePeriod : String
    var Fine : Double
    
    static var overDueBookDetail : [OverDueBookDetails]{
       [ OverDueBookDetails(ISBN: "#4235532",
                    imageName: "BookCover",
                    BookTitle: "Soul",
                    AuthorName: "Zek",
                    userName: "ash",
                    OverDuePeriod: "2 Days",
                    Fine: 40),
         OverDueBookDetails(ISBN: "#4235532",
                      imageName: "BookCover",
                      BookTitle: "Soul",
                      AuthorName: "Zek",
                      userName: "ash",
                      OverDuePeriod: "2 Days",
                      Fine: 40),
         OverDueBookDetails(ISBN: "#4235532",
                      imageName: "BookCover",
                      BookTitle: "Soul",
                      AuthorName: "Zek",
                      userName: "ash",
                      OverDuePeriod: "2 Days",
                      Fine: 40),
         OverDueBookDetails(ISBN: "#4235532",
                      imageName: "BookCover",
                      BookTitle: "Soul",
                      AuthorName: "Zek",
                      userName: "ash",
                      OverDuePeriod: "2 Days",
                      Fine: 40),
       ]
    }
}

var SideBarOptionList = [""]

struct NewlyArrivedBooks: Identifiable, Equatable {
    var id: String { bookCode }
    var bookCode: String
    var bookCover: String
    var bookTitle: String
    var author: String
    var genre: Genre
    var issuedDate: String
    var returnDate: String
    var status: String
    var quantity: Int
    var description: String
    var publisher: String
    var publishedDate: String
    var pageCount: Int
    var averageRating: Double

    static var newlyArrivedBooks: [NewlyArrivedBooks] = []
    
    static func fetchNewlyArrivedBooks(completion: @escaping () -> Void) {
        DataController.shared.fetchLastFourBooks { result in
            switch result {
            case .success(let books):
                // Convert Book to NewlyArrivedBooks if necessary
                newlyArrivedBooks = books.map { book in
                    NewlyArrivedBooks(
                        bookCode: book.bookCode,
                        bookCover: book.bookCover,
                        bookTitle: book.bookTitle,
                        author: book.author,
                        genre: book.genre,
                        issuedDate: book.issuedDate,
                        returnDate: book.returnDate,
                        status: book.status,
                        quantity: book.quantity ?? 0,
                        description: book.description ?? "",
                        publisher: book.publisher ?? "",
                        publishedDate: book.publishedDate ?? "",
                        pageCount: book.pageCount ?? 0,
                        averageRating: book.averageRating ?? 0.0
                    )
                }
                completion()
            case .failure(let error):
                print("Failed to fetch books: \(error.localizedDescription)")
                completion()
            }
        }
    }
}

