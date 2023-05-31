//
//  taxiView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct taxiView: View {
    var convertedJSON: [String : [String : Any]]
    @SceneStorage("historyTimeframe") private var timeframe: taxiTimeframe = .threeFlights

    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Actual vs plan taxi")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 flights", systemImage: "calendar")
                            .tag(taxiTimeframe.threeFlights)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(taxiTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(taxiTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    
                    Text("Average taxi time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(aveTime.formatted()) mins")
                        .font(.headline)
                    
                    taxiChart(taxiTimes: taxiTimes)
                        .frame(minHeight: 300)
                        .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                }
                .padding()
            }
        }
        .navigationTitle("Taxi")
        .background()
    }
    // switcher by period
    var taxiTimes: [TaxiTimes] {
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["times"] as! [TaxiTimes]
        case .week:
            let week = fetchedTimes["week1"]!
            return week["times"] as! [TaxiTimes]
        case .months:
            let months = fetchedTimes["months3"]!
            return months["times"] as! [TaxiTimes]
        }
    }
    var aveTime: Int {
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["aveTime"] as! Int
        case .week:
            let week = fetchedTimes["week1"]!
            return week["aveTime"] as! Int
        case .months:
            let months = fetchedTimes["months3"]!
            return months["aveTime"] as! Int
        }
    }
    var aveDiff: Int{
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["aveDiff"] as! Int
        case .week:
            let week = fetchedTimes["week1"]!
            return week["aveDiff"] as! Int
        case .months:
            let months = fetchedTimes["months3"]!
            return months["aveDiff"] as! Int
        }
    }
    var ymax: Int{
        let fetchedTimes: [String : [String : Any]] = convertedJSON

        //let fetchedTimes: [String : [String : Any]] = fetchTaxi()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTimes["flights3"]!
            return threeFlights["ymax"] as! Int
        case .week:
            let week = fetchedTimes["week1"]!
            return week["ymax"] as! Int
        case .months:
            let months = fetchedTimes["months3"]!
            return months["ymax"] as! Int
        }
    }
}

