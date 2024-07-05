//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    var data = BookDetails.bookDetail
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottom){
            backgroundView()
                    .ignoresSafeArea(.all)
            VStack{
                HStack(spacing : 0){
                    VStack(alignment: .leading, spacing: 16){
                        userName(userName: "User")
                        todayDateAndTime()
                        
                    }
                   .padding(.all, 64)

                }
                .padding(.trailing, 462)
                ScrollView{
                    VStack{
                        //inside this write BookCircilation
                        VStack(alignment: .leading,spacing: 20){
                            AnalyticHeader(title: "Main Analytics Below")
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack(spacing: 20){
                                    DashboardAnalytics()
                                }
                                .padding(.leading,64)
                            }
                            VStack(alignment: .leading, spacing: 20){
                                AnalyticHeader(title: "Main Analytics Below")
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack(spacing: 20){
                                        DashboardAnalytics()
                                    }
                                    .padding(.leading,64)
                                }
                                
                            }
                            .padding([.bottom], 16)
                            Spacer()
                        }
                        .padding([.top,.bottom], 16)
                        Spacer()
                        BookCirculationCard(minHeight: 160,
                                            title: "Book Circulation")
                        .padding([.leading, .trailing], 64)
                            
                        HStack(){
                            BookCirculationCard(minHeight: 160,
                                                title: "Overdue Book Details")
                            Spacer()
                            BookCirculationCard(minHeight: 160,
                                                title: "Online Book Requests")
//                            ForEach(data){ datum in
//                                showingDetails(ISBN: datum.ISBN, 
//                                               imageName: datum.imageName,
//                                               BookTitle: datum.BookTitle, 
//                                               AuthorName: datum.AuthorName,
//                                               userName: datum.userName,
//                                               OverDuePeriod: datum.OverDuePeriod,
//                                               Fine: datum.Fine)
//                            }
                        }
                        .padding([.leading, .trailing],64)
                        .padding(.bottom, 85)
                        
                    }
                }
                
            }
            
                Rectangle()
                    .ignoresSafeArea()
                    .frame(width: .infinity,
                           height: 80)
                    .foregroundColor(Color("librarianDashboardTabBar"))
                
                
        }
            .navigationTitle("LMS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.black)
                    })
                    
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.black)
                    })
                }
            }
    }
 }
}

struct backgroundView : View {
    var body: some View {
        Color("dashboardbg").ignoresSafeArea()
        
    }
}


struct BookCirculationCard: View {
    
    var minHeight : CGFloat
    var title : String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            
            BookCirculationCardData(bookTitle: "Soul", authorName: "zek")
            Spacer()
        }
        .padding()
        .background(Color.white).frame(minHeight: minHeight)
        .clipShape(RoundedRectangle(cornerRadius: 12))

    }
}

struct showingDetails : View {
    
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var userName : String
    var OverDuePeriod : String
    var Fine : Double
    
    var body: some View {
        VStack {
            HStack{
    //            BookCirculationCardData(bookTitle: bookTitle,
    //                                    authorName: authorName)
                bookInfo(bookTitle: BookTitle,
                         authorName: AuthorName, 
                         ISBN: ISBN,
                         imageName: imageName)
                .padding()
                userInfo(userName: userName,
                         OverDuePeriod: OverDuePeriod, Fine: Fine)
            }
        }
    }
}

struct BookCirculationCardData : View {
    
    var bookTitle : String
    var authorName : String
    
    var body: some View {
        VStack (spacing : 30){
            HStack{
//                bookInfo(bookTitle: "soul", authorName: "zek")
                    //.padding(.leading, 128)
                Spacer()
                    
            }
        }
        
    }
}

struct userInfo : View {
    var userName : String
    var OverDuePeriod: String
    var Fine : Double
    var body: some View {
        HStack{
            Text(userName)
            Spacer()
            VStack{
                Text("Overdue")
                    .padding()
                Text("\(OverDuePeriod) days")
            }
            Spacer()
            VStack{
                Text("Fine")
                    .padding()
                Text("\(Fine)")
            }
        }
    }
}

struct bookInfo : View {
    
    var bookTitle : String
    var authorName : String
    var ISBN : String
    var imageName : String
    var body: some View {
        HStack(spacing : 20){
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 79, height: 125)
            .background(
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 79, height: 125)
                    .clipped()
            )
            .padding(.bottom, 12)
        VStack{
            Rectangle()
                .frame(width: 90, height: 25)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(Color("ISBNContainerColor"))
                .overlay(
                    Text(ISBN)
                        .font(
                            Font.custom("DM Sans", size: 14)
                                .weight(.medium)
                        )
                        .foregroundColor(.black)
                )
            
            Text(bookTitle)
                .font(
                    Font.custom("DM Sans", size: 25)
                        .weight(.medium)
                )
                .foregroundColor(.black)
            Text(authorName)
            //Text("by Shshank")
                .font(
                    Font.custom("DM Sans", size: 17)
                        .weight(.medium)
                )
                .foregroundColor(Color("AuthorNameColor"))
            
        }
        
        // user Details go here
        
    }
    }
}

struct memberData : View {
    var body: some View {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 90.64484, height: 64.45855)
          .background(
            Image(systemName: "person.3")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 90.64483642578125, height: 64.45854949951172)
              .clipped()
          )
    }
}

#Preview {
    LibrarianDashboard()
}
