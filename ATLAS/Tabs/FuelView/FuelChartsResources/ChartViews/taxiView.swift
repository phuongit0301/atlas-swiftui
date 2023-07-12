//
//  taxiView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct taxiView: View {
    var convertedJSON: [String : [String : Any]]
    @SceneStorage("historyTimeframe") private var timeframe: taxiTimeframe = .threeFlights

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
                        taxiChartBar(taxiTimes: taxiTimes)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    }
                    else {
                        taxiChartLine(taxiTimes: taxiTimes)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    }
                    
                }
                .padding()
            }
        }
        .navigationTitle("Taxi")
        .background()
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
    
    var taxiTimes: [TaxiTimes] {
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["times"] as! [TaxiTimes]
        case .week:
            let week = fetchedTimes["week1"]!
            return week["times"] as! [TaxiTimes]
        case .months:
            let months = fetchedTimes["months3"]!
            return months["times"] as! [TaxiTimes]
        }
    }
    var aveTime: Int {
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["aveTime"] as! Int
        case .week:
            let week = fetchedTimes["week1"]!
            return week["aveTime"] as! Int
        case .months:
            let months = fetchedTimes["months3"]!
            return months["aveTime"] as! Int
        }
    }
    var aveDiff: Int{
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["aveDiff"] as! Int
        case .week:
            let week = fetchedTimes["week1"]!
            return week["aveDiff"] as! Int
        case .months:
            let months = fetchedTimes["months3"]!
            return months["aveDiff"] as! Int
        }
    }
    var ymax: Int{
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["ymax"] as! Int
        case .week:
            let week = fetchedTimes["week1"]!
            return week["ymax"] as! Int
        case .months:
            let months = fetchedTimes["months3"]!
            return months["ymax"] as! Int
        }
    }
}

struct TaxiTimesJSON: Codable {
        let date: String
        let condition: String
        let taxiTime: Int
    }
