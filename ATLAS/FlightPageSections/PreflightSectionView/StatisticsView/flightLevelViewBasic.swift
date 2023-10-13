//
//  flightLevelView.swift
//  playground_swift
//
//  Created by Muhammad Adil on 26/9/23.
//

import Foundation
import SwiftUI
import Charts

struct flightLevelViewBasic: View {
    @Binding var dataFlightLevel: [FuelFlightLevelList]
    @SceneStorage("historyTimeframe") private var timeframe: flightLevelTimeframe = .threeFlights
    @State var flightLevel: [FlightLevel]?

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Actual flight level flown")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 days ago", systemImage: "calendar")
                            .tag(flightLevelTimeframe.threeFlights)
                        
                        Label("2 days ago", systemImage: "calendar")
                            .tag(flightLevelTimeframe.week)
                        
                        Label("Yesterday", systemImage: "calendar")
                            .tag(flightLevelTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                                        
                    flightLevelChartBasic(dataFlightLevel: $flightLevel)
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
        var flights2: FuelFlightLevelList?
        var flights1: FuelFlightLevelList?
        
        dataFlightLevel.forEach { item in
            if item.type == "flights3" {
                flights3 = item
            } else if item.type == "week1" {
                flights2 = item
            } else if item.type == "months3" {
                flights1 = item
            }
        }
        
        return ["flights3": flights3, "flights2": flights2, "flights1": flights1]
    }
    
    func flightLevelsFunc() -> [FlightLevel] {
        let data = dataFilter()
        var temp = [FlightLevel]()
        
        switch timeframe {
            case .threeFlights:
                if let threeFlights = data["flights3"] {
                    if threeFlights?.flightLevels == nil {
                        return []
                    }
                    
                    let items = (threeFlights?.flightLevels?.allObjects as! [FuelFlightLevelRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(FlightLevel(waypoint: item.waypoint ?? "", condition: item.condition ?? "", flightLevel: item.flightLevel))
                    }
                }
                return temp
            case .week:
                if let weeks = data["flights2"] {
                    if weeks?.flightLevels == nil {
                        return []
                    }
                    
                    let items = (weeks?.flightLevels?.allObjects as! [FuelFlightLevelRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(FlightLevel(waypoint: item.waypoint ?? "", condition: item.condition ?? "", flightLevel: item.flightLevel))
                    }
                }
                return temp
            case .months:
                if let months = data["flights1"] {
                    if months?.flightLevels == nil {
                        return []
                    }
                    
                    let items = (months?.flightLevels?.allObjects as! [FuelFlightLevelRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(FlightLevel(waypoint: item.waypoint ?? "", condition: item.condition ?? "", flightLevel: item.flightLevel))
                    }
                }
                return temp
        }
    }

}

//struct FlightLevelJSON: Codable {
//        let waypoint: String
//        let condition: String
//        let flightLevel: Int
//    }

struct flightLevelChartBasic: View {
    @Binding var dataFlightLevel: [FlightLevel]?
    
    var body: some View {
        Chart(dataFlightLevel ?? []) {
            LineMark(
                x: .value("Waypoint", $0.waypoint),
                y: .value("Level", $0.flightLevel)
            )
//            .foregroundStyle(by: .value("condition", $0.condition))
//            //.position(by: .value("condition", $0.condition))
//            .symbol(by: .value("condition", $0.condition))
            
        }
        .chartLegend(position: .top)
//        .chartXAxis {
//            AxisMarks(values: .automatic(desiredCount: 3))
//        }
    }
}

//struct FlightLevel: Identifiable, Codable {
//    let waypoint: String
//    let condition: String
//    let flightLevel: Int
//    var id: String { waypoint }
//}



