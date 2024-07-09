//
//  LibrarianDashboardStructs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 04/07/24.
//

import Foundation
import SwiftUI

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
