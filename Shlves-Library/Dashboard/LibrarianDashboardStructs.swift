//
//  LibrarianDashboardStructs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import Foundation
import SwiftUI




import SwiftUI

// MARK: - UserFormViewModel
class UserFormViewModel: ObservableObject {
    @Published var eventName = ""
    @Published var eventCategory = ""
    @Published var eventDescription = ""
    @Published var eventDate = ""
    @Published var eventTime = ""
    @Published var eventDuration = ""
    @Published var evenetLocation = ""
    @Published var eventHost = ""
    @Published var eventGuest = ""
    @Published var numberOfTickets = ""
    @Published var ticketPrice = ""
    @Published var specialRemark = ""
    @Published var isChecked = false
    @Published var nextPopOver1 = false
    @Published var nextPopOver2 = false
}



//MARK: struct for creation of Custom Form field 1
struct customFormField1: View {
    var title: String
    var placeholder: String
    var width: Double
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Font.custom("DM Sans", size: 20).weight(.bold))
                .padding(.bottom, 10)
            
            TextField(placeholder, text: $text)
                .padding(.leading)
                .frame(maxWidth: 585, minHeight: width)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: -2)
                        .stroke(Color("CustomButtonColor"), lineWidth: 4)
                )
                .background(Color("textFormFieldBg"))
                .padding(.bottom, 20)
        }
    }
}


// MARK: - CreateUserForm
struct CreateUserForm: View {
    @ObservedObject var viewModel: UserFormViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Create Event1")
                    .font(Font.custom("DM Sans", size: 36).weight(.semibold))
                    .padding([.top, .bottom], 25)

                customFormField1(title: "Event Name",
                                 placeholder: "Enter Event’s Title Name",
                                 width: 56,
                                 text: $viewModel.eventName)

                customFormField1(title: "Event Category:",
                                 placeholder: "Select Event Category",
                                 width: 56,
                                 text: $viewModel.eventCategory)

                customFormField1(title: "Event Description",
                                 placeholder: "Enter Event's Description",
                                 width: 105,
                                 text: $viewModel.eventDescription)

                Text("Timing Details")
                    .font(Font.custom("DM Sans", size: 20).weight(.bold))
                    .padding(.top)
                    .padding(.bottom, 25)

                HStack {
                    timingDetails(eventDate: $viewModel.eventDate,
                                  eventTime: $viewModel.eventTime,
                                  eventDuration: $viewModel.eventDuration)
                }

                HStack {
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("The event will take place on \(viewModel.eventDate) at \(viewModel.eventTime) for \(viewModel.eventDuration) hours")
                }

                Spacer()
                nextButton(nextPopOver1: $viewModel.nextPopOver1)
            }
            .padding(.leading, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}


// MARK: - CreateNextUserForm
struct CreateNextUserForm: View {
    @ObservedObject var viewModel: UserFormViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Create Event2")
                    .font(Font.custom("DM Sans", size: 36).weight(.semibold))
                    .padding([.top, .bottom], 25)

                customFormField(title: "Location", 
                                eventName: viewModel.evenetLocation,
                                placeHolder: "Enter Event’s Location",
                                width: 56)
                customFormField(title: "Add Host", 
                                eventName: viewModel.eventHost,
                                placeHolder: "Enter Host Name",
                                width: 56)
                customFormField(title: "Add any Special Guests", 
                                eventName: viewModel.description,
                                placeHolder: "Enter Special Guests Name",
                                width: 105)
                
                Text("Send Notifications to Members via ")
                    .font(Font.custom("DM Sans", size: 20).weight(.bold))
                    .foregroundStyle(.customButton)
                    .padding(.top)
                    .padding(.bottom, 25)

                HStack {
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("Push Notification")
                    Spacer()
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("Email")
                    Spacer()
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("Phone Number")
                    Spacer()
                }
                .padding(.bottom)

                Text("Notifications to user things?")
                    .font(Font.custom("DM Sans", size: 20).weight(.bold))
                    .padding(.bottom)

