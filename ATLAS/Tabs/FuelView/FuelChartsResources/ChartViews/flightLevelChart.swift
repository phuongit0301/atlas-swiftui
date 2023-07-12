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
    var flightLevels: [FlightLevel]
    var body: some View {
        Chart(flightLevels) {
            LineMark(
                x: .value("Waypoint", $0.waypoint),
                y: .value("Level", $0.flightLevel)
            )
            .foregroundStyle(by: .value("condition", $0.condition))
            //.position(by: .value("condition", $0.condition))
            .symbol(by: .value("condition", $0.condition))
            
        }
        .chartLegend(position: .top)
//        .chartXAxis {
//            AxisMarks(values: .automatic(desiredCount: 3))
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

