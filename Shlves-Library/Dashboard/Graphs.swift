//
//  Graphs.swift
//  Shlves-Library
//
//  Created by Abhay singh on 15/07/24.
//

import SwiftUI
import Charts

//MARK: for event revenue  data
struct eventRevenueData : Identifiable{
    var id = UUID()
    var date : Date
    var ticketCount : Int
    var ticketPrice : Int
}
class eventRevenueViewModel: ObservableObject {
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
    @StateObject private var viewModel = eventRevenueViewModel()

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
    }
}

struct EventAreaGraphView_Previews: PreviewProvider {
    static var previews: some View {
        EventAreaGraphView()
    }
}


//Data and Graph for Line chart for no. of visitor in events
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
            VisitorData(date: Date().addingTimeInterval(-6*24*60*60),
                        visitors: 239),
            VisitorData(date: Date().addingTimeInterval(-5*24*60*60),
                        visitors: 252),
            VisitorData(date: Date().addingTimeInterval(-4*24*60*60),
                        visitors: 315),
            VisitorData(date: Date().addingTimeInterval(-3*24*60*60),
                        visitors: 198),
            VisitorData(date: Date().addingTimeInterval(-2*24*60*60),
                        visitors: 148),
            VisitorData(date: Date().addingTimeInterval(-1*24*60*60),
                        visitors: 68),
            VisitorData(date: Date(),
                        visitors: 183)
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
            AreaMark(x: .value("Date", entry.date),
                     y: .value("Visitors", entry.visitors))
            .foregroundStyle(.linearGradient(colors: [.librarianDashboardTabBar.opacity(0.8), .white.opacity(0.2)],
                                             startPoint: .top,
                                             endPoint: .bottom))
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
        .frame(height: 243)
        .padding()
    }
}

struct LineChart: View {
    @ObservedObject var eventVisitorViewData = EventVisitorViewData()
    
    var body: some View {
        VStack {
            VisitorLineChartView(data: eventVisitorViewData.visitors)
                .padding()
            
            Spacer()
        }
    }
}




#Preview("Line Chart"){
    LineChart()
}

//Data and Graph for Bar chart for no. of visitor in events

