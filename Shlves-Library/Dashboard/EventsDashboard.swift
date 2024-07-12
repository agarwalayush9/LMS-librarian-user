//
//  EventsDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 10/07/24.
//

import SwiftUI

struct EventsDashboard: View {
    @State private var menuOpened = false
    @State private var showPopover = false

    var body: some View {
        NavigationStack {
            ZStack{
                //calling main screen struct
                EventAnalyticsCard()
                //This is to be the last part of z Stack
                if menuOpened {
                    sideMenu(isLoggedIn: .constant(true), width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                    .transition(.offset(x: menuOpened ? -UIScreen.main.bounds.width : 0))
                    
                }
                //calling create an event button
                floatingEventButtonView(showPopover : $showPopover)
            }
            .background(Color("dashboardbg"))
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
    CreateUserForm()
}

func textColorChanger(title : String) -> Text{
    return Text(title)
        .font(
            Font.custom("DMSans-Medium", size: 52)
        )
        .foregroundColor(.customButton)
}

struct customGraphCard: View {
    var width : Double
    var height : Double
    var body: some View {
        Rectangle()
        //            .frame(width: width, height: height)
            .frame(minHeight: height)
            .frame(maxWidth: width)
            .foregroundStyle(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct customEventCard: View {
    var width : Double
    var height : Double
    //    var imageName : CIImage
    //    var eventName : String
    //    var eventDate : String
    //    var eventLocation : String
    //    var hostName : String
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                HStack{
                    Image("book_cover")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 112, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                    VStack(alignment: .leading){
                        //event name
                        Text("Event Name:")
                            .font(
                                Font.custom("DMSansBold", size: 12)
                            )
                            .foregroundStyle(.gray)
                        
                        Text("California Art Festival 2023 Dana Point 29-30")
                            .font(
                                Font.custom("DM Sans", size: 16)
                                    .weight(.bold)
                            )
                            .frame(maxWidth: .infinity,maxHeight: 150)
                            //.padding()
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                        //Event Details
                        Text("Event Details:")
                            .foregroundStyle(.gray)
                        HStack{
                            Image(systemName: "calendar")
                            Text("11 JULY 2024")
                        }
                        HStack{
                            Image(systemName: "mappin")
                            Text("Shelves Library")
                        }
                        Text("Host Name")
                            .foregroundStyle(.gray)
                        Text("Kaleem Bhaiya")
                    }
                   
                    .font(
                        Font.custom("DM Sans", size: 16)
                            .weight(.bold)
                    )
                //End of VStack for Event Details
                }//End of HStack
            )
    }
}


//struct floatingButton : View {
//    var body: some View {
//        Rectangle()
//            .frame(maxWidth: 227, maxHeight: 50)
//            .background(Color(""))
//    }
//}


struct EventAnalyticsCard: View {
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    ScrollView {
                        VStack(alignment: .leading){
                            Text("Manage Events")
                                .font(
                                    Font.custom("DMSans-Medium", size: 52)
                                )
                            
                            //Event Revenue Details Card
                            customGraphCard(width: 740,
                                            height: 250)
                            
                            
                            //MARK: Line 2
                            HStack{
                                // Total Event Visitors Card
                                customGraphCard(width: 442,
                                                height: 243)
                                .padding(.trailing)
                                //Today's Event Card
                                customEventCard(width: 275,
                                                height: 243)
                                
                            }
                            //MARK: Line 3
                            HStack{
                                //Tickets status Card
                                customGraphCard(width: 275,
                                                height: 243)
                                .padding(.trailing)
                                
                                // Total Event Visitors Card
                                customGraphCard(width: 442,
                                                height: 243)
                            }
                            
                        }
                        .padding([.leading,.top] ,54)
                        
                        
                    }
                    Spacer()
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
                                        Font.custom("DMSansBold", size: 36)
                                    )
                                Text("See All")
                                    .frame(alignment: .bottom)
                                    .font(
                                        Font.custom("DMSans-Medium", size: 14)
                                    ).foregroundStyle(Color("CustomButtonColor"))
                            }.padding([.leading, .trailing])
                            
                            //MARK: beneath will be two closest upcoming events only 2
                            
                            //Probably i'll make this a list
                                VStack(alignment: .leading){
                                Text("Tomorrow")
                                    .font(
                                        Font.custom("DMSansBold", size: 16)
                                    )
                                    .padding(.top, 1)
                                    .padding([.leading, .trailing])
                                
                                HStack{
                                    customEventCard(width: 344, height: 194)
                                    
                                        .padding([.leading, .trailing])
                                }
                                
                                
                                Text("15 JULY")
                                    .font(
                                        Font.custom("DMSansBold", size: 16)
                                    ).padding(.top, 22)
                                    .padding([.leading, .trailing])
                                
                                customGraphCard(width: 344, height: 194)
                                    .padding([.leading, .trailing])
                                    
                                //till here
                                }.frame(maxHeight: 560)
                            
                        }
                    }.padding([.leading, .trailing], 30)
                        .padding(.top, 54)
                    Spacer()
                }
                
                HStack{
                    BookCirculationCard(minHeight: 200, title: "All Events Listing")
                    BookCirculationCard(minHeight: 200, title: "All Events Registration by Users")
                }.padding([.leading, .trailing],54)
                Spacer()
                    
                
            }
                .frame(width: UIScreen.main.bounds.width)
        }
    }
}



