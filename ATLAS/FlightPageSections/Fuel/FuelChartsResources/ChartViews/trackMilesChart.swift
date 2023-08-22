//
//  trackMilesChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI
import Charts

struct trackMilesChart: View {
    var trackMiles: [TrackMiles]
    var units: String
    var body: some View {
        Chart(trackMiles) { item in
            BarMark(
                x: .value("TrackMilesDiff", item.trackMilesDiff),
                y: .value("Phase", item.phase)
            )
            .annotation(position: .overlay) {
                Text("\(item.trackMilesDiff) \(units)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 12, weight: .bold))
            }
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
}

struct TrackMiles: Identifiable, Codable {
    let phase: String
    let condition: String
    let trackMilesDiff: Int
    var id: String { phase }
}


//struct trackMilesChart_Previews: PreviewProvider {
//    struct Preview: View {
//        var body: some View {
//            trackMilesView()
//        }
//    }
//    static var previews: some View {
//        NavigationStack {
//            Preview()
//        }
//    }
//}

