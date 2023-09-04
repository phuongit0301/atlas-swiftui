//
//  taxiChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import SwiftUI
import Charts

struct taxiChartLine: View {
    var taxiTimes: [TaxiTimes]
    var body: some View {
        Chart(taxiTimes) {
            LineMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Date", $0.taxiTime)
            )
            .foregroundStyle(by: .value("condition", $0.condition))
            .interpolationMethod(.catmullRom)
            .symbol(by: .value("condition", $0.condition))
            
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
}

struct taxiChartBar: View {
    var taxiTimes: [TaxiTimes]
    var body: some View {
        Chart(taxiTimes) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Date", $0.taxiTime)
            )
            .foregroundStyle(by: .value("condition", $0.condition))
            .position(by: .value("condition", $0.condition))
            .symbol(by: .value("condition", $0.condition))
            
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
}

struct TaxiTimes: Identifiable, Codable {
    let date: Date
    let condition: String
    let taxiTime: Int
    var id: Date { date }
}


//struct taxiChart_Previews: PreviewProvider {
//    struct Preview: View {
//        var body: some View {
//            taxiView()
//        }
//    }
//    static var previews: some View {
//        NavigationStack {
//            Preview()
//        }
//    }
//}

