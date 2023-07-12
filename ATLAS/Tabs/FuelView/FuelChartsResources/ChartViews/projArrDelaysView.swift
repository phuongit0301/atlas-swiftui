//
//  projArrDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct projArrivalDelaysView: View {
    var convertedJSON: processedFuelDataModel.projArrivalDelaysNestedJSON
    
    var body: some View {
        let fetchedDelays: processedFuelDataModel.projArrivalDelaysNestedJSON = convertedJSON
        let delays: [ProjArrivalDelays] = fetchedDelays.delays 
        let projDelay: Int = fetchedDelays.expectedDelay
        let eta: Date = fetchedDelays.eta
        
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Projected delay")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Spacer()
                    Text("Expected delay during arrival time, taking into account expected weather conditions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(projDelay.formatted()) mins")
                        .font(.headline)
                    
                    projArrivalDelaysChart(projArrivalDelays: delays, projDelay: projDelay, eta: eta)
                        .frame(minHeight: 300)
                }
                .padding()
            }
        }
        .navigationTitle("")
        .background()
    }
}

struct ProjArrivalDelaysJSON: Codable {
        let time: String
        let delay: Float
        let mindelay: Float
        let maxdelay: Float
    }
