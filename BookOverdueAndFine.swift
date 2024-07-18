//
//  book overdue and fine.swift
//  Shlves-Library
//
//  Created by Suraj Singh on 16/07/24.
//
import SwiftUI

struct BookFine: Identifiable {
    var id = UUID()
    var userId: String
    var bookName: String
    var daysKept: Int
    var renewalPeriod: Int = 15
    
    var bookLateDays: Int {
        return max(0, daysKept - renewalPeriod)
    }
    
    var lateFine: Double {
        return Double(bookLateDays)
    }
}

struct BookOverduesView: View {
    @State private var menuOpened = false
    @State private var fines: [BookFine] = [
        BookFine(userId: "101", bookName: "Book A", daysKept: 20),
        BookFine(userId: "102", bookName: "Book B", daysKept: 22),
        BookFine(userId: "103", bookName: "Book C", daysKept: 25)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(fines) { fine in
                    VStack(alignment: .leading) {
                        Text("User ID: \(fine.userId)")
                            .font(.headline)
                        Text("Book Name: \(fine.bookName)")
                            .font(.subheadline)
                        HStack {
                            Text("Late Days: \(fine.bookLateDays)")
                            Spacer()
                            Text("Days Kept: \(fine.daysKept)")
                            Spacer()
                            Text("Late Fine: $\(fine.lateFine, specifier: "%.2f")")
                        }
                    }
                    .padding(.vertical, 10)
                }
                .navigationTitle("Complaints")
                .onAppear {
                    
                }
                .navigationViewStyle(StackNavigationViewStyle()) // Ensure sidebar is removed
                
                
                if menuOpened {
                    sideMenu(width: UIScreen.main.bounds.width * 0.30,
                             menuOpened: menuOpened,
                             toggleMenu: toggleMenu)
                    .ignoresSafeArea()
                    .toolbar(.hidden, for: .navigationBar)
                    .transition(.offset(x: menuOpened ? -UIScreen.main.bounds.width : 0))
                    
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensure sidebar is removed
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
        }
    }
    
    func toggleMenu() {
        withAnimation(.easeInOut){
            menuOpened.toggle()
        }
        
    }
}

#Preview {
    BookOverduesView()
}
