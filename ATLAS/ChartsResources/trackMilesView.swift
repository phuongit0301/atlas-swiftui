//
//  trackMilesView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct trackMilesView: View {
    var convertedJSON: [String : [String : Any]]
    @SceneStorage("historyTimeframe") private var timeframe: trackMilesTimeframe = .threeFlights
    @State private var showMiles = true
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Actual minus plan track miles")
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
                            .tag(trackMilesTimeframe.threeFlights)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(trackMilesTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(trackMilesTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    Text("Total track shortening")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if showMiles {
                        Text("\(sumNM.formatted()) nm")
                            .font(.headline)
                        let filteredMiles = trackMiles.filter { $0.condition != "mins" }
                        trackMilesChart(trackMiles: filteredMiles, units: "nm")
                            .frame(minHeight: 300)
                    } else {
                        Text("\(sumMINS.formatted()) mins")
                            .font(.headline)
                        let filteredMiles = trackMiles.filter { $0.condition != "nm" }
                        trackMilesChart(trackMiles: filteredMiles, units: "mins")
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
    var trackMiles: [TrackMiles] {
        let fetchedTrackMiles: [String : [String : Any]] = convertedJSON

        //let fetchedTrackMiles: [String : [String : Any]] = fetchTrackMiles()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles["flights3"]!
            return threeFlights["trackMiles"] as! [TrackMiles]
        case .week:
            let week = fetchedTrackMiles["week1"]!
            return week["trackMiles"] as! [TrackMiles]
        case .months:
            let months = fetchedTrackMiles["months3"]!
            return months["trackMiles"] as! [TrackMiles]
        }
    }
    var sumMINS: Int {
        let fetchedTrackMiles: [String : [String : Any]] = convertedJSON

        //let fetchedTrackMiles: [String : [String : Any]] = fetchTrackMiles()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles["flights3"]!
            return threeFlights["sumMINS"] as! Int
        case .week:
            let week = fetchedTrackMiles["week1"]!
            return week["sumMINS"] as! Int
        case .months:
            let months = fetchedTrackMiles["months3"]!
            return months["sumMINS"] as! Int
        }
    }
    var sumNM: Int{
        let fetchedTrackMiles: [String : [String : Any]] = convertedJSON

        //let fetchedTrackMiles: [String : [String : Any]] = fetchTrackMiles()
        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles["flights3"]!
            return threeFlights["sumNM"] as! Int
        case .week:
            let week = fetchedTrackMiles["week1"]!
            return week["sumNM"] as! Int
        case .months:
            let months = fetchedTrackMiles["months3"]!
            return months["sumNM"] as! Int
        }
    }
}

// replace with API call
func fetchTrackMiles() -> [String : [String : Any]] {

    let entry1 = TrackMiles(phase: "dep", condition: "nm", trackMilesDiff: 5)
    let entry2 = TrackMiles(phase: "clb", condition: "nm", trackMilesDiff: -3)
    let entry3 = TrackMiles(phase: "crz", condition: "nm", trackMilesDiff: -12)
    let entry4 = TrackMiles(phase: "des", condition: "nm", trackMilesDiff: 8)
    let entry5 = TrackMiles(phase: "arr", condition: "nm", trackMilesDiff: -10)
    
    let entry1x = TrackMiles(phase: "dep", condition: "mins", trackMilesDiff: 2)
    let entry2x = TrackMiles(phase: "clb", condition: "mins", trackMilesDiff: -1)
    let entry3x = TrackMiles(phase: "crz", condition: "mins", trackMilesDiff: -4)
    let entry4x = TrackMiles(phase: "des", condition: "mins", trackMilesDiff: 2)
    let entry5x = TrackMiles(phase: "arr", condition: "mins", trackMilesDiff: -3)
    
    let entry1w = TrackMiles(phase: "dep", condition: "nm", trackMilesDiff: 0)
    let entry2w = TrackMiles(phase: "clb", condition: "nm", trackMilesDiff: 2)
    let entry3w = TrackMiles(phase: "crz", condition: "nm", trackMilesDiff: -10)
    let entry4w = TrackMiles(phase: "des", condition: "nm", trackMilesDiff: 5)
    let entry5w = TrackMiles(phase: "arr", condition: "nm", trackMilesDiff: -7)
    
    let entry1xw = TrackMiles(phase: "dep", condition: "mins", trackMilesDiff: 0)
    let entry2xw = TrackMiles(phase: "clb", condition: "mins", trackMilesDiff: 1)
    let entry3xw = TrackMiles(phase: "crz", condition: "mins", trackMilesDiff: -3)
    let entry4xw = TrackMiles(phase: "des", condition: "mins", trackMilesDiff: 2)
    let entry5xw = TrackMiles(phase: "arr", condition: "mins", trackMilesDiff: -2)
    
    let entry1m = TrackMiles(phase: "dep", condition: "nm", trackMilesDiff: 3)
    let entry2m = TrackMiles(phase: "clb", condition: "nm", trackMilesDiff: -5)
    let entry3m = TrackMiles(phase: "crz", condition: "nm", trackMilesDiff: -11)
    let entry4m = TrackMiles(phase: "des", condition: "nm", trackMilesDiff: 7)
    let entry5m = TrackMiles(phase: "arr", condition: "nm", trackMilesDiff: -12)
    
    let entry1xm = TrackMiles(phase: "dep", condition: "mins", trackMilesDiff: 1)
    let entry2xm = TrackMiles(phase: "clb", condition: "mins", trackMilesDiff: -2)
    let entry3xm = TrackMiles(phase: "crz", condition: "mins", trackMilesDiff: -3)
    let entry4xm = TrackMiles(phase: "des", condition: "mins", trackMilesDiff: 2)
    let entry5xm = TrackMiles(phase: "arr", condition: "mins", trackMilesDiff: -4)

    let trackMilesDays: [TrackMiles] = [entry1, entry2, entry3, entry4, entry5, entry1x, entry2x, entry3x, entry4x, entry5x]
    let trackMilesWeek: [TrackMiles] = [entry1w, entry2w, entry3w, entry4w, entry5w, entry1xw, entry2xw, entry3xw, entry4xw, entry5xw]
    let trackMilesMonths: [TrackMiles] = [entry1m, entry2m, entry3m, entry4m, entry5m, entry1xm, entry2xm, entry3xm, entry4xm, entry5xm]
    
    let aveMINSDays = -7
    let aveNMDays = -21
    let aveMINSWeek = -5
    let aveNMWeek = -15
    let aveMINSMonths = -4
    let aveNMMonths = -12
        
    let days = ["trackMiles": trackMilesDays, "sumNM": aveNMDays, "sumMINS": aveMINSDays] as [String : Any]
    let week = ["trackMiles": trackMilesWeek, "sumNM": aveNMWeek, "sumMINS": aveMINSWeek] as [String : Any]
    let months = ["trackMiles": trackMilesMonths, "sumNM": aveNMMonths, "sumMINS": aveMINSMonths] as [String : Any]

    let trackMilesAll = ["flights3": days, "week1": week, "months3": months]

    return trackMilesAll
}

struct TrackMilesJSON: Codable {
        let phase: String
        let condition: String
        let trackMilesDiff: Int
    }