// replace with API call
func fetchTaxi() -> [String : [String : Any]] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"

    let entry1 = TaxiTimes(date: dateFormatter.date(from: "01/05")!, condition: "Plan", taxiTime: 15)
    let entry2 = TaxiTimes(date: dateFormatter.date(from: "02/05")!, condition: "Plan", taxiTime: 15)
    let entry3 = TaxiTimes(date: dateFormatter.date(from: "03/05")!, condition: "Plan", taxiTime: 15)
    let entry4 = TaxiTimes(date: dateFormatter.date(from: "04/05")!, condition: "Plan", taxiTime: 15)
    let entry5 = TaxiTimes(date: dateFormatter.date(from: "05/05")!, condition: "Plan", taxiTime: 15)
    let entry6 = TaxiTimes(date: dateFormatter.date(from: "06/05")!, condition: "Plan", taxiTime: 15)
    let entry7 = TaxiTimes(date: dateFormatter.date(from: "07/05")!, condition: "Plan", taxiTime: 15)
    let entry8 = TaxiTimes(date: dateFormatter.date(from: "08/05")!, condition: "Plan", taxiTime: 15)
    let entry9 = TaxiTimes(date: dateFormatter.date(from: "09/05")!, condition: "Plan", taxiTime: 15)
    let entry10 = TaxiTimes(date: dateFormatter.date(from: "10/05")!, condition: "Plan", taxiTime: 15)
    let entry11 = TaxiTimes(date: dateFormatter.date(from: "11/05")!, condition: "Plan", taxiTime: 15)
    let entry12 = TaxiTimes(date: dateFormatter.date(from: "12/05")!, condition: "Plan", taxiTime: 15)
    let entry13 = TaxiTimes(date: dateFormatter.date(from: "13/05")!, condition: "Plan", taxiTime: 15)
    let entry14 = TaxiTimes(date: dateFormatter.date(from: "14/05")!, condition: "Plan", taxiTime: 15)
    let entry15 = TaxiTimes(date: dateFormatter.date(from: "15/05")!, condition: "Plan", taxiTime: 15)
    
    let entry1x = TaxiTimes(date: dateFormatter.date(from: "01/05")!, condition: "Actual", taxiTime: 15)
    let entry2x = TaxiTimes(date: dateFormatter.date(from: "02/05")!, condition: "Actual", taxiTime: 18)
    let entry3x = TaxiTimes(date: dateFormatter.date(from: "03/05")!, condition: "Actual", taxiTime: 17)
    let entry4x = TaxiTimes(date: dateFormatter.date(from: "04/05")!, condition: "Actual", taxiTime: 20)
    let entry5x = TaxiTimes(date: dateFormatter.date(from: "05/05")!, condition: "Actual", taxiTime: 30)
    let entry6x = TaxiTimes(date: dateFormatter.date(from: "06/05")!, condition: "Actual", taxiTime: 20)
    let entry7x = TaxiTimes(date: dateFormatter.date(from: "07/05")!, condition: "Actual", taxiTime: 19)
    let entry8x = TaxiTimes(date: dateFormatter.date(from: "08/05")!, condition: "Actual", taxiTime: 25)
    let entry9x = TaxiTimes(date: dateFormatter.date(from: "09/05")!, condition: "Actual", taxiTime: 27)
    let entry10x = TaxiTimes(date: dateFormatter.date(from: "10/05")!, condition: "Actual", taxiTime: 24)
    let entry11x = TaxiTimes(date: dateFormatter.date(from: "11/05")!, condition: "Actual", taxiTime: 28)
    let entry12x = TaxiTimes(date: dateFormatter.date(from: "12/05")!, condition: "Actual", taxiTime: 29)
    let entry13x = TaxiTimes(date: dateFormatter.date(from: "13/05")!, condition: "Actual", taxiTime: 36)
    let entry14x = TaxiTimes(date: dateFormatter.date(from: "14/05")!, condition: "Actual", taxiTime: 20)
    let entry15x = TaxiTimes(date: dateFormatter.date(from: "15/05")!, condition: "Actual", taxiTime: 12)
    
    let entry1wx = TaxiTimes(date: dateFormatter.date(from: "01/05")!, condition: "Actual", taxiTime: 15)
    let entry2wx = TaxiTimes(date: dateFormatter.date(from: "02/05")!, condition: "Actual", taxiTime: 12)
    let entry3wx = TaxiTimes(date: dateFormatter.date(from: "03/05")!, condition: "Actual", taxiTime: 17)
    let entry4wx = TaxiTimes(date: dateFormatter.date(from: "04/05")!, condition: "Actual", taxiTime: 14)
    let entry5wx = TaxiTimes(date: dateFormatter.date(from: "05/05")!, condition: "Actual", taxiTime: 15)
    let entry6wx = TaxiTimes(date: dateFormatter.date(from: "06/05")!, condition: "Actual", taxiTime: 13)
    let entry7wx = TaxiTimes(date: dateFormatter.date(from: "07/05")!, condition: "Actual", taxiTime: 19)
    let entry8wx = TaxiTimes(date: dateFormatter.date(from: "08/05")!, condition: "Actual", taxiTime: 20)
    let entry9wx = TaxiTimes(date: dateFormatter.date(from: "09/05")!, condition: "Actual", taxiTime: 12)
    let entry10wx = TaxiTimes(date: dateFormatter.date(from: "10/05")!, condition: "Actual", taxiTime: 15)
    let entry11wx = TaxiTimes(date: dateFormatter.date(from: "11/05")!, condition: "Actual", taxiTime: 15)
    let entry12wx = TaxiTimes(date: dateFormatter.date(from: "12/05")!, condition: "Actual", taxiTime: 15)
    let entry13wx = TaxiTimes(date: dateFormatter.date(from: "13/05")!, condition: "Actual", taxiTime: 11)
    let entry14wx = TaxiTimes(date: dateFormatter.date(from: "14/05")!, condition: "Actual", taxiTime: 17)
    let entry15wx = TaxiTimes(date: dateFormatter.date(from: "15/05")!, condition: "Actual", taxiTime: 18)
    
    let entry1mx = TaxiTimes(date: dateFormatter.date(from: "01/05")!, condition: "Actual", taxiTime: 7)
    let entry2mx = TaxiTimes(date: dateFormatter.date(from: "02/05")!, condition: "Actual", taxiTime: 8)
    let entry3mx = TaxiTimes(date: dateFormatter.date(from: "03/05")!, condition: "Actual", taxiTime: 9)
    let entry4mx = TaxiTimes(date: dateFormatter.date(from: "04/05")!, condition: "Actual", taxiTime: 10)
    let entry5mx = TaxiTimes(date: dateFormatter.date(from: "05/05")!, condition: "Actual", taxiTime: 15)
    let entry6mx = TaxiTimes(date: dateFormatter.date(from: "06/05")!, condition: "Actual", taxiTime: 12)
    let entry7mx = TaxiTimes(date: dateFormatter.date(from: "07/05")!, condition: "Actual", taxiTime: 9)
    let entry8mx = TaxiTimes(date: dateFormatter.date(from: "08/05")!, condition: "Actual", taxiTime: 10)
    let entry9mx = TaxiTimes(date: dateFormatter.date(from: "09/05")!, condition: "Actual", taxiTime: 10)
    let entry10mx = TaxiTimes(date: dateFormatter.date(from: "10/05")!, condition: "Actual", taxiTime: 13)
    let entry11mx = TaxiTimes(date: dateFormatter.date(from: "11/05")!, condition: "Actual", taxiTime: 14)
    let entry12mx = TaxiTimes(date: dateFormatter.date(from: "12/05")!, condition: "Actual", taxiTime: 7)
    let entry13mx = TaxiTimes(date: dateFormatter.date(from: "13/05")!, condition: "Actual", taxiTime: 10)
    let entry14mx = TaxiTimes(date: dateFormatter.date(from: "14/05")!, condition: "Actual", taxiTime: 10)
    let entry15mx = TaxiTimes(date: dateFormatter.date(from: "15/05")!, condition: "Actual", taxiTime: 12)

    let timesDays: [TaxiTimes] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1x, entry2x, entry3x, entry4x, entry5x, entry6x, entry7x, entry8x, entry9x, entry10x, entry11x, entry12x, entry13x, entry14x, entry15x]
    let timesWeek: [TaxiTimes] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1wx, entry2wx, entry3wx, entry4wx, entry5wx, entry6wx, entry7wx, entry8wx, entry9wx, entry10wx, entry11wx, entry12wx, entry13wx, entry14wx, entry15wx]
    let timesMonths: [TaxiTimes] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1mx, entry2mx, entry3mx, entry4mx, entry5mx, entry6mx, entry7mx, entry8mx, entry9mx, entry10mx, entry11mx, entry12mx, entry13mx, entry14mx, entry15mx]
    
    let aveTimeDays = 25
    let aveDiffDays = 10
    let aveTimeWeek = 15
    let aveDiffWeek = 0
    let aveTimeMonths = 10
    let aveDiffMonths = -5
    let ymax = 40
        
    let days = ["times": timesDays, "aveTime": aveTimeDays, "aveDiff": aveDiffDays, "ymax": ymax] as [String : Any]
    let week = ["times": timesWeek, "aveTime": aveTimeWeek, "aveDiff": aveDiffWeek, "ymax": ymax] as [String : Any]
    let months = ["times": timesMonths, "aveTime": aveTimeMonths, "aveDiff": aveDiffMonths, "ymax": ymax] as [String : Any]

    let taxiTimesAll = ["flights3": days, "week1": week, "months3": months]

    return taxiTimesAll
}

struct TaxiTimesJSON: Codable {
        let date: String
        let condition: String
        let taxiTime: Int
    }
