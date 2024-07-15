//
//  Eventform.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI

import SwiftUI

struct EventFormView: View {
    @State private var eventName = ""
    @State private var eventCategory = ""
    @State private var eventDate = Date()
    @State private var eventTime = Date()
    @State private var eventDuration = ""
    @State private var eventLocation = ""
    @State private var hostName = ""
    @State private var numberOfTickets = ""
    @State private var priceOfTickets = ""

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
                TextField("Number of Tickets", text: $numberOfTickets)
                TextField("Price of Tickets", text: $priceOfTickets)
            }
            
            Section {
                Button(action: submitForm) {
                    Text("Submit")
                }
            }
        }
        .navigationTitle("Event Details")
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
    }
}

struct EventFormView_Previews: PreviewProvider {
    static var previews: some View {
        EventFormView()
    }
}


#Preview {
    EventFormView()
}
