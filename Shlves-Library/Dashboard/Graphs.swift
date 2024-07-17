//
//  Graphs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI
import Charts

//MARK: for event revenue  data
struct EventRevenueData: Identifiable {
    var id = UUID()
    var date: Date
    var RegisteredMemberCount: Int
    var fees: Int
    var revenue: Int
}

class eventRevenueViewModel: ObservableObject {
    @Published var events = [EventRevenueData]()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
            var eventDates: [Date] = []
            var tickets: [Int] = []
            var revenue: [Int] = []
            var registeredMemberCount: Int = 0
            
            let dispatchGroup = DispatchGroup()
            
            // Fetch event dates
            dispatchGroup.enter()
            DataController.shared.fetchEventDateTime { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let dates):
                    eventDates = dates
                case .failure(let error):
                    print("Failed to fetch event dates: \(error.localizedDescription)")
                }
            }
            
            // Fetch event tickets
            dispatchGroup.enter()
            DataController.shared.fetchEventTickets { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let ticketCounts):
                    tickets = ticketCounts
                case .failure(let error):
                    print("Failed to fetch event tickets: \(error.localizedDescription)")
                }
            }
            
            // Fetch event revenue
            dispatchGroup.enter()
            DataController.shared.fetchEventRevenue { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let eventRevenue):
                    revenue = eventRevenue
                case .failure(let error):
                    print("Failed to fetch event revenue: \(error.localizedDescription)")
                }
            }
            
            // Fetch registered member count
            dispatchGroup.enter()
            DataController.shared.fetchRegisteredMembersCount { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let count):
                    registeredMemberCount = count
                case .failure(let error):
                    print("Failed to fetch registered member count: \(error.localizedDescription)")
                }
            }
            
            // Notify when all data fetching is complete
            dispatchGroup.notify(queue: .main) {
                var eventDatas: [EventRevenueData] = []
                
                // Ensure all arrays are of the same count
                let count = min(eventDates.count, tickets.count, revenue.count)
                
                // Create EventRevenueData instances
                for index in 0..<count {
                    let eventData = EventRevenueData(date: eventDates[index],
                                                     RegisteredMemberCount: registeredMemberCount,
                                                     fees: tickets[index],
                                                     revenue: revenue[index])
                    eventDatas.append(eventData)
                }
                
                self.events = eventDatas
            }
        }
}

struct EventAreaGraphView: View {
    @StateObject private var viewModel = eventRevenueViewModel()

    var body: some View {
        VStack {
            Chart(viewModel.events) { event in
                AreaMark(
                    x: .value("Date", event.date),
                    y: .value("Revenue", event.RegisteredMemberCount * event.fees)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
            }
            .chartXAxis {
                AxisMarks(position: .bottom)
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 150) // Reduced height
            .padding(.horizontal) // Reduced padding
            .padding(.vertical, 10)
        }
    }
}

struct EventAreaGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EventAreaGraphView()
    }
}



// MARK: Data and Graph for Line chart for no. of visitor in events
struct VisitorData: Identifiable {
    let id = UUID()
    let date: Date
    let visitors: Int
}

class EventVisitorViewData: ObservableObject {
    @Published var visitors: [VisitorData] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        visitors = [
            VisitorData(date: Date().addingTimeInterval(-6*24*60*60), visitors: 239),
            VisitorData(date: Date().addingTimeInterval(-5*24*60*60), visitors: 252),
            VisitorData(date: Date().addingTimeInterval(-4*24*60*60), visitors: 315),
            VisitorData(date: Date().addingTimeInterval(-3*24*60*60), visitors: 198),
            VisitorData(date: Date().addingTimeInterval(-2*24*60*60), visitors: 148),
            VisitorData(date: Date().addingTimeInterval(-1*24*60*60), visitors: 68),
            VisitorData(date: Date(), visitors: 183)
        ]
    }
}

struct VisitorLineChartView: View {
    let data: [VisitorData]

    var body: some View {
        Chart(data) { entry in
            LineMark(
                x: .value("Date", entry.date),
                y: .value("Visitors", entry.visitors)
            )
            .foregroundStyle(.brown)
            AreaMark(
                x: .value("Date", entry.date),
                y: .value("Visitors", entry.visitors)
            )
            .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.weekday())
            }
        }
        .chartYAxis {
            AxisMarks() { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .frame(height: 150) // Reduced height
        .padding(.horizontal) // Reduced padding
        .padding(.vertical, 10)
    }
}

struct LineChart: View {
    @ObservedObject var eventVisitorViewData = EventVisitorViewData()
    
    var body: some View {
        VStack {
            VisitorLineChartView(data: eventVisitorViewData.visitors)
                .padding(.horizontal) // Reduced padding
                .padding(.vertical, 10)

            Spacer()
        }
    }
}


#Preview("Line Chart"){
    LineChart()
}

//MARK: Data and Graph for Bar chart for no. of visitor in events

struct TicketData: Identifiable {
    let id = UUID()
    let day: String
    let ticketsSold: Int
    let ticketsAvailable: Int
}

