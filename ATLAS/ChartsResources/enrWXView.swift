//
//  enrWXView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct enrWXView: View {
    var convertedJSON: [String : [String : Any]]
    @SceneStorage("historyTimeframe") private var timeframe: enrWXTimeframe = .threeFlights
    @State private var showMiles = false
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Ave. enroute weather deviation")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle(isOn: $showMiles) {
                        Text("Show in nm")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 flights", systemImage: "calendar")
                            .tag(enrWXTimeframe.threeFlights)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(enrWXTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(enrWXTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    if showMiles {
                        Text("Average additional track miles due to enroute weather deviation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(aveNM.formatted()) nm")
                            .font(.headline)
                        let filteredMiles = trackMiles.filter { $0.condition != "mins" }
                        enrWXChart(trackMiles: filteredMiles, averageValue: aveNM)
                            .frame(minHeight: 300)
                    } else {
                        Text("Average additional flight time due to enroute weather deviation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(aveMINS.formatted()) mins")
                            .font(.headline)
                        let filteredMiles = trackMiles.filter { $0.condition != "nm" }
                        enrWXChart(trackMiles: filteredMiles, averageValue: aveMINS)
                            .frame(minHeight: 300)
                    }
                    
                }
                .padding()
            }
        }
        .navigationTitle("Track shortening")
        .background()
    }
    // switcher by period
    var trackMiles: [EnrWXTrackMiles] {
        let fetchedTrackMiles: [String : [String : Any]] = convertedJSON

        //let fetchedTrackMiles: [String : [String : Any]] = fetchTrackMiles()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles["flights3"]!
            return threeFlights["trackMiles"] as! [EnrWXTrackMiles]
        case .week:
            let week = fetchedTrackMiles["week1"]!
            return week["trackMiles"] as! [EnrWXTrackMiles]
        case .months:
            let months = fetchedTrackMiles["months3"]!
            return months["trackMiles"] as! [EnrWXTrackMiles]
        }
    }
    var aveMINS: Int {
        let fetchedTrackMiles: [String : [String : Any]] = convertedJSON

        //let fetchedTrackMiles: [String : [String : Any]] = fetchTrackMiles()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles["flights3"]!
            return threeFlights["aveMINS"] as! Int
        case .week:
            let week = fetchedTrackMiles["week1"]!
            return week["aveMINS"] as! Int
        case .months:
            let months = fetchedTrackMiles["months3"]!
            return months["aveMINS"] as! Int
        }
    }
    var aveNM: Int{
        let fetchedTrackMiles: [String : [String : Any]] = convertedJSON

        //let fetchedTrackMiles: [String : [String : Any]] = fetchTrackMiles()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles["flights3"]!
            return threeFlights["aveNM"] as! Int
        case .week:
            let week = fetchedTrackMiles["week1"]!
            return week["aveNM"] as! Int
        case .months:
            let months = fetchedTrackMiles["months3"]!
            return months["aveNM"] as! Int
        }
    }
}

