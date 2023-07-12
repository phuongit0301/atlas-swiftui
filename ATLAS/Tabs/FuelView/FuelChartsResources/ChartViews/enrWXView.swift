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

struct EnrWXTrackMilesJSON: Codable {
        let date: String
        let condition: String
        let trackMilesDiff: Int
    }