class EventTicketSalesData: ObservableObject {
    @Published var tickets: [TicketData] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        DataController.shared.fetchUpcomingEvents { [weak self] result in
                    switch result {
                    case .success(let events):
                        self?.tickets = events.prefix(4).enumerated().map { index, event in
                            let ticketsSold = event.registeredMembers.count
                            let ticketsAvailable = event.tickets - ticketsSold
                            let day = DateFormatter.localizedString(from: event.date, dateStyle: .short, timeStyle: .none)
                            return TicketData(day: day, ticketsSold: ticketsSold, ticketsAvailable: ticketsAvailable)
                        }
                        
                    case .failure(let error):
                        print("Failed to fetch upcoming events: \(error.localizedDescription)")
                        // Handle error as needed
                    }
                }
        
    }
}

struct BarChartView: View {
    var data: [TicketData]
    let maxTickets = 200 // Assuming the max tickets for scaling

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(data) { entry in
                VStack {
                    HStack(alignment: .bottom, spacing: 4) {
                        // Ticket Sold
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.customButton)
                                .frame(width: 15, height: CGFloat(entry.ticketsSold) / CGFloat(maxTickets) * 100)
                        }
                        
                        // Ticket Available
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.librarianDashboardTabBar)
                                .frame(width: 15, height: CGFloat(entry.ticketsAvailable) / CGFloat(maxTickets) * 100)
                        }
                    }

                    Text(entry.day)
                        .font(.caption2)
                        
                }
            }
        }
        .padding()
    }
}

struct BarGraph: View {
    @StateObject private var viewModel = EventTicketSalesData()

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Circle()
                        .fill(Color.customButton)
                        .frame(width: 15, height: 15)
                    Text("200 Ticket Sold")
                        .font(.caption2)
                }
                
                HStack {
                    Circle()
                        .fill(Color.librarianDashboardTabBar)
                        .frame(width: 15, height: 15)
                    Text("330 Ticket Available")
                        .font(.caption2)
                }
            }
           
            BarChartView(data: viewModel.tickets)
            
            Spacer()
        }
        .padding()
    }
}
//MARK: Pie chart for Ticket Status


import SwiftUI

struct TicketStatus: Identifiable {
    let id = UUID()
    let category: String
    var value: Double
    let color: Color
}

class TicketViewModel: ObservableObject {
    @Published var tickets: [TicketStatus] = []
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        tickets = [
            TicketStatus(category: "Availed", value: 500, color: .customButton),
            TicketStatus(category: "Remaining", value: 200, color: .librarianDashboardTabBar),
            TicketStatus(category: "Cancelled", value: 100, color: .pieLesser)
        ]
        
        DataController.shared.fetchRegisteredMembersOfNearestEvent { result in
                    switch result {
                    case .success(let registeredMemberCount):
                        // Assuming events.tickets gives total tickets, modify this logic if needed
                        let totalTickets = 100 // Replace with actual total tickets logic if available
                        let remainingTickets = Double(totalTickets - registeredMemberCount)
                        
                        // Update Availed and Remaining tickets
                        DispatchQueue.main.async {
                            self.updateTicketStatus(registeredMembers: registeredMemberCount, remainingTickets: remainingTickets)
                        }
                        
                    case .failure(let error):
                        print("Failed to fetch registered members: \(error.localizedDescription)")
                        // Handle error as needed
                    }
                
    }
}
    
    private func updateTicketStatus(registeredMembers: Int, remainingTickets: Double) {
           // Update Availed ticket count
           if let availedIndex = tickets.firstIndex(where: { $0.category == "Availed" }) {
               tickets[availedIndex].value = Double(registeredMembers)
           }
           
           // Update Remaining ticket count
           if let remainingIndex = tickets.firstIndex(where: { $0.category == "Remaining" }) {
               tickets[remainingIndex].value = remainingTickets
           }
           
           // Publish updates to SwiftUI views
           objectWillChange.send()
       }
   }


struct PieSliceView: View {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let path = Path { path in
                path.move(to: CGPoint(x: size / 2, y: size / 2))
                path.addArc(
                    center: CGPoint(x: size / 2, y: size / 2),
                    radius: size / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
            }
            path.fill(self.color)
        }
    }
}

struct PieChartView: View {
    var data: [TicketStatus]
    
    private func calculateAngles() -> [Angle] {
        let total = data.reduce(0) { $0 + $1.value }
        var angles: [Angle] = []
        var currentAngle: Double = -90
        
        for entry in data {
            let angle = entry.value / total * 360
            angles.append(.degrees(currentAngle))
            currentAngle += angle
        }
        angles.append(.degrees(currentAngle))
        
        return angles
    }
    
    var body: some View {
        let angles = calculateAngles()
        
        return ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                PieSliceView(
                    startAngle: angles[index],
                    endAngle: angles[index + 1],
                    color: data[index].color
                )
            }
        }
    }
}

struct PieChartDisplayView: View {
    @StateObject private var viewModel = TicketViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ticket Status")
                .font(.title2)
                .bold()
                .padding(.bottom, 10)
            
            HStack {
                PieChartView(data: viewModel.tickets)
                    .frame(width: 150, height: 150)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    ForEach(viewModel.tickets) { ticket in
                        HStack {
                            Circle()
                                .fill(ticket.color)
                                .frame(width: 15, height: 15)
                            VStack(alignment: .leading) {
                                Text("\(ticket.category):")
                                Text("\(ticket.value, specifier: "%.0f")")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}



#Preview{
    PieChartDisplayView()
}



// Preview provider for the main view
#Preview("bar graph"){
    BarGraph()
}

//#Preview(){
//    EventsDashboard()
//}
