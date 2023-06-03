//
//  projArrDelaysChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import SwiftUI
import Charts

struct projArrivalDelaysChart: View {
    var projArrivalDelays: [ProjArrivalDelays]
    var projDelay: Int
    var eta: Date
    
    var hideChartContent: Bool = false  //hides chart for paywall
    
    var body: some View {
        Chart(projArrivalDelays) {
            LineMark(
                x: .value("Time", $0.time, unit: .hour),
                y: .value("Delay", $0.delay)
            )
            .interpolationMethod(.catmullRom)
            // Add points
            PointMark(
                x: .value("Time", $0.time, unit: .hour),
                y: .value("Delay", $0.delay)
            )
            // Add annotation
            PointMark(
                x: .value("Time", eta, unit: .hour),
                y: .value("Delay", projDelay)
            )
            .symbol {
                Circle()
                    .fill(.orange)
                    .frame(width: 10)
                    .shadow(radius: 2)
            }
            // Add projection
            AreaMark(
                x: .value("Time", $0.time, unit: .hour),
                yStart: .value("ProjMin", $0.mindelay),
                yEnd: .value("ProjMax", $0.maxdelay)
            )
            .opacity(0.3)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6))
        }
    }
}

struct ProjArrivalDelays: Identifiable {
    let time: Date
    let delay: Int
    let mindelay: Int
    let maxdelay: Int
    var id: Date { time }
}


//struct projArrivalDelaysChart_Previews: PreviewProvider {
//    struct Preview: View {
//        var body: some View {
//            projArrivalDelaysView()
//        }
//    }
//    static var previews: some View {
//        NavigationStack {
//            Preview()
//        }
//    }
//}
