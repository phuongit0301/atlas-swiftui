//
//  flightLevelChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI
import Charts

struct flightLevelChart: View {
    @Binding var dataFlightLevel: [FuelFlightLevelList]
//    @State private var flightLevels: [FlightLevel]?
    
    var body: some View {
        Text("123")
//        Chart(flightLevels ?? []) {
//            LineMark(
//                x: .value("Waypoint", $0.waypoint),
//                y: .value("Level", $0.flightLevel)
//            )
//            .foregroundStyle(by: .value("condition", $0.condition))
//            //.position(by: .value("condition", $0.condition))
//            .symbol(by: .value("condition", $0.condition))
//            
//        }
//        .chartLegend(position: .top)
//        .onAppear {
//            handleData()
//        }
////        .chartXAxis {
////            AxisMarks(values: .automatic(desiredCount: 3))
////        }
//        func handleData() {
//            flightLevels = trackMilesFunc()
//        }
//        
//        func dataFilter() -> [String: FuelFlightLevelList?] {
//            var flights3: FuelFlightLevelList?
//            var weeks: FuelFlightLevelList?
//            var months: FuelFlightLevelList?
//            
//            dataFlightLevel.forEach { item in
//                if item.type == "flights3" {
//                    flights3 = item
//                } else if item.type == "week1" {
//                    weeks = item
//                } else if item.type == "months3" {
//                    months = item
//                }
//            }
//            
//            return ["flights3": flights3, "weeks": weeks, "months": months]
//        }
//        
//        // switcher by period
//        func flightLevelsFunc() -> [FlightLevel] {
//            let fetchedTrackMiles = dataFilter()
//            var temp = [FlightLevel]()
//
//            switch timeframe {
//                case .threeFlights:
//                    if let threeFlights = fetchedTrackMiles["flights3"] {
//                        let items = (threeFlights?.trackMiles?.allObjects as! [FuelTrackMilesRefList]).sorted(by: {$0.order > $1.order})
//                        
//                        items.forEach {item in
//                            temp.append(TrackMiles(phase: item.phase ?? "", condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
//                        }
//                    }
//                    return temp
//                case .week:
//                    if let weeks = fetchedTrackMiles["weeks"] {
//                        let items = (weeks?.trackMiles?.allObjects as! [FuelTrackMilesRefList]).sorted(by: {$0.order > $1.order})
//                        
//                        items.forEach {item in
//                            temp.append(TrackMiles(phase: item.phase ?? "", condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
//                        }
//                    }
//                    return temp
//                case .months:
//                    if let months = fetchedTrackMiles["months"] {
//                        let items = (months?.trackMiles?.allObjects as! [FuelTrackMilesRefList]).sorted(by: {$0.order > $1.order})
//                        
//                        items.forEach {item in
//                            temp.append(TrackMiles(phase: item.phase ?? "", condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
//                        }
//                    }
//                    return temp
//            }
//        }
    }
}

struct FlightLevel: Identifiable, Codable {
    let waypoint: String
    let condition: String
    let flightLevel: Int
    var id: String { waypoint }
}


//struct flightLevelChart_Previews: PreviewProvider {
//    struct Preview: View {
//        var body: some View {
//            flightLevelView()
//        }
//    }
//    static var previews: some View {
//        NavigationStack {
//            Preview()
//        }
//    }
//}

