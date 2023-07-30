//
//  flightLevelView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct flightLevelView: View {
    @Binding var dataFlightLevel: [FuelFlightLevelList]
    @SceneStorage("historyTimeframe") private var timeframe: flightLevelTimeframe = .threeFlights
    @State var flightLevel: [FlightLevel]?

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
                                        
                    flightLevelChart(dataFlightLevel: $flightLevel)
                        .frame(minHeight: 300)
                }
                .padding()
                .onAppear {
                    handleData()
                }.onChange(of: timeframe) { _ in
                    handleData()
                }
            }
        }
        .navigationTitle("Flight level")
        .background()
    }
    
    func handleData() {
        flightLevel = flightLevelsFunc()
    }
    
    func dataFilter() -> [String: FuelFlightLevelList?] {
        var flights3: FuelFlightLevelList?
        var weeks: FuelFlightLevelList?
        var months: FuelFlightLevelList?
        
        dataFlightLevel.forEach { item in
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
    
    func flightLevelsFunc() -> [FlightLevel] {
        let data = dataFilter()
        var temp = [FlightLevel]()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = data["flights3"] {
                    let items = (threeFlights?.flightLevels?.allObjects as! [FuelFlightLevelRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(FlightLevel(waypoint: item.waypoint ?? "", condition: item.condition ?? "", flightLevel: item.flightLevel))
                    }
                }
                return temp
            case .week:
                if let weeks = data["weeks"] {
                    let items = (weeks?.flightLevels?.allObjects as! [FuelFlightLevelRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(FlightLevel(waypoint: item.waypoint ?? "", condition: item.condition ?? "", flightLevel: item.flightLevel))
                    }
                }
                return temp
            case .months:
                if let months = data["months"] {
                    let items = (months?.flightLevels?.allObjects as! [FuelFlightLevelRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(FlightLevel(waypoint: item.waypoint ?? "", condition: item.condition ?? "", flightLevel: item.flightLevel))
                    }
                }
                return temp
        }
    }

    var aveDiff: Int {
        let fetchedData = dataFilter()
        
        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedData["flights3"] as? FuelFlightLevelList {
                    return threeFlights.aveDiff
                }
                return 0
            case .week:
                if let weeks = fetchedData["weeks"] as? FuelFlightLevelList {
                    return weeks.aveDiff
                }
                return 0
            case .months:
                if let months = fetchedData["months"] as? FuelFlightLevelList {
                    return months.aveDiff
                }
                return 0
        }
    }
}

struct FlightLevelJSON: Codable {
        let waypoint: String
        let condition: String
        let flightLevel: Int
    }