// replace with API call
func fetchEnrWXTrackMiles() -> [String : [String : Any]] {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"

    let entry1 = EnrWXTrackMiles(date: dateFormatter.date(from: "01/05")!, condition: "nm", trackMilesDiff: 15)
    let entry2 = EnrWXTrackMiles(date: dateFormatter.date(from: "02/05")!, condition: "nm", trackMilesDiff: 8)
    let entry3 = EnrWXTrackMiles(date: dateFormatter.date(from: "03/05")!, condition: "nm", trackMilesDiff: 7)
    let entry4 = EnrWXTrackMiles(date: dateFormatter.date(from: "04/05")!, condition: "nm", trackMilesDiff: 12)
    let entry5 = EnrWXTrackMiles(date: dateFormatter.date(from: "05/05")!, condition: "nm", trackMilesDiff: 15)
    let entry6 = EnrWXTrackMiles(date: dateFormatter.date(from: "06/05")!, condition: "nm", trackMilesDiff: 5)
    let entry7 = EnrWXTrackMiles(date: dateFormatter.date(from: "07/05")!, condition: "nm", trackMilesDiff: 10)
    let entry8 = EnrWXTrackMiles(date: dateFormatter.date(from: "08/05")!, condition: "nm", trackMilesDiff: 12)
    let entry9 = EnrWXTrackMiles(date: dateFormatter.date(from: "09/05")!, condition: "nm", trackMilesDiff: 14)
    let entry10 = EnrWXTrackMiles(date: dateFormatter.date(from: "10/05")!, condition: "nm", trackMilesDiff: 18)
    let entry11 = EnrWXTrackMiles(date: dateFormatter.date(from: "11/05")!, condition: "nm", trackMilesDiff: 20)
    let entry12 = EnrWXTrackMiles(date: dateFormatter.date(from: "12/05")!, condition: "nm", trackMilesDiff: 5)
    let entry13 = EnrWXTrackMiles(date: dateFormatter.date(from: "13/05")!, condition: "nm", trackMilesDiff: 3)
    let entry14 = EnrWXTrackMiles(date: dateFormatter.date(from: "14/05")!, condition: "nm", trackMilesDiff: 7)
    let entry15 = EnrWXTrackMiles(date: dateFormatter.date(from: "15/05")!, condition: "nm", trackMilesDiff: 10)
    
    let entry1x = EnrWXTrackMiles(date: dateFormatter.date(from: "01/05")!, condition: "mins", trackMilesDiff: 5)
    let entry2x = EnrWXTrackMiles(date: dateFormatter.date(from: "02/05")!, condition: "mins", trackMilesDiff: 3)
    let entry3x = EnrWXTrackMiles(date: dateFormatter.date(from: "03/05")!, condition: "mins", trackMilesDiff: 2)
    let entry4x = EnrWXTrackMiles(date: dateFormatter.date(from: "04/05")!, condition: "mins", trackMilesDiff: 4)
    let entry5x = EnrWXTrackMiles(date: dateFormatter.date(from: "05/05")!, condition: "mins", trackMilesDiff: 5)
    let entry6x = EnrWXTrackMiles(date: dateFormatter.date(from: "06/05")!, condition: "mins", trackMilesDiff: 1)
    let entry7x = EnrWXTrackMiles(date: dateFormatter.date(from: "07/05")!, condition: "mins", trackMilesDiff: 2)
    let entry8x = EnrWXTrackMiles(date: dateFormatter.date(from: "08/05")!, condition: "mins", trackMilesDiff: 4)
    let entry9x = EnrWXTrackMiles(date: dateFormatter.date(from: "09/05")!, condition: "mins", trackMilesDiff: 5)
    let entry10x = EnrWXTrackMiles(date: dateFormatter.date(from: "10/05")!, condition: "mins", trackMilesDiff: 6)
    let entry11x = EnrWXTrackMiles(date: dateFormatter.date(from: "11/05")!, condition: "mins", trackMilesDiff: 7)
    let entry12x = EnrWXTrackMiles(date: dateFormatter.date(from: "12/05")!, condition: "mins", trackMilesDiff: 2)
    let entry13x = EnrWXTrackMiles(date: dateFormatter.date(from: "13/05")!, condition: "mins", trackMilesDiff: 1)
    let entry14x = EnrWXTrackMiles(date: dateFormatter.date(from: "14/05")!, condition: "mins", trackMilesDiff: 2)
    let entry15x = EnrWXTrackMiles(date: dateFormatter.date(from: "15/05")!, condition: "mins", trackMilesDiff: 3)
    
    let entry1w = EnrWXTrackMiles(date: dateFormatter.date(from: "01/05")!, condition: "nm", trackMilesDiff: 18)
    let entry2w = EnrWXTrackMiles(date: dateFormatter.date(from: "02/05")!, condition: "nm", trackMilesDiff: 5)
    let entry3w = EnrWXTrackMiles(date: dateFormatter.date(from: "03/05")!, condition: "nm", trackMilesDiff: 5)
    let entry4w = EnrWXTrackMiles(date: dateFormatter.date(from: "04/05")!, condition: "nm", trackMilesDiff: 15)
    let entry5w = EnrWXTrackMiles(date: dateFormatter.date(from: "05/05")!, condition: "nm", trackMilesDiff: 15)
    let entry6w = EnrWXTrackMiles(date: dateFormatter.date(from: "06/05")!, condition: "nm", trackMilesDiff: 17)
    let entry7w = EnrWXTrackMiles(date: dateFormatter.date(from: "07/05")!, condition: "nm", trackMilesDiff: 18)
    let entry8w = EnrWXTrackMiles(date: dateFormatter.date(from: "08/05")!, condition: "nm", trackMilesDiff: 7)
    let entry9w = EnrWXTrackMiles(date: dateFormatter.date(from: "09/05")!, condition: "nm", trackMilesDiff: 10)
    let entry10w = EnrWXTrackMiles(date: dateFormatter.date(from: "10/05")!, condition: "nm", trackMilesDiff: 9)
    let entry11w = EnrWXTrackMiles(date: dateFormatter.date(from: "11/05")!, condition: "nm", trackMilesDiff: 3)
    let entry12w = EnrWXTrackMiles(date: dateFormatter.date(from: "12/05")!, condition: "nm", trackMilesDiff: 24)
    let entry13w = EnrWXTrackMiles(date: dateFormatter.date(from: "13/05")!, condition: "nm", trackMilesDiff: 10)
    let entry14w = EnrWXTrackMiles(date: dateFormatter.date(from: "14/05")!, condition: "nm", trackMilesDiff: 13)
    let entry15w = EnrWXTrackMiles(date: dateFormatter.date(from: "15/05")!, condition: "nm", trackMilesDiff: 10)
    
    let entry1wx = EnrWXTrackMiles(date: dateFormatter.date(from: "01/05")!, condition: "mins", trackMilesDiff: 6)
    let entry2wx = EnrWXTrackMiles(date: dateFormatter.date(from: "02/05")!, condition: "mins", trackMilesDiff: 2)
    let entry3wx = EnrWXTrackMiles(date: dateFormatter.date(from: "03/05")!, condition: "mins", trackMilesDiff: 2)
    let entry4wx = EnrWXTrackMiles(date: dateFormatter.date(from: "04/05")!, condition: "mins", trackMilesDiff: 5)
    let entry5wx = EnrWXTrackMiles(date: dateFormatter.date(from: "05/05")!, condition: "mins", trackMilesDiff: 5)
    let entry6wx = EnrWXTrackMiles(date: dateFormatter.date(from: "06/05")!, condition: "mins", trackMilesDiff: 6)
    let entry7wx = EnrWXTrackMiles(date: dateFormatter.date(from: "07/05")!, condition: "mins", trackMilesDiff: 6)
    let entry8wx = EnrWXTrackMiles(date: dateFormatter.date(from: "08/05")!, condition: "mins", trackMilesDiff: 2)
    let entry9wx = EnrWXTrackMiles(date: dateFormatter.date(from: "09/05")!, condition: "mins", trackMilesDiff: 3)
    let entry10wx = EnrWXTrackMiles(date: dateFormatter.date(from: "10/05")!, condition: "mins", trackMilesDiff: 3)
    let entry11wx = EnrWXTrackMiles(date: dateFormatter.date(from: "11/05")!, condition: "mins", trackMilesDiff: 1)
    let entry12wx = EnrWXTrackMiles(date: dateFormatter.date(from: "12/05")!, condition: "mins", trackMilesDiff: 8)
    let entry13wx = EnrWXTrackMiles(date: dateFormatter.date(from: "13/05")!, condition: "mins", trackMilesDiff: 3)
    let entry14wx = EnrWXTrackMiles(date: dateFormatter.date(from: "14/05")!, condition: "mins", trackMilesDiff: 4)
    let entry15wx = EnrWXTrackMiles(date: dateFormatter.date(from: "15/05")!, condition: "mins", trackMilesDiff: 3)
    
    let entry1m = EnrWXTrackMiles(date: dateFormatter.date(from: "01/05")!, condition: "nm", trackMilesDiff: 0)
    let entry2m = EnrWXTrackMiles(date: dateFormatter.date(from: "02/05")!, condition: "nm", trackMilesDiff: 2)
    let entry3m = EnrWXTrackMiles(date: dateFormatter.date(from: "03/05")!, condition: "nm", trackMilesDiff: 29)
    let entry4m = EnrWXTrackMiles(date: dateFormatter.date(from: "04/05")!, condition: "nm", trackMilesDiff: 10)
    let entry5m = EnrWXTrackMiles(date: dateFormatter.date(from: "05/05")!, condition: "nm", trackMilesDiff: 5)
    let entry6m = EnrWXTrackMiles(date: dateFormatter.date(from: "06/05")!, condition: "nm", trackMilesDiff: 8)
    let entry7m = EnrWXTrackMiles(date: dateFormatter.date(from: "07/05")!, condition: "nm", trackMilesDiff: 10)
    let entry8m = EnrWXTrackMiles(date: dateFormatter.date(from: "08/05")!, condition: "nm", trackMilesDiff: 7)
    let entry9m = EnrWXTrackMiles(date: dateFormatter.date(from: "09/05")!, condition: "nm", trackMilesDiff: 5)
    let entry10m = EnrWXTrackMiles(date: dateFormatter.date(from: "10/05")!, condition: "nm", trackMilesDiff: 15)
    let entry11m = EnrWXTrackMiles(date: dateFormatter.date(from: "11/05")!, condition: "nm", trackMilesDiff: 6)
    let entry12m = EnrWXTrackMiles(date: dateFormatter.date(from: "12/05")!, condition: "nm", trackMilesDiff: 7)
    let entry13m = EnrWXTrackMiles(date: dateFormatter.date(from: "13/05")!, condition: "nm", trackMilesDiff: 12)
    let entry14m = EnrWXTrackMiles(date: dateFormatter.date(from: "14/05")!, condition: "nm", trackMilesDiff: 11)
    let entry15m = EnrWXTrackMiles(date: dateFormatter.date(from: "15/05")!, condition: "nm", trackMilesDiff: 9)
    
    let entry1mx = EnrWXTrackMiles(date: dateFormatter.date(from: "01/05")!, condition: "mins", trackMilesDiff: 0)
    let entry2mx = EnrWXTrackMiles(date: dateFormatter.date(from: "02/05")!, condition: "mins", trackMilesDiff: 0)
    let entry3mx = EnrWXTrackMiles(date: dateFormatter.date(from: "03/05")!, condition: "mins", trackMilesDiff: 9)
    let entry4mx = EnrWXTrackMiles(date: dateFormatter.date(from: "04/05")!, condition: "mins", trackMilesDiff: 3)
    let entry5mx = EnrWXTrackMiles(date: dateFormatter.date(from: "05/05")!, condition: "mins", trackMilesDiff: 2)
    let entry6mx = EnrWXTrackMiles(date: dateFormatter.date(from: "06/05")!, condition: "mins", trackMilesDiff: 3)
    let entry7mx = EnrWXTrackMiles(date: dateFormatter.date(from: "07/05")!, condition: "mins", trackMilesDiff: 3)
    let entry8mx = EnrWXTrackMiles(date: dateFormatter.date(from: "08/05")!, condition: "mins", trackMilesDiff: 2)
    let entry9mx = EnrWXTrackMiles(date: dateFormatter.date(from: "09/05")!, condition: "mins", trackMilesDiff: 2)
    let entry10mx = EnrWXTrackMiles(date: dateFormatter.date(from: "10/05")!, condition: "mins", trackMilesDiff: 3)
    let entry11mx = EnrWXTrackMiles(date: dateFormatter.date(from: "11/05")!, condition: "mins", trackMilesDiff: 2)
    let entry12mx = EnrWXTrackMiles(date: dateFormatter.date(from: "12/05")!, condition: "mins", trackMilesDiff: 2)
    let entry13mx = EnrWXTrackMiles(date: dateFormatter.date(from: "13/05")!, condition: "mins", trackMilesDiff: 4)
    let entry14mx = EnrWXTrackMiles(date: dateFormatter.date(from: "14/05")!, condition: "mins", trackMilesDiff: 4)
    let entry15mx = EnrWXTrackMiles(date: dateFormatter.date(from: "15/05")!, condition: "mins", trackMilesDiff: 3)

    let trackMilesDays: [EnrWXTrackMiles] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15, entry1x, entry2x, entry3x, entry4x, entry5x, entry6x, entry7x, entry8x, entry9x, entry10x, entry11x, entry12x, entry13x, entry14x, entry15x]
    let trackMilesWeek: [EnrWXTrackMiles] = [entry1w, entry2w, entry3w, entry4w, entry5w, entry6w, entry7w, entry8w, entry9w, entry10w, entry11w, entry12w, entry13w, entry14w, entry15w, entry1wx, entry2wx, entry3wx, entry4wx, entry5wx, entry6wx, entry7wx, entry8wx, entry9wx, entry10wx, entry11wx, entry12wx, entry13wx, entry14wx, entry15wx]
    let trackMilesMonths: [EnrWXTrackMiles] = [entry1m, entry2m, entry3m, entry4m, entry5m, entry6m, entry7m, entry8m, entry9m, entry10m, entry11m, entry12m, entry13m, entry14m, entry15m, entry1mx, entry2mx, entry3mx, entry4mx, entry5mx, entry6mx, entry7mx, entry8mx, entry9mx, entry10mx, entry11mx, entry12mx, entry13mx, entry14mx, entry15mx]
    
    let aveMINSDays = 3
    let aveNMDays = 10
    let aveMINSWeek = 5
    let aveNMWeek = 15
    let aveMINSMonths = 4
    let aveNMMonths = 12
        
    let days = ["trackMiles": trackMilesDays, "aveNM": aveNMDays, "aveMINS": aveMINSDays] as [String : Any]
    let week = ["trackMiles": trackMilesWeek, "aveNM": aveNMWeek, "aveMINS": aveMINSWeek] as [String : Any]
    let months = ["trackMiles": trackMilesMonths, "aveNM": aveNMMonths, "aveMINS": aveMINSMonths] as [String : Any]

    let trackMilesAll = ["flights3": days, "week1": week, "months3": months]

    return trackMilesAll
}

struct EnrWXTrackMilesJSON: Codable {
        let date: String
        let condition: String
        let trackMilesDiff: Int
    }