                VStack {
                    HStack {
                        CheckBoxView(isChecked: $viewModel.isChecked)
                        Text("at Approval of Event")
                        Spacer()
                        CheckBoxView(isChecked: $viewModel.isChecked)
                        Text("One Day before Event")
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        CheckBoxView(isChecked: $viewModel.isChecked)
                        Text("One hour Before Event")
                        Spacer()
                        CheckBoxView(isChecked: $viewModel.isChecked)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundStyle(.customButton)
                            )
                        Text("At any Custom Time")
                        Spacer()
                    }
                }
                finalButton(nextPopOver2: $viewModel.nextPopOver2)
            }
            .padding(.leading, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

// MARK: - CreateFinalUserForm
struct CreateFinalUserForm: View {
    @ObservedObject var viewModel: UserFormViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Create Event")
                    .font(Font.custom("DM Sans", size: 36).weight(.semibold))
                    .padding([.top, .bottom], 25)

                customFormField(title: "How Many Tickets to make available", 
                                eventName: viewModel.numberOfTickets,
                                placeHolder: "Enter the number of tickets",
                                width: 56)
                customFormField(title: "Quoted per Ticket Pricing", 
                                eventName: viewModel.ticketPrice,
                                placeHolder: "Enter the per ticket pricing of the Event",
                                width: 56)
                
                Text("Upload Photos or Videos/Thumbnail")
                    .padding([.top, .bottom])
                
                CustomButton(systemImage: "plus", width: 227, height: 50, title: "Create an Event", colorName: "CustomButtonColor")
                CustomButton(systemImage: "plus", width: 148, height: 40, title: "Upload Media", colorName: "")
                CustomButton(systemImage: "plus", width: 148, height: 40, title: "Upload Media", colorName: "blue")
                
                customFormField(title: "Any Special Remarks to Admin", 
                                eventName: viewModel.specialRemark,
                                placeHolder: "Enter any remarks to send to the admin",
                                width: 96)
                
                Button(action: {
                    // what happens when pressed
                }) {
                    CustomButton(systemImage: "", width: 209, height: 42, title: "Send For Approval", colorName: "CustomButtonColor")
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: -2)
                                .stroke(Color("cardIconColor"), lineWidth: 4)
                        )
                }
            }
            Spacer()
                .padding(.leading, 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

//MARK: CREATE FORM 2
struct CreateNextUserForm: View {
    @ObservedObject var viewModel: UserFormViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Create Event2")
                    .font(Font.custom("DM Sans", size: 36).weight(.semibold))
                    .padding([.top, .bottom], 25)

                customFormField1(title: "Location",
                                 placeholder: "Enter Event’s Location",
                                 width: 56,
                                 text: $viewModel.eventLocation)

                customFormField1(title: "Add Host",
                                 placeholder: "Enter Host Name",
                                 width: 56,
                                 text: $viewModel.eventHost)

                customFormField1(title: "Add any Special Guests",
                                 placeholder: "Enter Special Guests Name",
                                 width: 105,
                                 text: $viewModel.eventGuest)

                Text("Send Notifications to Members via ")
                    .font(Font.custom("DM Sans", size: 20).weight(.bold))
                    .foregroundStyle(.customButton)
                    .padding(.top)
                    .padding(.bottom, 25)

                HStack {
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("Push Notification")
                    Spacer()
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("Email")
                    Spacer()
                    CheckBoxView(isChecked: $viewModel.isChecked)
                    Text("Phone Number")
                    Spacer()
                }
                .padding(.bottom)

                Text("Notifications to user things?")
                    .font(Font.custom("DM Sans", size: 20).weight(.bold))
                    .padding(.bottom)

                VStack {
                    HStack {
                        CheckBoxView(isChecked: $viewModel.isChecked)
                        Text("at Approval of Event")
                        Spacer()
                        CheckBoxView(isChecked: $viewModel.isChecked)
                        Text("One Day before Event")
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        CheckBoxView(isChecked: $viewModel.isChecked)
                        Text("One hour Before Event")
                        Spacer()
                        CheckBoxView(isChecked: $viewModel.isChecked)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundStyle(.customButton)
                            )
                        Text("At any Custom Time")
                        Spacer()
                    }
                }
                finalButton(nextPopOver2: $viewModel.nextPopOver2)
            }
            .padding(.leading, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}

//MARK: final form
struct CreateFinalUserForm: View {
    @ObservedObject var viewModel: UserFormViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Create Event")
                    .font(Font.custom("DM Sans", size: 36).weight(.semibold))
                    .padding([.top, .bottom], 25)

                customFormField1(title: "How Many Tickets to make available",
                                 placeholder: "Enter the number of tickets",
                                 width: 56,
                                 text: $viewModel.numberOfTickets)

