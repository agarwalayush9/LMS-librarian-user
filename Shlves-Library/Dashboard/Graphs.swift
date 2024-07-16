//
//  Graphs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI
import Charts
struct AreaGraphs: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
//MARK: for event revenue  data
struct eventRevenueData : Identifiable{
    var id = UUID()
    var date : Date
    var ticketCount : Int
    var ticketPrice : Int
}
class EventViewModel: ObservableObject {
    @Published var events = [eventRevenueData]()
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        // Generate sample data
        events = [
            eventRevenueData(date: Date(), ticketCount: 100, ticketPrice: 50),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, ticketCount: 150, ticketPrice: 60),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!, ticketCount: 200, ticketPrice: 70),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!, ticketCount: 120, ticketPrice: 55),
            eventRevenueData(date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!, ticketCount: 180, ticketPrice: 65)
        ]
    }
}
struct EventAreaGraphView: View {
    @StateObject private var viewModel = EventViewModel()

    var body: some View {
        VStack {
            Chart(viewModel.events) { event in
                AreaMark(
                    x: .value("Date", event.date), y: .value("Revenue", event.ticketCount * event.ticketPrice)
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
            .frame(height: 300)
            .padding()
        }
        .navigationTitle("Event Revenue")
    }
}

struct EventAreaGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EventAreaGraphView()
    }
}

