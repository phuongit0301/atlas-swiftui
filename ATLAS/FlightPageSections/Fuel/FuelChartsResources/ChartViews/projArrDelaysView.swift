//
//  projArrDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct projArrivalDelaysView: View {
    @Binding var dataProjDelays: ProjDelaysList?
    
    var body: some View {
        let fetchedDelays: [String: Any] = fetchProjArrivalDelays(dataProjDelays)
        let delays: [ProjArrivalDelays] = fetchedDelays["delays"] as! [ProjArrivalDelays]
        let projDelay: Int = fetchedDelays["expectedDelay"] as! Int
        let eta: Date = fetchedDelays["eta"] as! Date
        
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

// replace with API call
func fetchProjArrivalDelays(_ dataProjDelays: ProjDelaysList?) -> [String: Any] {
    if dataProjDelays?.delays == nil {
        return ["delays": [], "expectedDelay": 0, "eta": Date()] as [String : Any]
    }
    var projArrivalDelays = [ProjArrivalDelays]()
    let items = (dataProjDelays?.delays?.allObjects as! [ProjDelaysListRef]).sorted(by: {$0.order < $1.order})
    
    items.forEach { item in
        let entry = ProjArrivalDelays(time: item.unwrappedTime!, delay: item.delay, mindelay: item.mindelay, maxdelay: item.maxdelay)
        projArrivalDelays.append(entry)
    }
    
    let object = ["delays": projArrivalDelays, "expectedDelay": dataProjDelays?.expectedDelay, "eta": dataProjDelays?.unwrappedEta] as [String : Any]
    return object
}

struct ProjArrivalDelaysJSON: Codable {
        let time: String
        let delay: Float
        let mindelay: Float
        let maxdelay: Float
    }