                customFormField1(title: "Quoted per Ticket Pricing",
                                 placeholder: "Enter the per ticket pricing of the Event",
                                 width: 56,
                                 text: $viewModel.ticketPrice)

                Text("Upload Photos or Videos/Thumbnail")
                    .padding([.top, .bottom])

                CustomButton(systemImage: "plus", width: 227, height: 50, title: "Create an Event", colorName: "CustomButtonColor")
                CustomButton(systemImage: "plus", width: 148, height: 40, title: "Upload Media", colorName: "")
                CustomButton(systemImage: "plus", width: 148, height: 40, title: "Upload Media", colorName: "blue")

                customFormField1(title: "Any Special Remarks to Admin",
                                 placeholder: "Enter any remarks to send to the admin",
                                 width: 96,
                                 text: $viewModel.specialRemark)

                Button(action: {
                    // what happens when pressed
                }) {
                    CustomButton(systemImage: "", width: 209, height: 42, title: "Send For Approval", colorName: "CustomButtonColor")
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: -2)
                                .stroke(Color("cardIconColor"), lineWidth: 4)
                        )
                }
            }
            .padding(.leading, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
    }
}


struct userName : View {
    var userName : String
    var body: some View {
            Text("Hello, \(userName)!")
                .font(
                  Font.custom("DM Sans", size: 48)
                    .weight(.medium)
                )
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


struct card : View {
    var title : String
    var value : Double
    var salesDifferencePercentage : Double
    var body: some View {
        Rectangle()
            .foregroundStyle(.white)
            .frame(width: 258, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
               cardData(title: title,
                        value: value,
                        salesDifferencePercentage: salesDifferencePercentage)
            )
    }
}


struct DashboardAnalytics : View {
    let data = Analytics.analytics
    var body: some View {
        ForEach(data){ datunm in
            card(title: datunm.title,
                 value: datunm.value,
                 salesDifferencePercentage: datunm.salesDifferencePercentage)
        }
    }
}

struct cardData : View {
    
    var title : String
    var value : Double
    var salesDifferencePercentage : Double
    
    var body: some View {
        HStack {
            VStack {
                Text("$\(String(format: "%.2f", value))")
                  .font(
                    Font.custom("DM Sans", size: 32)
                      .weight(.bold)
                  )
                  .padding(.leading, 19)
                  .padding()
                Text(title)
                  .font(
                    Font.custom("DM Sans", size: 16)
                      .weight(.medium)
                  )
                  .padding(.leading, 19)
                  
            }
            .foregroundColor(Color(red: 0.16, green: 0.14, blue: 0.14))
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            
            VStack {
                cardIcon(imageName: "person.3")
                    .padding(.bottom, 16)
                Text("\(String(format: "%.2f", salesDifferencePercentage))%")
                  .font(
                    Font.custom("DM Sans", size: 12)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0, green: 0.74, blue: 0.35))
              .padding(.trailing)
            }
        }
    }
}


struct cardIcon : View {
    var imageName : String
    var body: some View {
            Circle()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color("cardIconColor"))
                .overlay(
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black)
                        
                )
                .padding(.trailing)
    }
}

struct todayDateAndTime : View {
    var body: some View {
        Text(currentDateAndTime())
          .font(
            Font.custom("DM Sans", size: 24)
              .weight(.medium)
          )
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}


struct AnalyticHeader : View {
    var title : String
    var body: some View {
        Text(title)
          .font(
            Font.custom("DM Sans", size: 20)
              .weight(.medium)
          )
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .topLeading)
          .padding([.leading], 64)
    }
}


func currentDateAndTime() -> String {
        let now = Date()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy | EEEE"
        let dateString = dateFormatter.string(from: now)
        
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let timeString = timeFormatter.string(from: now)
        
        return "\(dateString), \(timeString)"
    }

struct overDueBooksDetailData : View {
    var data = OverDueBookDetails.overDueBookDetail

    var body: some View {
        VStack{
            ForEach(data){ datum in
                showingDetailsForOverDueDetails(ISBN: datum.ISBN,
                               imageName: datum.imageName,
                               BookTitle: datum.BookTitle,
                               AuthorName: datum.AuthorName,
                               userName: datum.userName,
                               OverDuePeriod: datum.OverDuePeriod,
                               Fine: datum.Fine)
            }
                .padding(.top, 8)
        }

    }
}

