//
//  taxiView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct taxiView: View {
    @Binding var dataProjTaxi: [FuelTaxiList]
    @SceneStorage("historyTimeframe") private var timeframe: taxiTimeframe = .threeFlights
    
    @State var taxiTimes: [TaxiTimes]?

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Actual vs plan taxi")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 flights", systemImage: "calendar")
                            .tag(taxiTimeframe.threeFlights)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(taxiTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(taxiTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    
                    Text("Average taxi time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(aveTime.formatted()) mins")
                        .font(.headline)
                    
                    if (chartType == "bar") {
                        taxiChartBar(taxiTimes: taxiTimes ?? [])
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    }
                    else {
                        taxiChartLine(taxiTimes: taxiTimes ?? [])
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
        .navigationTitle("Taxi")
        .background()
    }
    
    func handleData() {
        taxiTimes = funcTaxiTimes()
    }
    
    func dataFilter() -> [String: FuelTaxiList?] {
        var flights3: FuelTaxiList?
        var weeks: FuelTaxiList?
        var months: FuelTaxiList?
        
        dataProjTaxi.forEach { item in
            if item.type == "flights3" {
                flights3 = item
            } else if item.type == "week1" {
                weeks = item
            } else if item.type == "months3" {
                months = item
            }
        }
        
        return ["flights3": flights3, "weeks": weeks, "months": months]
    }
    // switcher by period
    var chartType: String {
        switch timeframe {
        case .threeFlights:
            return "bar"
        case .week:
            return "bar"
        case .months:
            return "line"
        }
    }
    
    func funcTaxiTimes() -> [TaxiTimes] {
        let fetchedTimes = dataFilter()
        var temp = [TaxiTimes]()
        
        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTimes["flights3"] {
                    let items = (threeFlights?.times?.allObjects as! [FuelTaxiRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(TaxiTimes(date: parseDateString(item.date!)!, condition: item.condition ?? "", taxiTime: item.taxiTime))
                    }
                }
                return temp
            case .week:
                if let week = fetchedTimes["weeks"] {
                    let items = (week?.times?.allObjects as! [FuelTaxiRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(TaxiTimes(date: parseDateString(item.date!)!, condition: item.condition ?? "", taxiTime: item.taxiTime))
                    }
                }
                return temp
            case .months:
                if let months = fetchedTimes["months"] {
                    let items = (months?.times?.allObjects as! [FuelTaxiRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(TaxiTimes(date: parseDateString(item.date!)!, condition: item.condition ?? "", taxiTime: item.taxiTime))
                    }
                }
                return temp
        }
    }
    
    var aveTime: Int {
        let fetchedTimes = dataFilter()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTimes["flights3"] as? FuelTaxiList {
                    return threeFlights.aveTime
                }
                return 0
            case .week:
                if let weeks = fetchedTimes["weeks"] as? FuelTaxiList {
                    return weeks.aveTime
                }
                return 0
            case .months:
                if let months = fetchedTimes["months"] as? FuelTaxiList {
                    return months.aveTime
                }
                return 0
            }
    }
    
    var aveDiff: Int{
        let fetchedTimes = dataFilter()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTimes["flights3"] as? FuelTaxiList {
                    return threeFlights.aveDiff
                }
                return 0
        case .week:
            if let weeks = fetchedTimes["weeks"] as? FuelTaxiList {
                return weeks.aveDiff
            }
            return 0
        case .months:
            if let months = fetchedTimes["months"] as? FuelTaxiList {
                return months.aveDiff
            }
            return 0
        }
    }
    
    var ymax: Int {
        let fetchedTimes = dataFilter()

        switch timeframe {
        case .threeFlights:
            if let threeFlights = fetchedTimes["flights3"] as? FuelTaxiList {
                return threeFlights.ymax
            }
            return 0
        case .week:
            if let weeks = fetchedTimes["weeks"] as? FuelTaxiList {
                return weeks.ymax
            }
            return 0
        case .months:
            if let months = fetchedTimes["months"] as? FuelTaxiList {
                return months.ymax
            }
            return 0
        }
    }
}

struct TaxiTimesJSON: Codable {
        let date: String
        let condition: String
        let taxiTime: Int
    }
