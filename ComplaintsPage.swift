//
//  ComplaintsPage.swift
//  Shlves-Library
//
//  Created by Mohit Kumar Gupta on 16/07/24.
//

import SwiftUI

// Example struct to represent a complaint
struct Complaint {
    var id: String // unique identifier for each complaint
    var complaintText: String
    var date: Date
    var user: String // username or identifier of the user who raised the complaint
}

struct ComplaintsView: View {
    @State private var complaints: [Complaint] = [] // Array to hold fetched complaints
    @State private var menuOpened = false
    
    var body: some View {
        NavigationStack {
            
            ZStack{
                
                backgroundView()
                    .ignoresSafeArea(.all)
                    .blur(radius: menuOpened ? 10 : 0)
                    .animation(.easeInOut(duration: 0.25), value: menuOpened)
                
                
                
                
                List(complaints, id: \.id) { complaint in
                    VStack(alignment: .leading) {
                        Text(complaint.complaintText)
                            .font(.headline)
                        Text("User: \(complaint.user)")
                            .font(.subheadline)
                        Text("Date: \(dateFormatter.string(from: complaint.date))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("Complaints")
                .onAppear {
                    // Fetch complaints when view appears
                    fetchComplaints()
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
    
    func fetchComplaints() {
        // Example function to fetch complaints (replace with actual implementation)
        // Assume complaints are fetched from Firebase or another backend
        // In a real app, you'd fetch complaints asynchronously and update the @State complaints array
        // Here's a mock implementation for demonstration:
        let mockComplaints = [
            Complaint(id: "1", complaintText: "Book not available", date: Date(), user: "UserA"),
            Complaint(id: "2", complaintText: "Late book return", date: Date(), user: "UserB"),
            Complaint(id: "3", complaintText: "Library noisy", date: Date(), user: "UserC")
        ]
        
        complaints = mockComplaints
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

struct ComplaintsView_Previews: PreviewProvider {
    static var previews: some View {
        ComplaintsView()
    }
}
