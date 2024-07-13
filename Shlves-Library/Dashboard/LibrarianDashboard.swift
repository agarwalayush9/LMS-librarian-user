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
    @Binding var isLoggedIn: Bool
    @State private var isLendBooks = false
    
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
                            showTabBarButtons(isLendBooks: $isLendBooks)
                        }
                        .padding([.top, .leading])
                       // .padding(.leading, 50)
                        
                    )
                    .ignoresSafeArea()


                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30,
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
    
    @Binding var isLendBooks : Bool
    
    var body: some View {
        
        Button(action: {
        print("Request Book Pressed")
            isLendBooks.toggle()
            
    }, label: {
        CustomButton(systemImage: "",
                     width: 180,
                     height: 39,
                     title: "Book Request",
                     colorName: "CustomButtonColor")      })
        .sheet(isPresented: $isLendBooks){
            
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
    }, label: {
        CustomButton(systemImage: "",
                     width: 180,
                     height: 39,
                     title: "Return Book",
                     colorName: "CustomButtonColor")      })
    .padding()
    }
}


//MARK: Lend Book form
//This will be depricated
struct BookRequestForm : View {
    //@State private var BookCode : String
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                Text("Lend Books")
                    .font(
                    Font.custom("DM Sans", size: 32)
                    .weight(.bold)
                    )
                //Spacer()
                //
            }
        }
    }
}



struct showAddBarExtension : View {
    @Binding var AddbuttonPressed : Bool
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
    LibrarianDashboard(isLoggedIn: .constant(true))
    
}

//MARK: LendBookCustom field
//This will be depricated most probably
struct LendBookCustomField: View {
   @State private var title : String
    @State private var placeHolder : String
    @State private var fieldData : String
    var height : Double
    
    
    init(title: String, fieldData: String, placeHolder: String, height: Double) {
        self.title = title
        self.fieldData = fieldData
        self.placeHolder = placeHolder
        self.height = height
        
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(title)
            .font(
                Font.custom("DM Sans", size: 20)
                    .weight(.bold)
            )
            .padding(.bottom, 10)
        TextField(placeHolder, text: $fieldData)
            .padding(.leading)
            .frame(maxWidth: 585, minHeight: height)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .inset(by: -2)
                    .stroke(Color("CustomButtonColor"), lineWidth: 4)
            )
            .background(.textFormFieldBg)
            .padding(.bottom, 20)
        }
    }
}