struct NewlyArrivedBooksDetailData : View {
    let data = NewlyArrivedBooks.newlyArrivedBook
    var body: some View {
        VStack{
            ForEach(data){ datum in
                showingDetailsForNewlyArrivedBooks(
                                ISBN: datum.ISBN,
                               imageName: datum.imageName,
                               BookTitle: datum.BookTitle,
                               AuthorName: datum.AuthorName,
                                Quantity: datum.Quantity,
                                ArivedDate: datum.ArivedDate
                                           )}
                .padding(.top, 8)
        }
    }
}

struct AorDCustomButton : View {
    
    var width : CGFloat
    var height : CGFloat
    var title : String
    var colorName : String
    var fontColor : String
    var body: some View {
        HStack{
            Text(title)
                .font(
                Font.custom("DM Sans", size: 20)
                .weight(.bold)
                )
                .foregroundColor(Color(fontColor))
        }
        .padding(.all)
        .frame(maxWidth: width, maxHeight: height)
        .background(Color(colorName))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct CustomButton : View {
    
    var systemImage : String
    var width : CGFloat
    var height : CGFloat
    var title : String
    var colorName : String
    
    var body: some View {
        HStack{
            Image(systemName: systemImage)
                .foregroundStyle(Color.white)
            Text(title)
                .font(
                Font.custom("DM Sans", size: 20)
                .weight(.bold)
                )
                .foregroundColor(.white)
        }
        .padding(.all)
        .frame(width: width, height: height)
        .background(Color(colorName))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct backgroundView : View {
    var body: some View {
        Color("dashboardbg").ignoresSafeArea()
        
    }
}


struct BookCirculationCard: View {
    
    var minHeight : CGFloat
    var title : String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            
            BookCirculationCardData(bookTitle: "Soul", authorName: "zek")
            Spacer()
        }
        .padding()
        .background(Color.white).frame(minHeight: minHeight)
        .clipShape(RoundedRectangle(cornerRadius: 12))

    }
}

struct showingDetailsForOverDueDetails : View {
    
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var userName : String
    var OverDuePeriod : String
    var Fine : Double
    
    var body: some View {
        VStack {
            HStack{

                bookInfo(bookTitle: BookTitle,
                         authorName: AuthorName,
                         ISBN: ISBN,
                         imageName: imageName)
                .padding()
                userInfo(userName: userName,
                         OverDuePeriod: OverDuePeriod, Fine: Fine)
            }
        }
    }
}

struct showingDetailsForNewlyArrivedBooks : View {
    
    var ISBN : String
    var imageName : String
    var BookTitle : String
    var AuthorName : String
    var Quantity : Int
    var ArivedDate : String
    
    var body: some View {
        VStack {
            HStack{

                bookInfo(bookTitle: BookTitle,
                         authorName: AuthorName,
                         ISBN: ISBN,
                         imageName: imageName)
                .padding()
                NewlyArrivedBooksQuantityInfo(ArrivedDate: ArivedDate, Quantity: Quantity)
            }
        }
    }
}


struct BookRequest : View {
    @Environment(\.presentationMode) var presentationMode
    var ISBN : String
    var BookImage : String
    var BookTitle : String
    var AuthorName : String
    var UserName : String
    var UserID : String
    var RequestedDate : String
    
    var body: some View {
        NavigationStack {
            //Ebter for each here
            VStack {
                HStack {
                    bookInfo(bookTitle: BookTitle,
                             authorName: AuthorName,
                             ISBN: ISBN,
                             imageName: BookImage)
                        .padding(.leading)
                    BookRequestCard(userName: UserName, RequestedDate: RequestedDate)
                        .padding(.leading)
                    VStack {
                        AorDCustomButton(
                            width: 120,
                            height: 28,
                            title: "Approve",
                            colorName: "ApproveButton",
                            fontColor: "ApproveFontColor")
                        .padding(.bottom)
                        AorDCustomButton(
                            width: 120,
                            height: 28,
                            title: "Decline",
                            colorName: "DeclineButton",
                            fontColor: "DeclineFontColor")
                    }
                }
                .padding(.top)
                .frame(maxWidth: .infinity, maxHeight: 140)
                                Spacer()
                            }
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        Text("Cancel")
                                            .font(.headline)
                                    }
                                }
                            }
                            .padding(.top) // Add padding to the parent NavigationStack
                        }
                    }
                }



