//
//  delaysView.swift
//  playground_swift
//
//  Created by Muhammad Adil on 26/9/23.
//

import Foundation
import SwiftUI
import Charts

struct historicalDelaysViewBasic: View {
    @Binding var dataHistoricalDelays: [HistoricalDelaysList]
    @SceneStorage("historyTimeframe") private var timeframe: delayTimeframe = .days
    @State var delays: [ArrivalDelays] = []
    @State var filteredDelays: [ArrivalDelays] = []
    
    @State private var showWeather = true
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Historical delays")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle(isOn: $showWeather) {
                        Text("Weather delays")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 Days", systemImage: "calendar")
                            .tag(delayTimeframe.days)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(delayTimeframe.week)
                        
                        Label("3 Weeks", systemImage: "calendar")
                            .tag(delayTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    if showWeather {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelayWX.formatted()) mins")
                            .font(.headline)
                        historicalDelaysChartBasic(arrivalDelays: $delays, eta: eta, arrTimeDelay: arrTimeDelayWX, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    } else {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelay.formatted()) mins")
                            .font(.headline)
                        historicalDelaysChartBasic(arrivalDelays: $filteredDelays, eta: eta, arrTimeDelay: arrTimeDelay, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    }
                }
                .padding()
                .onAppear {
                    handleData()
                }.onChange(of: timeframe) { _ in
                    handleData()
                }
            }
        }
        .navigationTitle("Historical Delays")
        .background()
    }
    
    func handleData() {
        let items = dataFilter()
        delays = delaysFunc(items)
        if delays.count > 0 {
            filteredDelays = delays.filter { $0.condition != "Added delay due WX" }
        }
    }
    
    func dataFilter() -> [String: HistoricalDelaysList?] {
        var days: HistoricalDelaysList?
        var week1: HistoricalDelaysList?
        var weeks3: HistoricalDelaysList?
        
        // flight3, week1, months3
        dataHistoricalDelays.forEach { item in
            if item.type == "days3" {
                days = item
            } else if item.type == "week1" {
                week1 = item
            } else if item.type == "months3" {
                weeks3 = item
            }
        }
        
        return ["days": days, "week1": week1, "weeks3": weeks3]
    }
    // switcher by period
    func delaysFunc(_ dataFilter: [String: HistoricalDelaysList?]) -> [ArrivalDelays] {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        switch timeframe {
            case .days:
                var temp = [ArrivalDelays]()
                
                if let days = dataFilter["days"] {
                    let items = (days?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(ArrivalDelays(condition: item.condition ?? "", time: formatter.date(from: item.time!)!, delay: item.delay, weather: ""))
                    }
                }
                return temp
            case .week:
                var temp = [ArrivalDelays]()
                
                if let weeks = dataFilter["week1"] {
                    let items = (weeks?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(ArrivalDelays(condition: item.condition ?? "", time: formatter.date(from: item.time!)!, delay: item.delay, weather: ""))
                    }
                }
                return temp
            case .months:
                var temp = [ArrivalDelays]()
                
                if let months = dataFilter["weeks3"] {
                    let items = (months?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(ArrivalDelays(condition: item.condition ?? "", time: formatter.date(from: item.time!)!, delay: item.delay, weather: ""))
                    }
                }
                return temp
        }
    }
    
    var arrTimeDelay: Int {
        let dataFilter = dataFilter()
        switch timeframe {
            case .days:
                if let days = dataFilter["days"] as? HistoricalDelaysList  {
                    return days.arrTimeDelay
                }
                return 0
               
            case .week:
                if let days = dataFilter["week1"] as? HistoricalDelaysList {
                    return days.arrTimeDelay
                }
                return 0
            case .months:
                if let days = dataFilter["weeks3"] as? HistoricalDelaysList {
                    return days.arrTimeDelay
                }
                return 0
        }
    }
    
    var arrTimeDelayWX: Int {
        let dataFilter = dataFilter()
        switch timeframe {
        case .days:
            if let days = dataFilter["days"] as? HistoricalDelaysList {
                return days.arrTimeDelayWX
            }
            return 0
        case .week:
            if let days = dataFilter["week1"] as? HistoricalDelaysList {
                return days.arrTimeDelayWX
            }
            return 0
        case .months:
            if let days = dataFilter["weeks3"] as? HistoricalDelaysList {
                return days.arrTimeDelayWX
            }
            return 0
        }
    }
    
    var eta: Date {
        let dataFilter = dataFilter()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        switch timeframe {
            case .days:
                if let days = dataFilter["days"] as? HistoricalDelaysList {
                    return formatter.date(from: days.eta ?? "00:00") ?? formatter.date(from: "00:00")!
                }
                return formatter.date(from: "00:00")!
            
            case .week:
                if let week = dataFilter["week1"] as? HistoricalDelaysList {
                    return formatter.date(from: week.eta ?? "00:00") ?? formatter.date(from: "00:00")!
                }
                return formatter.date(from: "00:00")!
            case .months:
                if let month = dataFilter["weeks3"] as? HistoricalDelaysList {
                    return formatter.date(from: month.eta ?? "00:00") ?? formatter.date(from: "00:00")!
                }
                return formatter.date(from: "00:00")!
        }
    }
    
    var ymax: Int {
        let dataFilter = dataFilter()
        switch timeframe {
        case .days:
            if let days = dataFilter["days"] as? HistoricalDelaysList {
                return days.ymax
            }
            return 0
        case .week:
            if let days = dataFilter["week1"] as? HistoricalDelaysList {
                return days.ymax
            }
            return 0
        case .months:
            if let days = dataFilter["weeks3"] as? HistoricalDelaysList {
                return days.ymax
            }
            return 0
        }
    }
    
}

