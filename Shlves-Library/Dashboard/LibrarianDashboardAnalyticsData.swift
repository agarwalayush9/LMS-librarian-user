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
    
    static var analytics : [Analytics]{
        [
            Analytics(title: "Today's Revenue", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "New Members", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Books Issued", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Lost or Damaged Books", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Today's Revenue", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "New Members", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Books Issued", value: 221, salesDifferencePercentage: 2.5),
            Analytics(title: "Lost or Damaged Books", value: 221, salesDifferencePercentage: 2.5),
        ]
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
                MenuItem(optionIcon: "complaint", option: "Complaints", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "events", option: "Events Dashboard", destination: AnyView(EventsDashboard()), isClickable: true),
                MenuItem(optionIcon: "payBills", option: "Make Payouts", destination: AnyView(EmptyView()), isClickable: false),
            ]),
            Sections(sectionHeader: "Books", menuItem: [
                MenuItem(optionIcon: "books", option: "Books Catalogue", destination: AnyView(BooksCatalogue( )), isClickable: true),
                MenuItem(optionIcon: "bookshelf", option: "Books Circulation", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "overdue", option: "Books Overdues/Fines", destination: AnyView(EmptyView()), isClickable: false),
                MenuItem(optionIcon: "bill", option: "Fine Management", destination: AnyView(EmptyView()), isClickable: false)
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

struct NewlyArrivedBooks : Identifiable, Equatable{
    
    var id : String{ISBN}
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var Quantity : Int
    var ArivedDate : String
    
    static var newlyArrivedBook : [NewlyArrivedBooks]{
        [
            NewlyArrivedBooks(ISBN: "#4235532",
                              imageName: "BookCover",
                              BookTitle: "Soul",
                              AuthorName: "Zek",
                              Quantity: 60,
                              ArivedDate: "23 Jun 2024"),
            NewlyArrivedBooks(ISBN: "#4235532",
                              imageName: "BookCover",
                              BookTitle: "Soul",
                              AuthorName: "Zek",
                              Quantity: 60,
                              ArivedDate: "23 Jun 2024"),
            NewlyArrivedBooks(ISBN: "#4235532",
                              imageName: "BookCover",
                              BookTitle: "Soul",
                              AuthorName: "Zek",
                              Quantity: 60,
                              ArivedDate: "23 Jun 2024"),
            NewlyArrivedBooks(ISBN: "#4235532",
                              imageName: "BookCover",
                              BookTitle: "Soul",
                              AuthorName: "Zek",
                              Quantity: 60,
                              ArivedDate: "23 Jun 2024"),
        ]
    }
}
