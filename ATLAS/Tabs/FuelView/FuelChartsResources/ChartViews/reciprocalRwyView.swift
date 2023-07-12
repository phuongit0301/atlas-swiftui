//
//  reciprocalRwyView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import Foundation
import SwiftUI

struct reciprocalRwyView: View {
    var convertedJSON: processedFuelDataModel.reciprocalRwyNestedJSON
    @State private var showMiles = false
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Reciprocal Runway")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle(isOn: $showMiles) {
                        Text("Show in nm")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    if showMiles {
                        Text("Average track miles difference")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(aveNM.formatted()) nm")
                            .font(.headline)
                        let filteredMiles = trackMiles.filter { $0.condition != "mins" }
                        reciprocalRwyChart(trackMiles: filteredMiles, averageValue: aveNM)
                            .frame(minHeight: 300)
                    } else {
                        Text("Average track miles difference")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(aveMINS.formatted()) mins")
                            .font(.headline)
                        let filteredMiles = trackMiles.filter { $0.condition != "nm" }
                        reciprocalRwyChart(trackMiles: filteredMiles, averageValue: aveMINS)
                            .frame(minHeight: 300)
                    }
                    
                }
                .padding()
            }
        }
        .navigationTitle("Track shortening")
        .background()
    }
    var trackMiles: [ReciprocalRwyTrackMiles] {
        let fetchedTrackMiles: processedFuelDataModel.reciprocalRwyNestedJSON = convertedJSON
        return fetchedTrackMiles.trackMiles
    }
    var aveMINS: Int {
        let fetchedTrackMiles: processedFuelDataModel.reciprocalRwyNestedJSON = convertedJSON
        return fetchedTrackMiles.aveMINS
    }
    var aveNM: Int{
        let fetchedTrackMiles: processedFuelDataModel.reciprocalRwyNestedJSON = convertedJSON
        return fetchedTrackMiles.aveNM
    }
}

struct ReciprocalRwyTrackMilesJSON: Codable {
        let date: String
        let condition: String
        let trackMilesDiff: Int
    }
