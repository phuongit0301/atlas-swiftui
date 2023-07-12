//
//  trackMilesView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct trackMilesView: View {
    var convertedJSON: processedFuelDataModel.trackMilesNestedJSON
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
        let fetchedTrackMiles: processedFuelDataModel.trackMilesNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles.flights3
            return threeFlights!.trackMiles
        case .week:
            let week = fetchedTrackMiles.week1
            return week!.trackMiles
        case .months:
            let months = fetchedTrackMiles.months3
            return months!.trackMiles
        }
    }
    var sumMINS: Int {
        let fetchedTrackMiles: processedFuelDataModel.trackMilesNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles.flights3
            return threeFlights!.sumMINS
        case .week:
            let week = fetchedTrackMiles.week1
            return week!.sumMINS
        case .months:
            let months = fetchedTrackMiles.months3
            return months!.sumMINS
        }
    }
    var sumNM: Int{
        let fetchedTrackMiles: processedFuelDataModel.trackMilesNestedJSON = convertedJSON

        switch timeframe {
        case .threeFlights:
            let threeFlights = fetchedTrackMiles.flights3
            return threeFlights!.sumNM
        case .week:
            let week = fetchedTrackMiles.week1
            return week!.sumNM
        case .months:
            let months = fetchedTrackMiles.months3
            return months!.sumNM
        }
    }
}

struct TrackMilesJSON: Codable {
        let phase: String
        let condition: String
        let trackMilesDiff: Int
    }