//struct ArrivalDelaysJSON: Codable {
//    let condition: String
//    let time: String
//    let delay: Int
//    let weather: String
//}


struct historicalDelaysChartBasic: View {
    @Binding var arrivalDelays: [ArrivalDelays]
    var eta: Date
    var arrTimeDelay: Int
    var ymax: Int
    var body: some View {
        let etaMin = eta.addingTimeInterval(-10 * 60)
        let etaMax = eta.addingTimeInterval(70 * 60)
        Chart(arrivalDelays) { data in
            BarMark(
                x: .value("Time", data.time, unit: .hour),
                y: .value("Delay", data.delay)
            )
            // Add stacking layer
            .foregroundStyle(by: .value("condition", data.condition))
            .annotation(position: .automatic, alignment: .center) {
                Text("\(data.weather)")
                    .foregroundColor(.white)
            }

            // Add highlighted background
            AreaMark(
                x: .value("Time", etaMin),
                yStart: .value("areaMin", 0),
                yEnd: .value("areaMax", ymax)
            )
            .foregroundStyle(.orange)
            .opacity(0.3)
//            AreaMark(
//                x: .value("Time", eta),
//                yStart: .value("areaMin", 0),
//                yEnd: .value("areaMax", ymax)
//            )
//            .foregroundStyle(.orange)
//            .opacity(0.3)
//            AreaMark(
//                x: .value("Time", etaMax),
//                yStart: .value("areaMin", 0),
//                yEnd: .value("areaMax", ymax)
//            )
//            .foregroundStyle(.orange)
//            .opacity(0.3)
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6))
        }
    }
}

//struct ArrivalDelays: Identifiable, Codable {
//    let condition: String
//    let time: Date
//    let delay: Int
//    let weather: String
//    var id: Date { time }
//}


struct projArrivalDelaysViewBasic: View {
    @Binding var dataProjDelays: ProjDelaysList
    
    var body: some View {
        let fetchedDelays: [String: Any] = fetchProjArrivalDelays(dataProjDelays)
        let delays: [ProjArrivalDelays] = fetchedDelays["delays"] as! [ProjArrivalDelays]
        let projDelay: Int = fetchedDelays["expectedDelay"] as! Int
        let eta: Date = fetchedDelays["eta"] as! Date
        
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Projected delay")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Spacer()
                    Text("Expected delay during arrival time, taking into account expected weather conditions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(projDelay.formatted()) mins")
                        .font(.headline)
                    
                    projArrivalDelaysChartBasic(projArrivalDelays: delays, projDelay: projDelay, eta: eta)
                        .frame(minHeight: 300)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .background()
    }
}

// replace with API call
//func fetchProjArrivalDelays(_ dataProjDelays: ProjDelaysList) -> [String: Any] {
//    var projArrivalDelays = [ProjArrivalDelays]()
//    let items = (dataProjDelays.delays?.allObjects as! [ProjDelaysListRef]).sorted(by: {$0.order < $1.order})
//    
//    items.forEach { item in
//        let entry = ProjArrivalDelays(time: item.unwrappedTime!, delay: item.delay, mindelay: item.mindelay, maxdelay: item.maxdelay)
//        projArrivalDelays.append(entry)
//    }
//    
//    let object = ["delays": projArrivalDelays, "expectedDelay": dataProjDelays.expectedDelay, "eta": dataProjDelays.unwrappedEta] as [String : Any]
//    return object
//}

//struct ProjArrivalDelaysJSON: Codable {
//        let time: String
//        let delay: Float
//        let mindelay: Float
//        let maxdelay: Float
//    }


struct projArrivalDelaysChartBasic: View {
    var projArrivalDelays: [ProjArrivalDelays]
    var projDelay: Int
    var eta: Date
    
    var hideChartContent: Bool = false  //hides chart for paywall
    
    var body: some View {
        Chart(projArrivalDelays) {
            LineMark(
                x: .value("Time", $0.time, unit: .hour),
                y: .value("Delay", $0.delay)
            )
            .interpolationMethod(.catmullRom)
            // Add points
            PointMark(
                x: .value("Time", $0.time, unit: .hour),
                y: .value("Delay", $0.delay)
            )
            // Add annotation
            PointMark(
                x: .value("Time", eta, unit: .hour),
                y: .value("Delay", projDelay)
            )
            .symbol {
                Circle()
                    .fill(.orange)
                    .frame(width: 10)
                    .shadow(radius: 2)
            }
            // Add projection
            AreaMark(
                x: .value("Time", $0.time, unit: .hour),
                yStart: .value("ProjMin", $0.mindelay),
                yEnd: .value("ProjMax", $0.maxdelay)
            )
            .opacity(0.3)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6))
        }
    }
}

//struct ProjArrivalDelays: Identifiable, Codable {
//    let time: Date
//    let delay: Int
//    let mindelay: Int
//    let maxdelay: Int
//    var id: Date { time }
//}