struct ReturnBook : View {
    @Environment(\.presentationMode) var presentationMode
    var ISBN : String
    var BookImage : String
    var BookTitle : String
    var AuthorName : String
    var UserName : String
    var UserID : String
    var RequestedDate : String
    var OverDuePeriod : String
    var fine : Double
    var body: some View {
        NavigationStack {
            //Ebter for each here
            VStack {
                HStack {
                    bookInfo(bookTitle: BookTitle,
                             authorName: AuthorName,
                             ISBN: ISBN,
                             imageName: BookImage)
                        .padding(.leading)
                    BookReturnCard(userName: UserName, RequestedDate: RequestedDate)
                        .padding(.leading)
                    userInfo(userName: "", OverDuePeriod: OverDuePeriod, Fine: fine)
                        .padding(.leading)
                    VStack {
                        AorDCustomButton(
                            width: 120,
                            height: 28,
                            title: "Approve",
                            colorName: "ApproveButton",
                            fontColor: "ApproveFontColor")
                        
                    }
                }
                .padding(.top)
                .frame(maxWidth: .infinity, maxHeight: 140)
                Spacer()
            }
            
            .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Text("Cancel")
                                        .font(.headline)
                                }
                            }
                        }
                        .padding(.top) // Add padding to the parent NavigationStack
                    }
                }
            }

            

//MARK: book request Data
struct BookRequestCard : View {
    var userName : String
    var RequestedDate: String
    var body: some View {
        HStack{
            Text(userName)

            VStack{
                Text("Requested \n On")
                    .padding()
                Text("\(RequestedDate)")
            }
        }
    }
}

//MARK: book return  Data
struct BookReturnCard : View {
    var userName : String
    var RequestedDate: String
    var body: some View {
        HStack{
            Text(userName)

            VStack{
                Text("Requested On")
                    .padding()
                Text("\(RequestedDate)")
            }
        }
    }
}



struct BookCirculationCardData : View {
    
    var bookTitle : String
    var authorName : String
    
    var body: some View {
        VStack (spacing : 30){
            HStack{
             
                Spacer()
                    
            }
        }
        
    }
}

struct userInfo : View {
    var userName : String
    var OverDuePeriod: String
    var Fine : Double
    var body: some View {
        HStack{
            Text(userName)
            Spacer()
            VStack{
                Text("Overdue")
                    .padding()
                Text("\(OverDuePeriod) days")
            }
            Spacer()
            VStack{
                Text("Fine")
                    .padding()
                Text("$\(String(format: "%.2f", Fine))")
            }
        }
    }
}

//MARK: user Info for Book Reservation Structure
struct UserInfoforBookReservation : View {
    var userName : String
    var OverDuePeriod: String
    var Fine : Double
    var body: some View {
        HStack{
            Text(userName)
        }
    }
}

struct NewlyArrivedBooksQuantityInfo : View {
    
    var ArrivedDate : String
    var Quantity : Int
    
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Text("Arrived Date")
                    .padding()
                Text("\(ArrivedDate) ")
            }
            Spacer()
            VStack{
                Text("Quantity")
                    .padding()
                Text("\(Quantity) units")
            }
        }
    }
}

struct bookInfo : View {
    
    var bookTitle : String
    var authorName : String
    var ISBN : String
    var imageName : String
    var body: some View {
        HStack(spacing : 20){
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 79, height: 125)
            .background(
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 79, height: 125)
                    .clipped()
            )
            .padding(.bottom, 12)
        VStack{
            Rectangle()
                .frame(width: 90, height: 25)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .foregroundStyle(Color("ISBNContainerColor"))
                .overlay(
                    Text(ISBN)
                        .font(
                            Font.custom("DM Sans", size: 14)
                                .weight(.medium)
                        )
                        .foregroundColor(.black)
                )
            
            Text(bookTitle)
                .font(
                    Font.custom("DM Sans", size: 25)
                        .weight(.medium)
                )
                .foregroundColor(.black)
            Text(authorName)
            //Text("by Shshank")
                .font(
                    Font.custom("DM Sans", size: 17)
                        .weight(.medium)
                )
                .foregroundColor(Color("AuthorNameColor"))
            
        }
    }
    }
}

struct memberData : View {
    var body: some View {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 90.64484, height: 64.45855)
          .background(
            Image(systemName: "person.3")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 91, height: 65)
              .clipped()
          )
    }
}
#Preview {
    LibrarianDashboard(isLoggedIn: .constant(true))
}
