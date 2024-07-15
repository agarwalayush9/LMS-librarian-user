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
    @State private var navigateToBookCatalogue = false
    @State private var navigateToUserRecord = false
    @State private var isRequestBooks = false
       @State private var isReturnBooks = false
    
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
                            if !AddButtonPressed {
                                //MARK: make this button a struct
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        AddButtonPressed.toggle()
                                        
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
                            showTabBarButtons(isRequestBooks: $isRequestBooks, isReturnBooks: $isReturnBooks)
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
                            .foregroundStyle(Color.black)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    // start here
//                    Button(action: {
//                        // Add action for books vertical button
//                        navigateToUserRecord = true
//                    }, label: {
//                        Image(systemName: "books.vertical")
//                            .foregroundColor(Color.black)
//                    })
                    HStack{
                                            Button(action: {
                                                // Add action for books vertical button
                                                navigateToBookCatalogue = true
                                                
                                            }, label: {
                                                Image(systemName: "books.vertical")
                                                    .foregroundColor(Color.black)
                                            })
                                            Button(action: {
                                                // Add action for books vertical button
                                                //navigateToBookCatalogue = true
                                                navigateToUserRecord = true
                                                
                                            }, label: {
                                                Image(systemName: "person.3.fill")
                                                    .foregroundColor(Color.black)
                                            })
                                        }
                    //end here
                }
            }
            //enter destinations here
            .navigationDestination(isPresented: $navigateToBookCatalogue) {
                                        BooksCatalogue()
                                    }
                        .navigationDestination(isPresented: $navigateToUserRecord){
                            UsersCatalogue()
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
    
    @Binding var isRequestBooks : Bool
        @Binding var isReturnBooks : Bool
    
    
    
    var body: some View {
        
        Button(action: {
        print("Request Book Pressed")
            isRequestBooks.toggle()
    }, label: {
        CustomButton(systemImage: "",
                     width: 170,
                     height: 39,
                     title: "Book Requests",
                     colorName: "CustomButtonColor")      })
        .sheet(isPresented: $isRequestBooks){
                    
                    //MARK: make for each here
                    BookRequest(ISBN: "12345678",
                                BookImage: "book_cover",
                                BookTitle: "Soul",
                                AuthorName: "zek",
                                UserName: "Abhay",
                                UserID: "224455",
                                RequestedDate: "14-Jul-202")
                }
        
        
        Button(action: {
                print("Return Book Pressed")
                isReturnBooks.toggle()
            }, label: {
                CustomButton(systemImage: "",
                             width: 180,
                             height: 39,
                             title: "Return Requests",
                             colorName: "CustomButtonColor")      })
            .sheet(isPresented: $isReturnBooks, content: {
                //MARK: make foreach here
                ReturnBook(ISBN: "12345678",
                            BookImage: "book_cover",
                            BookTitle: "Soul",
                            AuthorName: "zek",
                            UserName: "Abhay",
                            UserID: "224455",
                            RequestedDate: "14-Jul-202",
                           OverDuePeriod: "2",
                fine: 40)

            })
            .padding()
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
