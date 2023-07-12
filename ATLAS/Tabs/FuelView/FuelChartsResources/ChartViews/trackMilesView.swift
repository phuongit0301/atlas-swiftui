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

struct TrackMilesJSON: Codable {
        let phase: String
        let condition: String
        let trackMilesDiff: Int
    }
