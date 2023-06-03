//
//  enrWXChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI
import Charts

struct enrWXChart: View {
    var trackMiles: [EnrWXTrackMiles]
    var averageValue: Int
    var body: some View {
        Chart(trackMiles) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("TrackMilesDiff", $0.trackMilesDiff)
            )
            .foregroundStyle(.gray.opacity(0.3))
            RuleMark(
                y: .value("Average", averageValue)
            )
            .lineStyle(StrokeStyle(lineWidth: 3))
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
}

struct EnrWXTrackMiles: Identifiable {
    let date: Date
    let condition: String
    let trackMilesDiff: Int
    var id: Date { date }
}


//struct enrWXChart_Previews: PreviewProvider {
//    struct Preview: View {
//        var body: some View {
//            enrWXView()
//        }
//    }
//    static var previews: some View {
//        NavigationStack {
//            Preview()
//        }
//    }
//}

