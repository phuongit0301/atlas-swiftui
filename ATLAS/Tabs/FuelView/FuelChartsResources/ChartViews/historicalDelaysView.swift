//
//  arrDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct historicalDelaysView: View {
    @Binding var dataHistoricalDelays: [HistoricalDelaysList]
    @SceneStorage("historyTimeframe") private var timeframe: delayTimeframe = .days
    @State var delays: [ArrivalDelays]?
    
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
                        
                        Label("3 Months", systemImage: "calendar")
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
                        historicalDelaysChart(arrivalDelays: delays ?? [], eta: eta, arrTimeDelay: arrTimeDelayWX, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    } else {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelay.formatted()) mins")
                            .font(.headline)
                        let filteredDelays = delays?.filter { $0.condition != "Added delay due WX" }
                        historicalDelaysChart(arrivalDelays: filteredDelays ?? [], eta: eta, arrTimeDelay: arrTimeDelay, ymax: ymax)
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
    }
    
    func dataFilter() -> [String: HistoricalDelaysList?] {
        var days: HistoricalDelaysList?
        var weeks: HistoricalDelaysList?
        var months: HistoricalDelaysList?
        
        dataHistoricalDelays.forEach { item in
            if item.type == "days3" {
                days = item
            } else if item.type == "week1" {
                weeks = item
            } else if item.type == "months3" {
                months = item
            }
        }
        
        return ["days": days, "weeks": weeks, "months": months]
    }
    // switcher by period
    func delaysFunc(_ dataFilter: [String: HistoricalDelaysList?]) -> [ArrivalDelays]? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        switch timeframe {
            case .days:
                var temp = [ArrivalDelays]()
                
                if let days = dataFilter["days"] {
                    let items = (days?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order > $1.order})
                    
                    items.forEach {item in
                        temp.append(ArrivalDelays(condition: item.condition ?? "", time: formatter.date(from: item.time!)!, delay: item.delay))
                    }
                }
                return temp
            case .week:
                var temp = [ArrivalDelays]()
                
                if let weeks = dataFilter["weeks"] {
                    let items = (weeks?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order > $1.order})
                    
                    items.forEach {item in
                        temp.append(ArrivalDelays(condition: item.condition ?? "", time: formatter.date(from: item.time!)!, delay: item.delay))
                    }
                }
                return temp
            case .months:
                var temp = [ArrivalDelays]()
                
                if let months = dataFilter["months"] {
                    let items = (months?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order > $1.order})
                    
                    items.forEach {item in
                        temp.append(ArrivalDelays(condition: item.condition ?? "", time: formatter.date(from: item.time!)!, delay: item.delay))
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
                if let days = dataFilter["weeks"] as? HistoricalDelaysList {
                    return days.arrTimeDelay
                }
                return 0
            case .months:
                if let days = dataFilter["months"] as? HistoricalDelaysList {
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
            if let days = dataFilter["weeks"] as? HistoricalDelaysList {
                return days.arrTimeDelayWX
            }
            return 0
        case .months:
            if let days = dataFilter["months"] as? HistoricalDelaysList {
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
                if let week = dataFilter["weeks"] as? HistoricalDelaysList {
                    return formatter.date(from: week.eta ?? "00:00") ?? formatter.date(from: "00:00")!
                }
                return formatter.date(from: "00:00")!
            case .months:
                if let month = dataFilter["months"] as? HistoricalDelaysList {
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
            if let days = dataFilter["weeks"] as? HistoricalDelaysList {
                return days.ymax
            }
            return 0
        case .months:
            if let days = dataFilter["months"] as? HistoricalDelaysList {
                return days.ymax
            }
            return 0
        }
    }
    
}

struct ArrivalDelaysJSON: Codable {
        let condition: String
        let time: String
        let delay: Int
    }
