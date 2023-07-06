//
//  reciprocalRwyChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import Foundation
import SwiftUI
import Charts

struct reciprocalRwyChart: View {
    var trackMiles: [ReciprocalRwyTrackMiles]
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

struct ReciprocalRwyTrackMiles: Identifiable {
    let date: Date
    let condition: String
    let trackMilesDiff: Int
    var id: Date { date }
}
