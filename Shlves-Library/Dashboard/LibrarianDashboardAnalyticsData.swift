//
//  LibrarianDashboardAnalyticsData.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import Foundation

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

struct BookDetails : Identifiable, Equatable{
    
    var id : String{ISBN}
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var userName : String
    var OverDuePeriod : String
    var Fine : Double
    
    static var bookDetail : [BookDetails]{
       [ BookDetails(ISBN: "#4235532",
                    imageName: "BookCover",
                    BookTitle: "Soul",
                    AuthorName: "Zek",
                    userName: "ash",
                    OverDuePeriod: "2 Days",
                    Fine: 40),
         BookDetails(ISBN: "#4235532",
                      imageName: "BookCover",
                      BookTitle: "Soul",
                      AuthorName: "Zek",
                      userName: "ash",
                      OverDuePeriod: "2 Days",
                      Fine: 40),
         BookDetails(ISBN: "#4235532",
                      imageName: "BookCover",
                      BookTitle: "Soul",
                      AuthorName: "Zek",
                      userName: "ash",
                      OverDuePeriod: "2 Days",
                      Fine: 40),
         BookDetails(ISBN: "#4235532",
                      imageName: "BookCover",
                      BookTitle: "Soul",
                      AuthorName: "Zek",
                      userName: "ash",
                      OverDuePeriod: "2 Days",
                      Fine: 40),
       ]
    }
}
