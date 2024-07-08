//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    @State private var menuOpened = false
    @State  var AddButtonPressed = true
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                backgroundView()
                    .ignoresSafeArea(.all)
                    .blur(radius: menuOpened ? 10 : 0)
                    .animation(.easeInOut(duration: 0.25), value: menuOpened)

                ScrollView {
                    VStack {
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 16) {
                                userName(userName: "User")
                                todayDateAndTime()
                            }
                            .padding(.all, 64)
                        }
                        .padding(.trailing, 462)

                        VStack {
                            // Inside this write BookCirculation
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
                            BookCirculationCard(minHeight: 160, title: "Book Circulation")
                                .padding([.leading, .trailing], 64)

                            HStack {
                                VStack {
                                    overDueBooksDetailData()
                                        .padding(.top, 80)
                                }
                                .background(
                                    BookCirculationCard(minHeight: 160, title: "Overdue Book Details")
                                        .padding(.bottom, 16)
                                )

                                Spacer()

                                VStack {
                                    NewlyArrivedBooksDetailData()
                                        .padding(.top, 80)
                                }
                                .background(
                                    BookCirculationCard(minHeight: 160, title: "Newly Arrived Books")
                                        .padding(.bottom, 16)
                                )
                            }
                            .padding([.leading, .trailing], 64)
                            .padding(.bottom, 85)
                        }
                    }
                }

                // Tab bar
                Rectangle()
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.07)
                    .foregroundColor(Color("librarianDashboardTabBar"))
                    .overlay(
                        HStack(alignment: .center) {
                            
                            // this isfor showng add button itself
                            if AddButtonPressed{ Button(action: {
                                print("Add pressed")
                                AddButtonPressed.toggle()
                            }, label: {
                                CustomButton(systemImage: "plus",
                                             width: 98,
                                             height: 39,
                                             title: "Add",
                                             colorName: "CustomButtonColor")
                            })
                            }else{
                                
                                
                                Button(action: {
                                    print("crossButtonPressed")
                                    AddButtonPressed.toggle()
                                }, label: {
                                    circleCancleButton(width: 50,
                                                       colorName: "CustomButtonColor",
                                                       systemImage: "multiply"
                                                      )

                                })
                            }
                            
                            //.padding()
                            Spacer()
                            //This is for Add button extension
                            if AddButtonPressed{
                                showTabBarButtons()
                            }else{
                                showAddBarExtension()
                            }
                            
                                
                        }
                        .padding([.top, .leading])
                    )
                    .ignoresSafeArea()

                if menuOpened {
                    sideMenu(width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                }
            }
            .navigationTitle("lms".capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        menuOpened.toggle()
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
            }
            
        }
        
    }

    func toggleMenu() {
        menuOpened.toggle()
    }
}




#Preview {
    LibrarianDashboard()
}


struct showTabBarButtons : View {
    var body: some View {
        Button(action: {
        print("Lend Book Pressed")
    }, label: {
        CustomButton(systemImage: "",
                     width: 150,
                     height: 39,
                     title: "Lend Book",
                     colorName: "CustomButtonColor")      })
    
    Button(action: {
        print("Return Book Pressed")
    }, label: {
        CustomButton(systemImage: "",
                     width: 180,
                     height: 39,
                     title: "Return Book",
                     colorName: "CustomButtonColor")      })
    .padding()
    }
}

struct showAddBarExtension : View {
    var body: some View {
        Button(action: {
        print("Add User Pressed")
    }, label: {
        CustomButton(systemImage: "person.fill.badge.plus",
                     width: 150,
                     height: 39,
                     title: "Add User",
                     colorName: "CustomButtonColor")      })
    
    Button(action: {
        print("Add Books Pressed")
    }, label: {
        CustomButton(systemImage: "books.vertical.fill",
                     width: 180,
                     height: 39,
                     title: "Add Books",
                     colorName: "CustomButtonColor")      })
    .padding()
    }
}



struct circleCancleButton : View {
    var width : Double
    var colorName : String
    var systemImage : String
    var body: some View {
        Circle()
            .frame(width: width, height: width)
            //.background(Color(colorName))
            .foregroundColor(Color(colorName))
            .overlay(
                Image(systemName: systemImage)
                    .foregroundStyle(.white)
                    )
    }
}
