//
//  taxiView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct taxiView: View {
    var convertedJSON: processedFuelDataModel.taxiNestedJSON
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
        let fetchedTimes: processedFuelDataModel.taxiNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes.flights3
            return threeFlights!.times
        case .week:
            let week = fetchedTimes.week1
            return week!.times
        case .months:
            let months = fetchedTimes.months3
            return months!.times
        }
    }
    var aveTime: Int {
        let fetchedTimes: processedFuelDataModel.taxiNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes.flights3
            return threeFlights!.aveTime
        case .week:
            let week = fetchedTimes.week1
            return week!.aveTime
        case .months:
            let months = fetchedTimes.months3
            return months!.aveTime
        }
    }
    var aveDiff: Int{
        let fetchedTimes: processedFuelDataModel.taxiNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes.flights3
            return threeFlights!.aveDiff
        case .week:
            let week = fetchedTimes.week1
            return week!.aveDiff
        case .months:
            let months = fetchedTimes.months3
            return months!.aveDiff
        }
    }
    var ymax: Int{
        let fetchedTimes: processedFuelDataModel.taxiNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes.flights3
            return threeFlights!.ymax
        case .week:
            let week = fetchedTimes.week1
            return week!.ymax
        case .months:
            let months = fetchedTimes.months3
            return months!.ymax
        }
    }
}

struct TaxiTimesJSON: Codable {
        let date: String
        let condition: String
        let taxiTime: Int
    }
