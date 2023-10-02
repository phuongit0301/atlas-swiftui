//
//  taxiView.swift
//  playground_swift
//
//  Created by Muhammad Adil on 26/9/23.
//

import Foundation
import SwiftUI

struct taxiViewBasic: View {
    @Binding var dataProjTaxi: [FuelTaxiList]
    @State var taxiTimes: [TaxiTimes]?

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Actual taxi times")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("Average taxi time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(aveTime.formatted()) mins")
                        .font(.headline)
                    
                    taxiChartBarBasic(taxiTimes: taxiTimes ?? [])
                        .frame(minHeight: 300)
                        .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                }
                .padding()
                .onAppear {
                    handleData()
                }
            }
        }
        .navigationTitle("Taxi")
        .background()
    }
    
    func handleData() {
        taxiTimes = funcTaxiTimes()
    }
    
    func dataFilter() -> [String: FuelTaxiList?] {
        var flights3: FuelTaxiList?
        
        dataProjTaxi.forEach { item in
            if item.type == "flights3" {
                flights3 = item
            }
        }
        
        return ["flights3": flights3]
    }
        
    func funcTaxiTimes() -> [TaxiTimes] {
        let fetchedTimes = dataFilter()
        var temp = [TaxiTimes]()
        if let threeFlights = fetchedTimes["flights3"] {
            let items = (threeFlights?.times?.allObjects as! [FuelTaxiRefList]).sorted(by: {$0.order < $1.order})
            
            items.forEach {item in
                temp.append(TaxiTimes(date: parseDateString(item.date!)!, condition: item.condition ?? "", taxiTime: item.taxiTime))
            }
        }
        return temp
    }
    
    var aveTime: Int {
        let fetchedTimes = dataFilter()
        if let threeFlights = fetchedTimes["flights3"] as? FuelTaxiList {
            return threeFlights.aveTime
        }
        return 0
    }
    
    var ymax: Int {
        let fetchedTimes = dataFilter()
        if let threeFlights = fetchedTimes["flights3"] as? FuelTaxiList {
            return threeFlights.ymax
        }
        return 0
    }
}

//struct TaxiTimesJSON: Codable {
//        let date: String
//        let condition: String
//        let taxiTime: Int
//    }

//
//  taxiChart.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import SwiftUI
import Charts

struct taxiChartBarBasic: View {
    var taxiTimes: [TaxiTimes]
    var body: some View {
        Chart(taxiTimes) {
            BarMark(
                x: .value("Date", $0.date, unit: .day),
                y: .value("Date", $0.taxiTime)
            )
//            .foregroundStyle(by: .value("condition", $0.condition))
//            .position(by: .value("condition", $0.condition))
//            .symbol(by: .value("condition", $0.condition))
            
        }
        .chartLegend(position: .top)
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 3))
        }
    }
}

//struct TaxiTimes: Identifiable, Codable {
//    let date: Date
//    let condition: String
//    let taxiTime: Int
//    var id: Date { date }
//}


