import SwiftUI
import Charts

struct historicalDelaysChart: View {
    var arrivalDelays: [ArrivalDelays]
    var eta: Date
    var arrTimeDelay: Int
    var ymax: Int
    var body: some View {
        let etaMin = eta.addingTimeInterval(-10 * 60)
        let etaMax = eta.addingTimeInterval(70 * 60)
        Chart(arrivalDelays) {
            BarMark(
                x: .value("Time", $0.time, unit: .hour),
                y: .value("Delay", $0.delay)
            )
            // Add stacking layer
            .foregroundStyle(by: .value("condition", $0.condition))
            // Add highlighted background
            AreaMark(
                x: .value("Time", etaMin),
                yStart: .value("areaMin", 0),
                yEnd: .value("areaMax", ymax)
            )
            .foregroundStyle(.orange)
            .opacity(0.3)
            AreaMark(
                x: .value("Time", eta),
                yStart: .value("areaMin", 0),
                yEnd: .value("areaMax", ymax)
            )
            .foregroundStyle(.orange)
            .opacity(0.3)
            AreaMark(
                x: .value("Time", etaMax),
                yStart: .value("areaMin", 0),
                yEnd: .value("areaMax", ymax)
            )
            .foregroundStyle(.orange)
            .opacity(0.3)
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6))
        }
    }
}

struct ArrivalDelays: Identifiable, Codable {
    let condition: String
    let time: Date
    let delay: Int
    var id: Date { time }
}


//struct historicalDelaysChart_Previews: PreviewProvider {
//    struct Preview: View {
//        var body: some View {
//            historicalDelaysView()
//        }
//    }
//    static var previews: some View {
//        NavigationStack {
//            Preview()
//        }
//    }
//}
