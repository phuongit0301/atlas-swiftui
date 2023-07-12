//
//  flightLevelView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct flightLevelView: View {
    var convertedJSON: processedFuelDataModel.flightLevelNestedJSON
    @SceneStorage("historyTimeframe") private var timeframe: flightLevelTimeframe = .threeFlights

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Actual vs plan flight level")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 flights", systemImage: "calendar")
                            .tag(flightLevelTimeframe.threeFlights)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(flightLevelTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(flightLevelTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    
                    Text("Average actual minus plan flight level")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if (aveDiff < 0) {
                        Text("\(aveDiff.formatted()) ft")
                            .font(.headline)
                    } else {
                        Text("+\(aveDiff.formatted()) ft")
                            .font(.headline)
                    }
                                        
                    flightLevelChart(flightLevels: FlightLevel)
                        .frame(minHeight: 300)
                }
                .padding()
            }
        }
        .navigationTitle("Flight level")
        .background()
    }
    // switcher by period
    var FlightLevel: [FlightLevel] {
        let fetchedData: processedFuelDataModel.flightLevelNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedData.flights3
            return threeFlights!.flightLevels
        case .week:
            let week = fetchedData.week1
            return week!.flightLevels
        case .months:
            let months = fetchedData.months3
            return months!.flightLevels
        }
    }

    var aveDiff: Int{
        let fetchedData: processedFuelDataModel.flightLevelNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedData.flights3
            return threeFlights!.aveDiff
        case .week:
            let week = fetchedData.week1
            return week!.aveDiff
        case .months:
            let months = fetchedData.months3
            return months!.aveDiff
        }
    }
}

struct FlightLevelJSON: Codable {
        let waypoint: String
        let condition: String
        let flightLevel: Int
    }
