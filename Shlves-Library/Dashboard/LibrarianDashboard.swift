//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    var body: some View {
        
        NavigationStack{
            ZStack{
            backgroundView()
            VStack{
                HStack(spacing : 0){
                    VStack(alignment: .leading, spacing: 16){
                        userName(userName: "User")
                        todayDateAndTime()
                        
                    }
                    .padding(.all, 64)
                    card(title: "Today’s Revenue",
                         value: 221, salesDifferencePercentage: 2.5)
                }
                .padding(.trailing, 462)
                ScrollView{
                    VStack{
                        //inside this write BookCircilation
                        VStack(alignment: .leading,spacing: 20){
                            AnalyticHeader(title: "Main Analytics Below")
                            ScrollView{
                                HStack(spacing: 20){
                                    DashboardAnalytics()
                                }
                                .padding(.leading,64)
                            }
                            VStack(alignment: .leading, spacing: 20){
                                AnalyticHeader(title: "Main Analytics Below")
                                ScrollView{
                                    HStack(spacing: 20){
                                        DashboardAnalytics()
                                    }
                                    .padding(.leading,64)
                                }
                                //here
                            }
                            .padding([.bottom], 16)
                            Spacer()
                        }
                        .padding([.top,.bottom], 16)
                        Spacer()
                        BookCirculationCard()
                    }
                }
                
            }
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
            }
    }
 }
}

struct backgroundView : View {
    var body: some View {
        Color("dashboardbg").ignoresSafeArea()
        
    }
}

struct BookCirculationCard : View {
    var body: some View {
        Rectangle()
            .foregroundStyle(.white)
            .frame(width: .infinity, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
    LibrarianDashboard()
}
