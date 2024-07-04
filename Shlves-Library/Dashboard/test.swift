//
//  test.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct test: View {
    
    let data = Analytics.analytics

    var body: some View {
        ZStack{
            backgroundView()
            VStack{
                HStack(spacing : 0){
                    VStack(alignment: .leading, spacing: 16){
                        userName(userName: "Ankit")
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
                        AnalyticHeader(title: "Main Analtics Below")
                        ScrollView{
                            HStack{
                                DashboardAnalytics()
                            }
                            .padding(.leading,64)
                        }
                        VStack(alignment: .leading, spacing: 20){
                            AnalyticHeader(title: "Main Analtics Below")
                            ScrollView{
                                HStack{
                                    DashboardAnalytics()
                                }
                                .padding(.leading,64)
                            }
                            //here
                        }
                        .padding([.bottom], 16)
                        Spacer()
                        
                        AnalyticHeader(title: "Main Analtics Below")
                        ScrollView{
                            HStack{
                                DashboardAnalytics()
                            }
                            .padding(.leading,64)
                        }
                    }
                    .padding([.top,.bottom], 16)
                    Spacer()
                }
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

#Preview {
    test()
}
