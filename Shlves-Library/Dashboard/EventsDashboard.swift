//
//  EventsDashboard.swift
//  Shlves-Library
//
//  Created by Abhay singh on 10/07/24.
//

import SwiftUI

#Preview {
    EventsDashboard()
}


//MARK: main view of this page
struct EventsDashboard: View {
    @State private var menuOpened = false
    @State private var showPopover = false
    @State private var eventName = ""
    @State private var eventCategory = ""
    @State private var description = ""
    @State private var eventDate = Date()
    @State private var eventTime = Time(hours: 0, minutes: 0)
    @State private var eventDuration = ""
    @State private var address = ""
    @State private var host = ""
    @State private var specialGuest = ""
    @State private var tickets = 0
    @State private var fees = 0
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack(alignment: .leading){
                    Text("Manage Events")
                        .font(
                        Font.custom("DM Sans", size: 52)
                        .weight(.medium)
                        ).padding(.leading, 52)
                        .padding(.top)
                    //calling main screen struct
                    EventAnalyticsCard()
                }
                //This is to be the last part of z Stack
                if menuOpened {
                    sideMenu( width: UIScreen.main.bounds.width * 0.30,
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
            .navigationTitle("Lms")
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
                    Button(action: {
                        // Add action for books vertical button
                    }, label: {
                        Image(systemName: "books.vertical")
                            .foregroundColor(Color.mainFont)
                    })
                }
                
            }//Navigation bar ends    ~zek
        }
    }
    func toggleMenu() {
        withAnimation(.easeInOut){
            menuOpened.toggle()
        }
    }
}



//MARK: Custom card for showing Graph
struct customGraphCard: View {
    var width : Double
    var height : Double
    var body: some View {
        Rectangle()
        //            .frame(width: width, height: height)
            .frame(minHeight: height)
            .frame(maxWidth: width)
            .foregroundStyle(Color(.graphBG))
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension Event {
    static var defaultEvent: Event {
        return Event(
            id: UUID().uuidString,
            name: "Default Event",
            host: "Unknown Host",
            date: Date(),
            time: Date(),
            address: "Unknown Location",
            duration: "Unknown Duration",
            description: "No Description",
            registeredMembers: [],
            tickets: 0,
            imageName: "default_image",
            fees: 0,
            revenue: 0,
            status: "Upcoming"
        )
    }
}




//MARK: Custom card for today's event
struct TodaysEventCustomCard: View {
    var width: Double
    var height: Double
    @StateObject private var viewModel = eventRevenueViewModel()
    // Accessing the first upcoming event with a default value
    
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(Color(.graphBG))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                VStack(alignment: .leading) {
                    
                    var event: Event = viewModel.getFirstUpcomingEvent() ?? Event.defaultEvent

                    Text("Event Name:")
                        .font(
                            Font.custom("DMSansBold", size: 12)
                        )
                        .foregroundStyle(.gray)
                        .padding(.leading)
                    
                    Text(event.name)  // Use event name
                        .font(
                            Font.custom("DM Sans", size: 16)
                                .weight(.bold)
                        )
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        // Placeholder image; you can replace this with image from URL if needed
                        Image("book_cover")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 79, height: 96)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                        
                        VStack(alignment: .leading) {
                            // Event Details
                            Text("Event Details:")
                                .foregroundStyle(.gray)
                            
                            HStack {
                                Image(systemName: "calendar")
                                Text(event.date, style: .date)  // Display event date
                            }
                            
                            HStack {
                                Image(systemName: "mappin")
                                Text(event.address)  // Display event address
                            }
                            
                            Text("Host Name")
                                .foregroundStyle(.gray)
                            Text(event.host)  // Display event host
                        }
                        .font(
                            Font.custom("DM Sans", size: 16)
                                .weight(.bold)
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 40)
            )
    }
}



