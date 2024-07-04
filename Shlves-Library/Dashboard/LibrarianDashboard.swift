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
            
            BookCirculationCarData()
            BookCirculationCarData()
            BookCirculationCarData()
            BookCirculationCarData()
                
            Spacer()
        }
        .padding()
        .background(Color.white).frame(minHeight: 160)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct BookCirculationCarData: View {
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

#Preview {
    LibrarianDashboard()
}
