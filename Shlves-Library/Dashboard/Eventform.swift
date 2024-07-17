//
//  Eventform.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI

struct EventFormView: View {
    @State private var eventName = ""
    @State private var eventCategory = ""
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    @State private var eventDuration = ""
    @State private var eventLocation = ""
    @State private var hostName = ""
    @State private var eventDescription = ""
    @State private var numberOfTickets = 0
    @State private var priceOfTickets = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    

    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        Form {
            Section(header: Text("Enter Event Details")
                .font(Font.custom("DMSans_18pt-Black", size: 32)
                    .bold())
                    .foregroundColor(.black)
                    .padding()) {
                TextField("Event Name", text: $eventName)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding()
                                    .font(.system(size: 18))
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                TextField("Event Category", text: $eventCategory)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding()
                                    .font(.system(size: 18))
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                        VStack {
                                Text("Timing Details")
                                .frame(maxWidth: .infinity, maxHeight: 20)
                                                .padding()
                                                .font(.system(size: 18))
                                                .background(Color(.systemGray6))
                                                .cornerRadius(8)
                            HStack{
                        DatePicker("Date", selection: $eventDate, displayedComponents: .date)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                                            .padding()
                                            .font(.system(size: 18))
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                        DatePicker("Time", selection: $eventTime, displayedComponents: .hourAndMinute)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                                            .padding()
                                            .font(.system(size: 18))
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                        TextField("Duration", text: $eventDuration)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                                            .padding()
                                            .font(.system(size: 18))
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                            }
                        }
                
                TextField("Event Location", text: $eventLocation)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding()
                                    .font(.system(size: 18))
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                TextField("Host Name", text: $hostName)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding()
                                    .font(.system(size: 18))
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                TextField("Event Description", text: $eventDescription)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                                    .padding()
                                    .font(.system(size: 18))
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                HStack{
                    VStack{
                        Text("Enter Number of Tickets")
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .font(.system(size: 18))
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        TextField("Number of Tickets", value: $numberOfTickets, formatter: numberFormatter)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .font(.system(size: 18))
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    VStack{
                        Text("Enter Number of Tickets")
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .font(.system(size: 18))
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        TextField("Price of Tickets", value: $priceOfTickets, formatter: numberFormatter)
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .font(.system(size: 18))
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            
            Section {
                Button(action: submitForm) {
                    Text("Submit")
                        .frame(maxWidth: .infinity, maxHeight: 30)
                }
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding()
                .font(.system(size: 18))
                .background(Color(.customButton))
                .foregroundColor(.white)
                .cornerRadius(8)
                //.padding()
            }
        }
        .navigationTitle("Event Details")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Event Submission"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func submitForm() {
        // Print the form data
        print("Event Name: \(eventName)")
        print("Event Category: \(eventCategory)")
        print("Event Date: \(eventDate)")
        print("Event Time: \(eventTime)")
        print("Event Duration: \(eventDuration)")
        print("Event Location: \(eventLocation)")
        print("Host Name: \(hostName)")
        print("event Description: \(eventDescription)")
        print("Number of Tickets: \(numberOfTickets)")
        print("Price of Tickets: \(priceOfTickets)")
        
        let newEvent = Event(name: eventName, host: hostName, date: eventDate, time: eventTime, address: eventLocation, duration: eventDuration, description: "", registeredMembers: [], tickets: numberOfTickets, imageName: "event_image", fees: priceOfTickets, revenue: 0, status: "Pending")
        
        DataController.shared.addEvent(newEvent) { result in
            switch result {
            case .success:
                alertMessage = "Event added successfully."
                showAlert = true
            case .failure(let error):
                alertMessage = "Failed to add event: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}


#Preview {
    EventFormView()
}
