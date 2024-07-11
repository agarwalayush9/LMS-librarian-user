//
//  EventsDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 10/07/24.
//

import SwiftUI

struct EventsDashboard: View {
    @State private var menuOpened = false
    var body: some View {
        NavigationStack {
            ZStack{
                VStack{
                    HStack{
                        ScrollView {
                            VStack(alignment: .leading){
                                Text("Manage Events")
                                    .font(
                                    Font.custom("DM Sans", size: 52)
                                    .weight(.medium)
                                    )
                                
                                    //Event Revenue Details Card
                                    customGraphCard(width: 730,
                                                    height: 250)
                                    
                                
                                //MARK: Line 2
                                HStack{
                                    // Total Event Visitors Card
                                    customGraphCard(width: 437,
                                                    height: 243)
                                    .padding(.trailing)
                                    //Today's Event Card
                                    customGraphCard(width: 270,
                                                    height: 243)
                                    
                                }
                                //MARK: Line 3
                                HStack{
                                    //Tickets status Card
                                    customGraphCard(width: 270,
                                                    height: 243)
                                    .padding(.trailing)
                                    // Total Event Visitors Card
                                    customGraphCard(width: 437,
                                                    height: 243)
                                }
                                
                                Spacer()
                            }
                                .padding(.trailing, 64)
                                
                        }
                        //MARK: Right of Manage event
                        ScrollView {
                            VStack(alignment : .leading){
                                //Calender Card
                                customGraphCard(width: 344 ,
                                                height: 285)
                                .padding([.leading, .trailing])
                                HStack{
                                    Text("Upcoming Events")
                                        .font(
                                            Font.custom("DM sans", size: 36)
                                                .weight(.bold)
                                        )
                                    Text("See All")
                                        .frame(alignment: .bottom)
                                        .font(
                                            Font.custom("DM sans", size: 14)
                                                .weight(.medium)
                                        ).foregroundStyle(Color("CustomButtonColor"))
                                }.padding([.leading, .trailing])
                                
                                //MARK: beneath will be two closest upcoming events only 2
                                
                                //Probably i'll make this a list
                                Text("Tomorrow")
                                    .font(
                                        Font.custom("DM sans", size: 16)
                                            .weight(.bold)
                                    )
                                    .padding(.top, 1)
                                    .padding([.leading, .trailing])
                                customGraphCard(width: 344, height: 194)
                                    .padding([.leading, .trailing])
                                
                                Text("15 JULY")
                                    .font(
                                        Font.custom("DM sans", size: 16)
                                            .weight(.bold)
                                    ).padding(.top, 22)
                                    .padding([.leading, .trailing])
                                
                                customGraphCard(width: 344, height: 194)
                                    .padding([.leading, .trailing])
                                
                                //till here
                                
                            }
                        }.padding([.leading, .trailing], 30)
                            Spacer()
                    }
                    
                }
                .padding([.top, .leading], 64)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                
                
                
                
                
                
                //This is to be the last part of z Stack
                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                    .transition(.offset(x: menuOpened ? -UIScreen.main.bounds.width : 0))

                }
            }
            //navigation Bar Mark ~zek
            .navigationTitle("Manager Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation{
                            menuOpened.toggle()
                        }
                    }, label: {
                        Image(systemName: "sidebar.left")
                            .foregroundStyle(Color.black)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Add action for books vertical button
                    }, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.black)
                    })
                }
            }//Navigation bar ends    ~
        }
    }
    func toggleMenu() {
        withAnimation(.easeInOut){
        menuOpened.toggle()
        }
    }
}

#Preview {
    EventsDashboard()
}

func textColorChanger(title : String) -> Text{
    return Text(title)
        .font(
        Font.custom("DM Sans", size: 52)
        .weight(.medium)
        )
        .foregroundColor(.customButton)
}

struct customGraphCard: View {
    var width : Double
    var height : Double
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(Color(.yellow))
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
