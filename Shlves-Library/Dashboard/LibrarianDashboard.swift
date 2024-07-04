//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    @State private var navigateToBookCatalogue = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView()
                VStack {
                    HStack(spacing: 0) {
                        VStack(alignment: .leading, spacing: 16) {
                            userName(userName: "User")
                            todayDateAndTime()
                        }
                        .padding(.all, 64)
                        card(title: "Today’s Revenue",
                             value: 221, salesDifferencePercentage: 2.5)
                    }
                    .padding(.trailing, 462)
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: 20) {
                                AnalyticHeader(title: "Main Analytics Below")
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        DashboardAnalytics()
                                    }
                                    .padding(.leading, 64)
                                }
                                VStack(alignment: .leading, spacing: 20) {
                                    AnalyticHeader(title: "Main Analytics Below")
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 20) {
                                            DashboardAnalytics()
                                        }
                                        .padding(.leading, 64)
                                    }
                                }
                                .padding([.bottom], 16)
                                Spacer()
                            }
                            .padding([.top, .bottom], 16)
                            Spacer()
                            BookCirculationCard()
                                .padding([.leading, .trailing], 64)
                        }
                    }
                }

                
                Rectangle()
                    .frame(width: .infinity,height: 98,alignment: .bottom).ignoresSafeArea()
                    .foregroundStyle(Color("librarianDashboardTabBar"))
                    
            }
            
            .ignoresSafeArea(edges: .bottom )
        }

            }

            .navigationTitle("LMS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        // Action for the left button
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.black)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        navigateToBookCatalogue = true
                    }, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.black)
                    })
                }
            }
            .navigationDestination(isPresented: $navigateToBookCatalogue) {
                BooksCatalogue()
            }
        }



struct backgroundView: View {
    var body: some View {
        Color("dashboardbg").ignoresSafeArea()
    }
}

struct BookCirculationCard: View {
    var body: some View {
        VStack {
            HStack {
                Text("Book Circulation")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            

            BookCirculationCardData(bookTitle: "Soul", authorName: "zek")

            BookCirculationCardData(bookTitle: "Soul", authorName: "zek")
                

            Spacer()
        }
        .padding()
        .background(Color.white).frame(minHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}




struct BookCirculationCardData : View {
    
    var bookTitle : String
    var authorName : String
    
    var body: some View {
        VStack (spacing : 30){
            HStack{
                bookInfo(bookTitle: "soul", authorName: "zek")
                    .padding(.leading, 128)
                Spacer()
                
                
                struct BookCirculationCardData: View {
                    var body: some View {
                        HStack {
                            Image("BookCover")
                                .padding(.bottom, 16)
                            VStack {
                                Rectangle()
                                    .frame(width: 90, height: 25)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .foregroundStyle(Color("ISBNContainerColor"))
                                    .overlay(
                                        Text("#4235532")
                                            .font(
                                                Font.custom("DM Sans", size: 14)
                                                    .weight(.medium)
                                            )
                                            .foregroundColor(.black)
                                    )
                                
                            }
                        }
                    }
                }
                
                struct BookCatalogue: View {
                    var body: some View {
                        Text("Book Catalogue")
                            .font(.largeTitle)
                    }
                }
                
                struct bookInfo : View {
                    
                    var bookTitle : String
                    var authorName : String
                    
                    var body: some View {
                        HStack(spacing : 20){
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 79, height: 125)
                                .background(
                                    Image("BookCover")
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
                                        Text("#4235532")
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
                                Text("by abhay")
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
                                Image("PATH_TO_IMAGE")
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
