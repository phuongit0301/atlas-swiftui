//
//  flightLevelView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct flightLevelView: View {
    var convertedJSON: [String : [String : Any]]
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
        let fetchedData: [String : [String : Any]] = convertedJSON

        //let fetchedData: [String : [String : Any]] = fetchFlightLevel()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedData["flights3"]!
            return threeFlights["flightLevels"] as! [FlightLevel]
        case .week:
            let week = fetchedData["week1"]!
            return week["flightLevels"] as! [FlightLevel]
        case .months:
            let months = fetchedData["months3"]!
            return months["flightLevels"] as! [FlightLevel]
        }
    }

    var aveDiff: Int{
        let fetchedData: [String : [String : Any]] = convertedJSON

        //let fetchedData: [String : [String : Any]] = fetchFlightLevel()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedData["flights3"]!
            return threeFlights["aveDiff"] as! Int
        case .week:
            let week = fetchedData["week1"]!
            return week["aveDiff"] as! Int
        case .months:
            let months = fetchedData["months3"]!
            return months["aveDiff"] as! Int
        }
    }
}

// replace with API call
func fetchFlightLevel() -> [String : [String : Any]] {

    let entry1 = FlightLevel(waypoint: "takeoff", condition: "Plan", flightLevel: 0)
    let entry2 = FlightLevel(waypoint: "aroso", condition: "Plan", flightLevel: 10000)
    let entry3 = FlightLevel(waypoint: "niven", condition: "Plan", flightLevel: 20000)
    let entry4 = FlightLevel(waypoint: "kiron", condition: "Plan", flightLevel: 36000)
    let entry5 = FlightLevel(waypoint: "patma", condition: "Plan", flightLevel: 36000)
    let entry6 = FlightLevel(waypoint: "ratna", condition: "Plan", flightLevel: 36000)
    let entry7 = FlightLevel(waypoint: "kidob", condition: "Plan", flightLevel: 36000)
    let entry8 = FlightLevel(waypoint: "raven", condition: "Plan", flightLevel: 36000)
    let entry9 = FlightLevel(waypoint: "muthu", condition: "Plan", flightLevel: 36000)
    let entry10 = FlightLevel(waypoint: "nixon", condition: "Plan", flightLevel: 36000)
    let entry11 = FlightLevel(waypoint: "ramen", condition: "Plan", flightLevel: 36000)
    let entry12 = FlightLevel(waypoint: "arama", condition: "Plan", flightLevel: 30000)
    let entry13 = FlightLevel(waypoint: "bobag", condition: "Plan", flightLevel: 20000)
    let entry14 = FlightLevel(waypoint: "damvo", condition: "Plan", flightLevel: 10000)
    let entry15 = FlightLevel(waypoint: "landing", condition: "Plan", flightLevel: 0)
    
    let entry1x = FlightLevel(waypoint: "takeoff", condition: "Actual", flightLevel: 0)
    let entry2x = FlightLevel(waypoint: "aroso", condition: "Actual", flightLevel: 10000)
    let entry3x = FlightLevel(waypoint: "niven", condition: "Actual", flightLevel: 20000)
    let entry4x = FlightLevel(waypoint: "kiron", condition: "Actual", flightLevel: 30000)
    let entry5x = FlightLevel(waypoint: "patma", condition: "Actual", flightLevel: 32000)
    let entry6x = FlightLevel(waypoint: "ratna", condition: "Actual", flightLevel: 32000)
    let entry7x = FlightLevel(waypoint: "kidob", condition: "Actual", flightLevel: 32000)
    let entry8x = FlightLevel(waypoint: "raven", condition: "Actual", flightLevel: 36000)
    let entry9x = FlightLevel(waypoint: "muthu", condition: "Actual", flightLevel: 36000)
    let entry10x = FlightLevel(waypoint: "nixon", condition: "Actual", flightLevel: 38000)
    let entry11x = FlightLevel(waypoint: "ramen", condition: "Actual", flightLevel: 38000)
    let entry12x = FlightLevel(waypoint: "arama", condition: "Actual", flightLevel: 30000)
    let entry13x = FlightLevel(waypoint: "bobag", condition: "Actual", flightLevel: 20000)
    let entry14x = FlightLevel(waypoint: "damvo", condition: "Actual", flightLevel: 10000)
    let entry15x = FlightLevel(waypoint: "landing", condition: "Actual", flightLevel: 0)
    
    let entry1wx = FlightLevel(waypoint: "takeoff", condition: "Actual", flightLevel: 0)
    let entry2wx = FlightLevel(waypoint: "aroso", condition: "Actual", flightLevel: 10000)
    let entry3wx = FlightLevel(waypoint: "niven", condition: "Actual", flightLevel: 20000)
    let entry4wx = FlightLevel(waypoint: "kiron", condition: "Actual", flightLevel: 30000)
    let entry5wx = FlightLevel(waypoint: "patma", condition: "Actual", flightLevel: 32000)
    let entry6wx = FlightLevel(waypoint: "ratna", condition: "Actual", flightLevel: 32000)
    let entry7wx = FlightLevel(waypoint: "kidob", condition: "Actual", flightLevel: 32000)
    let entry8wx = FlightLevel(waypoint: "raven", condition: "Actual", flightLevel: 36000)
    let entry9wx = FlightLevel(waypoint: "muthu", condition: "Actual", flightLevel: 38000)
    let entry10wx = FlightLevel(waypoint: "nixon", condition: "Actual", flightLevel: 38000)
    let entry11wx = FlightLevel(waypoint: "ramen", condition: "Actual", flightLevel: 38000)
    let entry12wx = FlightLevel(waypoint: "arama", condition: "Actual", flightLevel: 30000)
    let entry13wx = FlightLevel(waypoint: "bobag", condition: "Actual", flightLevel: 20000)
    let entry14wx = FlightLevel(waypoint: "damvo", condition: "Actual", flightLevel: 10000)
    let entry15wx = FlightLevel(waypoint: "landing", condition: "Actual", flightLevel: 0)
    
    let entry1mx = FlightLevel(waypoint: "takeoff", condition: "Actual", flightLevel: 0)
    let entry2mx = FlightLevel(waypoint: "aroso", condition: "Actual", flightLevel: 10000)
    let entry3mx = FlightLevel(waypoint: "niven", condition: "Actual", flightLevel: 20000)
    let entry4mx = FlightLevel(waypoint: "kiron", condition: "Actual", flightLevel: 30000)
    let entry5mx = FlightLevel(waypoint: "patma", condition: "Actual", flightLevel: 32000)
    let entry6mx = FlightLevel(waypoint: "ratna", condition: "Actual", flightLevel: 32000)
    let entry7mx = FlightLevel(waypoint: "kidob", condition: "Actual", flightLevel: 32000)
    let entry8mx = FlightLevel(waypoint: "raven", condition: "Actual", flightLevel: 36000)
    let entry9mx = FlightLevel(waypoint: "muthu", condition: "Actual", flightLevel: 36000)
    let entry10mx = FlightLevel(waypoint: "nixon", condition: "Actual", flightLevel: 36000)
    let entry11mx = FlightLevel(waypoint: "ramen", condition: "Actual", flightLevel: 36000)
    let entry12mx = FlightLevel(waypoint: "arama", condition: "Actual", flightLevel: 30000)
    let entry13mx = FlightLevel(waypoint: "bobag", condition: "Actual", flightLevel: 20000)
    let entry14mx = FlightLevel(waypoint: "damvo", condition: "Actual", flightLevel: 10000)
    let entry15mx = FlightLevel(waypoint: "landing", condition: "Actual", flightLevel: 0)

    let levelsDays: [FlightLevel] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1x, entry2x, entry3x, entry4x, entry5x, entry6x, entry7x, entry8x, entry9x, entry10x, entry11x, entry12x, entry13x, entry14x, entry15x]
    let levelsWeek: [FlightLevel] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1wx, entry2wx, entry3wx, entry4wx, entry5wx, entry6wx, entry7wx, entry8wx, entry9wx, entry10wx, entry11wx, entry12wx, entry13wx, entry14wx, entry15wx]
    let levelsMonths: [FlightLevel] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1mx, entry2mx, entry3mx, entry4mx, entry5mx, entry6mx, entry7mx, entry8mx, entry9mx, entry10mx, entry11mx, entry12mx, entry13mx, entry14mx, entry15mx]
    
    let aveDiffDays = -1800
    let aveDiffWeek = 2200
    let aveDiffMonths = -2000
        
    let days = ["flightLevels": levelsDays, "aveDiff": aveDiffDays] as [String : Any]
    let week = ["flightLevels": levelsWeek, "aveDiff": aveDiffWeek] as [String : Any]
    let months = ["flightLevels": levelsMonths, "aveDiff": aveDiffMonths] as [String : Any]

    let flightLevelsAll = ["flights3": days, "week1": week, "months3": months]

    return flightLevelsAll
}

struct FlightLevelJSON: Codable {
        let waypoint: String
        let condition: String
        let flightLevel: Int
    }
