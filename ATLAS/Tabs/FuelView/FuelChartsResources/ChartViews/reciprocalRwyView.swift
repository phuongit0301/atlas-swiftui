//
//  reciprocalRwyView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 30/6/23.
//

import Foundation
import SwiftUI

struct reciprocalRwyView: View {
    @Binding var dataReciprocalRwy: FuelReciprocalRwyList
    @State private var showMiles = false
    @State var trackMiles: [ReciprocalRwyTrackMiles]?
    
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
                        Text("\(dataReciprocalRwy.aveNM.formatted()) nm")
                            .font(.headline)
                        let filteredMiles = trackMiles?.filter { $0.condition != "mins" }
                        reciprocalRwyChart(trackMiles: filteredMiles ?? [], averageValue: dataReciprocalRwy.aveNM)
                            .frame(minHeight: 300)
                    } else {
                        Text("Average track miles difference")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(dataReciprocalRwy.aveMINS.formatted()) mins")
                            .font(.headline)
                        let filteredMiles = trackMiles?.filter { $0.condition != "nm" }
                        reciprocalRwyChart(trackMiles: filteredMiles ?? [], averageValue: dataReciprocalRwy.aveMINS)
                            .frame(minHeight: 300)
                    }
                    
                }
                .padding()
                .onAppear {
                    var temp = [ReciprocalRwyTrackMiles]()
                    
                    let items = (dataReciprocalRwy.trackMiles?.allObjects as! [FuelReciprocalRwyRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(ReciprocalRwyTrackMiles(date: parseDateString(item.date!)!, condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                    }
                    
                    self.trackMiles = temp
                }
            }
        }
        .navigationTitle("Track shortening")
        .background()
    }
}

struct ReciprocalRwyTrackMilesJSON: Codable {
        let date: String
        let condition: String
        let trackMilesDiff: Int
    }