struct floatingEventButtonView: View {
    @Binding var showPopover : Bool
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("pressed")
                    showPopover.toggle()
                    
                }, label: {
                    CustomButton(systemImage: "books.vertical.fill",
                                 width: 227,
                                 height: 50,
                                 title: "Create an Event",
                                 colorName: "CustomButtonColor")
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: -2)
                            .stroke(Color("cardIconColor"), lineWidth: 4)
                            
                    )
                }).sheet(isPresented: $showPopover, content: {
                    CreateUserForm()
                })
                
            }.padding([.trailing, .bottom], 90)
        }
    }
}


struct CreateUserForm : View {
    @State private var eventName = ""
    @State private var eventCategory = ""
    @State private var description = ""
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                Text("Create Event")
                    .font(
                        Font.custom("DM Sans", size: 36)
                            .weight(.semibold)
                    )
                    .padding(.bottom, 25)

                customFormField(title: "Event Name",
                                eventName: eventName, 
                                placeHolder: "Enter Event’s Title Name",
                                width: 56)
                customFormField(title: "Event Category:",
                                eventName: eventCategory,
                                placeHolder: "Select Event Category",
                                width: 56)
                customFormField(title: "Event Description",
                                 eventName: description,
                                 placeHolder: "Enter Event's Description",
                                width: 105)
                Text("Timing Details")
                    .font(
                    Font.custom("DM Sans", size: 20)
                    .weight(.bold)
                    )
                    .padding(.top)
                    .padding(.bottom, 50)
                //timing details
                timingDetails(title: "Date", width: 214, height: 60)
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                           
        }
        .padding()
        
    }
}

struct customFormField: View {
   @State private var title : String
    @State private var placeHolder : String
    @State private var eventName : String
    var width : Double
    
    
    init(title: String, eventName: String, placeHolder: String, width: Double) {
        self.title = title
        self.eventName = eventName
        self.placeHolder = placeHolder
        self.width = width
        
    }
    
    var body: some View {
        VStack(alignment : .leading){
            Text(title)
            .font(
                Font.custom("DM Sans", size: 20)
                    .weight(.bold)
            )
            .padding(.bottom, 10)
        TextField(placeHolder, text: $eventName)
            .padding(.leading)
            .frame(maxWidth: 585, minHeight: width)
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


struct timingDetails : View {
    
    @State private var title : String
    
    var width : Double
    var height : Double
    
    init(title: String, width: Double, height: Double) {
        self.title = title
        self.width = width
        self.height = height
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(
                    Font.custom("DM Sans", size: 20)
                        .weight(.bold)
                )
                .padding(.bottom, 10)
                Rectangle()
                .frame(maxWidth: width, maxHeight: height,alignment: .leading)
                .overlay(
                    HStack{
                        Text(currentDate())
                            .foregroundStyle(.customButton)
                            .font(.system(size: 20))
                        Spacer()
                        Button(action: {
                            showCalender()
                            //MARK: here
                        }, label: {
                            Image(systemName: "calendar")
                                .foregroundStyle(.customButton)
                                .font(.system(size: 34))
                        })
                    }.padding()

                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: -2)
                        .stroke(Color("CustomButtonColor"), lineWidth: 4)
                )
                
                .foregroundStyle(.textFormFieldBg)
        }
    }
}

struct todayDate : View {
    @State private var CurrentDate : String
    var body: some View {
        Text(currentDate())
            .font(
            Font.custom("DM Sans", size: 16)
            .weight(.bold)
            )
            .foregroundColor(.customButton)
          .frame(maxWidth: 100, alignment: .topLeading)
    }
}

func currentDate() -> String {
        let now = Date()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        let dateString = dateFormatter.string(from: now)
     
        
        return "\(dateString)"
    }

struct showCalender : View {
    @State private var eventDate = Date()
    var body: some View {
        VStack{
            DatePicker("Date", selection: $eventDate)
        }
    }
}
