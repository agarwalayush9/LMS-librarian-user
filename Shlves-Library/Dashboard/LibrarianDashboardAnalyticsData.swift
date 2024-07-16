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
                MenuItem(optionIcon: "Library", option: "Dashboard", destination: AnyView(LibrarianDashboard()), isClickable: true),
                MenuItem(optionIcon: "Complaints", option: "Complaints", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "ManageEvents", option: "Events Dashboard", destination: AnyView(EventsDashboard()), isClickable: true),
                MenuItem(optionIcon: "MakePayouts", option: "Make Payouts", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "UserQueries", option: "User Queries", destination: AnyView(EmptyView()), isClickable: false),
            ]),
            Sections(sectionHeader: "Books", menuItem: [
                MenuItem(optionIcon: "BooksCatalogue", option: "Books Catalogue", destination: AnyView(BooksCatalogue( )), isClickable: true),
                MenuItem(optionIcon: "BooksCirculation", option: "Books Circulation", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "BookOverdues", option: "Books Overdues/Fines", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "FineManagement", option: "Fine Management", destination: AnyView(EmptyView()), isClickable: false)
            ])
                ]
    }
}


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
