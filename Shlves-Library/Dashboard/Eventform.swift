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
            Section(header: Text("Event Details")) {
                TextField("Event Name", text: $eventName)
                TextField("Event Category", text: $eventCategory)
                DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
                DatePicker("Event Time", selection: $eventTime, displayedComponents: .hourAndMinute)
                TextField("Event Duration", text: $eventDuration)
                TextField("Event Location", text: $eventLocation)
                TextField("Host Name", text: $hostName)
                TextField("Number of Tickets", value: $numberOfTickets, formatter: numberFormatter)
                TextField("Price of Tickets", value: $priceOfTickets, formatter: numberFormatter)
            }
            
            Section {
                Button(action: submitForm) {
                    Text("Submit")
                }
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
        print("Number of Tickets: \(numberOfTickets)")
        print("Price of Tickets: \(priceOfTickets)")
        
        let newEvent = Event(name: eventName, host: hostName, date: eventDate, time: eventTime, address: eventLocation, duration: eventDuration, description: "event description", registeredMembers: [], tickets: numberOfTickets, imageName: "event_image", fees: priceOfTickets, revenue: (priceOfTickets * priceOfTickets), status: "Pending")
        
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
