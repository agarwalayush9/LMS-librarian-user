//
//  LibrarianDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import SwiftUI

struct LibrarianDashboard: View {
    @State private var menuOpened = false
    @State private var AddButtonPressed = false
    @State private var navigateToNotificationScreen = false
    @State private var navigateToUserRecord = false
    @State private var isRequestBooks = false
    @State private var isReturnBooks = false
    @State private var isAddEventPressed = false
    @State private var showModal = false

    
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

                         ScrollView{
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
                                    //MARK: 2nd line of Librarian
                                }
                                .padding([.top, .bottom], 16)
                                Spacer()
                                BookCirculationCard(minHeight: 160, title: "Book Circulation")
                                    .padding([.leading, .trailing], 64)
                                    

                                HStack(alignment: .top) {
                                    VStack {
                                        //overDueBooksDetailData()
                                        UpcomingEventListView()
                                            .padding(.top, 80)
                                    }
                                    .background(
                                        BookCirculationCard(minHeight: 200, title: "Upcoming Events")
                                            .padding(.bottom, 16)
                                    )

                                    Spacer()

                                    VStack {
                                        
                                        NewlyArrivedBooksDetailData()
                                            .padding(.top, 80)
                                    }
                                    .background(
                                        BookCirculationCard(minHeight: 200, title: "Newly Arrived Books")
                                            .padding(.bottom, 16)
                                    )
                                }
                                .padding([.leading, .trailing], 64)
                                .padding(.bottom, 85)
                                Spacer()
                            }
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
                            if !AddButtonPressed {
                                //MARK: make this button a struct
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        
                                        
                                        AddButtonPressed.toggle()
                                        UpcomingEvent.fetchUpcomingEvents {
                                            print("Events have been fetched")
                                            print(UpcomingEvent.upcomingEvents) // This should print the fetched events
                                        }
                            
                                        
                                        //AddButtonPressed.toggle()
                                    }
                                }, label: {
                                    CustomButton(systemImage: "plus",
                                                 width: 98,
                                                 height: 39,
                                                 title: "Add",
                                                 colorName: "CustomButtonColor")                                })
                                    
                            }

                            if AddButtonPressed {
                                showAddBarExtension(AddbuttonPressed: $AddButtonPressed)
                                    .transition(.offset(x: AddButtonPressed ? -UIScreen.main.bounds.width  : 0,
                                                        y: 0))
                                    //.animation(.easeInOut, value: AddButtonPressed)
                                    
                            }
                            
                            Spacer()
                            showTabBarButtons()
                        }
                        .padding([.top, .leading])
                       // .padding(.leading, 50)
                        
                    )
                    .ignoresSafeArea()


                if menuOpened {
                    sideMenu(width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                    .transition(.offset(x: menuOpened ? -UIScreen.main.bounds.width : 0))

                }
            }
            .navigationTitle("lms".capitalized)
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
                            .foregroundStyle(Color.mainFont)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                   
                    HStack{
                                            Button(action: {
                                                // Add action for books vertical button
                                                navigateToNotificationScreen = true
                                                
                                            }, label: {
                                                Image(systemName: "bell")
                                                    .foregroundColor(Color.mainFont)
                                            })
                                            .sheet(isPresented: $navigateToNotificationScreen, content: {
                                                NotificationScreen()
                                            })
                    }
                    //end here
                }
            }
            //enter destinations here
            .sheet(isPresented: $showModal) {
                            NotificationScreen()
                        }
        }
        
    }

    func toggleMenu() {
        withAnimation(.easeInOut){
            menuOpened.toggle()
        }
    }
}



struct showTabBarButtons : View {
    @State private var isRequestBooks = false
    @State private var isReturnBooks = false
    @State private var isAddEventPressed = false

    var body: some View {
        VStack {
            HStack {
                // Add Event Button
                Button(action: {
                    print("Add Event Pressed")
                    isAddEventPressed.toggle()
                }, label: {
                    CustomButton(systemImage: "",
                                 width: 170,
                                 height: 39,
                                 title: "Add Event",
                                 colorName: "CustomButtonColor")
                })
                .sheet(isPresented: $isAddEventPressed) {
                    EventFormView()
                }

                // Request Book Button
                Button(action: {
                    print("Request Book Pressed")
                    isRequestBooks.toggle()
                }, label: {
                    CustomButton(systemImage: "",
                                 width: 170,
                                 height: 39,
                                 title: "Book Requests",
                                 colorName: "CustomButtonColor")
                })
                .sheet(isPresented: $isRequestBooks) {
                    BookRequest(ISBN: "12345678",
                                BookImage: "book_cover",
                                BookTitle: "Soul",
                                AuthorName: "zek",
                                UserName: "Abhay",
                                UserID: "224455",
                                RequestedDate: "14-Jul-202")
                }

                // Return Book Button
                Button(action: {
                    print("Return Book Pressed")
                    isReturnBooks.toggle()
                }, label: {
                    CustomButton(systemImage: "",
                                 width: 180,
                                 height: 39,
                                 title: "Return Requests",
                                 colorName: "CustomButtonColor")
                })
                .sheet(isPresented: $isReturnBooks) {
                    ReturnBook(ISBN: "12345678",
                               BookImage: "book_cover",
                               BookTitle: "Soul",
                               AuthorName: "zek",
                               UserName: "Abhay",
                               UserID: "224455",
                               RequestedDate: "14-Jul-202",
                               OverDuePeriod: "2",
                               fine: 40)
                }
                .padding()
            }
            .padding()
        }
    }
}

struct showAddBarExtension : View {
    @Binding var AddbuttonPressed : Bool
    @State private var showingAddBookOptions = false
    @State private var books: [Book] = []
    
    @State private var showingAddUserDetails = false
    @State private var users = []
    
    var body: some View {
        HStack{
            Button(action: {
               print("pressed")
                toggleAddButtonPressed()
                
            }, label: {
                circleCancleButton(width: 50,
                                   colorName: "CustomButtonColor",
                                   systemImage: "multiply")

            })
            
            Button(action: {
                print("Add User Pressed")
                
                showingAddUserDetails.toggle()
                
            }){
                
                CustomButton(systemImage: "person.fill.badge.plus",
                             width: 150,
                             height: 39,
                             title: "Add User",
                             colorName: "CustomButtonColor")
            }.sheet(isPresented: $showingAddUserDetails) {
                AddUserDetailsView { newUser in
                    users.append(newUser)
                }
            }
            
            
            Button(action: {
                print("Add Books Pressed")
                
                showingAddBookOptions.toggle()
            }){
                CustomButton(systemImage: "books.vertical.fill",
                             width: 180,
                             height: 39,
                             title: "Add Books",
                             colorName: "CustomButtonColor")

                }
            .sheet(isPresented: $showingAddBookOptions) {
                AddBookOptionsView(addBook: { newBook in
                    books.append(newBook)
                }, books: books)
            }
            //    .padding()
            
            
        }
        .padding(.leading, 30)
    }
    func toggleAddButtonPressed(){
        
        AddbuttonPressed.toggle()
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

#Preview {
    LibrarianDashboard()
}