//MARK: Custom Card for event
struct customEventCard: View {
    var width : Double
    var height : Double
    @StateObject private var viewModel = eventRevenueViewModel()
  
    
    var body: some View {
        Rectangle()
            .frame(width: width, height: height)
            .foregroundStyle(Color(.graphBG))
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
                        
                        var event: Event = viewModel.getSecondUpcomingEvent() ?? Event.defaultEvent

                        //event name
                        Text("Event Name:")
                            .font(
                                Font.custom("DMSansBold", size: 12)
                            )
                            .foregroundStyle(.gray)
                        
                        Text(event.name)
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
                            Text(event.date, style: .date) 
                        }
                        HStack{
                            Image(systemName: "mappin")
                            Text(event.address)
                        }
                        Text("Host Name")
                            .foregroundStyle(.gray)
                        Text(event.host)
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


//MARK: skeleton of whole page
struct EventAnalyticsCard: View {
    @State private var selectedDate = Date()
    var body: some View {
        ScrollView {
            VStack{
                HStack{
                    ScrollView {
                        VStack(alignment: .leading){
                            
                            //Event Revenue Details Card
                            customGraphCard(width: 740, height: 300)
                                           .overlay(
                                               GeometryReader { geometry in
                                                   VStack(alignment: .leading) {
                                                       Text("Event Revenue Details")
                                                           .font(Font.custom("DMSans_18pt-Medium", size: 32))
                                                        .padding(.top,20)
                                                       
                                                       EventAreaGraphView()
                                                           .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.7)
                                                           .padding(.bottom)
                                                   }
                                                   .frame(width: geometry.size.width, height: geometry.size.height)
                                               }
                                           )
                                           .frame(width: 740, height: 300)
                                           .padding(.bottom, 20)
                            //MARK: Line 2
                            HStack{
                                // Total Event Visitors Card
                                customGraphCard(width: 442,
                                                height: 243)
                                .overlay(
                                    GeometryReader{ geometry in
                                        VStack(alignment: .leading) {
                                            Text("Number of visitors")
                                                .font(.title)
                                                .padding([.top, .bottom])
                                            
                                            LineChart()
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.7)
                                                .padding(.bottom)
                                        }
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                )
                                
                                .padding(.trailing)
                                //Today's Event Card
                                TodaysEventCustomCard(width: 295,
                                                height: 243)
                                
                            }
                            .padding(.bottom, 25)
                                
                            //MARK: Line 3
                            
                            
                            HStack{
                                //Tickets status Card
                                customGraphCard(width: 375,
                                                height: 243)
                                .overlay(
                                    GeometryReader{ geometry in
                                        VStack(alignment: .leading) {
                                            
                                            
                                            PieChartDisplayView()
                                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.7)
                                                .padding(.bottom)
                                        }
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                )

                                .padding(.trailing)
                                
                                // Ticket sales
                                customGraphCard(width: 377,
                                                height: 243)
                                .overlay(
                                    GeometryReader{ geometry in
                                        VStack(alignment: .leading) {
                                            VStack(alignment: .leading){
                                                Text("Tickets Sales")
                                                    .font(
                                                        Font.custom("DM Sans", size: 17)
                                                            .weight(.bold)
                                                    )
                                            }
                                            .padding(.top,20)
                                            Spacer()
                                            VStack{
                                                BarGraph()
                                                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.4)
                                                    .padding(.bottom)
                                            }
                                            
                                        }
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                )
                            }
                            
                            
                        }
                        .padding([.leading] ,54)
                        
                        
                    }
                    Spacer()
                    //MARK: Right of Manage event
                    ScrollView {
                        VStack(alignment : .leading){
                            //Calender Card
                            customGraphCard(width: 344 ,
                                            height: 285)
                            .overlay(
                                            VStack {
                                                DatePicker(
                                                    "Date",
                                                    selection: $selectedDate,
                                                    displayedComponents: [.date]
                                                )
                                                .datePickerStyle(GraphicalDatePickerStyle())
                                                .labelsHidden()
                                                .accentColor(.customButton)
                                                .frame(width: 300, height: 200) // Adjust the size as needed
                                            }
                                            .padding()
                                        ).padding([.leading, .trailing])
                            
                            
                            //MARK: Next line
                            
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
                                Text("Next Event")
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
                        
                    Spacer()
                }
                .padding(.bottom, 40)
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



// MARK: Floating Button on Event DashBoard
struct floatingEventButtonView: View {
    @Binding var showPopover : Bool
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("pressed1")
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
                    EventFormView()
                })
                
            }.padding([.trailing, .bottom], 90)
        }
    }
}





