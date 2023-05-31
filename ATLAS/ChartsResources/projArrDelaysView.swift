//
//  projArrDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct projArrivalDelaysView: View {
    var convertedJSON: [String : Any]
    var body: some View {
        let fetchedDelays: [String: Any] = convertedJSON
        //
        //let fetchedDelays: [String: Any] = fetchProjArrivalDelays()
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
        .navigationTitle("Projected Delay")
        .background()
    }
}

// replace with API call
func fetchProjArrivalDelays() -> [String: Any] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"

    let entry1 = ProjArrivalDelays(time: dateFormatter.date(from: "08:00")!, delay: 10, mindelay: 10, maxdelay: 10)
    let entry2 = ProjArrivalDelays(time: dateFormatter.date(from: "09:00")!, delay: 15, mindelay: 15, maxdelay: 15)
    let entry3 = ProjArrivalDelays(time: dateFormatter.date(from: "10:00")!, delay: 5, mindelay: 5, maxdelay: 5)
    let entry4 = ProjArrivalDelays(time: dateFormatter.date(from: "11:00")!, delay: 1, mindelay: 1, maxdelay: 1)
    let entry5 = ProjArrivalDelays(time: dateFormatter.date(from: "12:00")!, delay: 2, mindelay: 2, maxdelay: 2)
    let entry6 = ProjArrivalDelays(time: dateFormatter.date(from: "13:00")!, delay: 4, mindelay: 3, maxdelay: 7)
    let entry7 = ProjArrivalDelays(time: dateFormatter.date(from: "14:00")!, delay: 4, mindelay: 2, maxdelay: 5)
    let entry8 = ProjArrivalDelays(time: dateFormatter.date(from: "15:00")!, delay: 5, mindelay: 3, maxdelay: 8)
    let entry9 = ProjArrivalDelays(time: dateFormatter.date(from: "16:00")!, delay: 5, mindelay: 4, maxdelay: 8)
    let entry10 = ProjArrivalDelays(time: dateFormatter.date(from: "17:00")!, delay: 10, mindelay: 8, maxdelay: 15)
    let entry11 = ProjArrivalDelays(time: dateFormatter.date(from: "18:00")!, delay: 15, mindelay: 10, maxdelay: 20)
    let entry12 = ProjArrivalDelays(time: dateFormatter.date(from: "19:00")!, delay: 15, mindelay: 10, maxdelay: 20)
    let entry13 = ProjArrivalDelays(time: dateFormatter.date(from: "20:00")!, delay: 12, mindelay: 10, maxdelay: 15)
    let entry14 = ProjArrivalDelays(time: dateFormatter.date(from: "21:00")!, delay: 6, mindelay: 5, maxdelay: 7)
    let entry15 = ProjArrivalDelays(time: dateFormatter.date(from: "22:00")!, delay: 3, mindelay: 2, maxdelay: 5)

    let projArrivalDelays: [ProjArrivalDelays] = [entry1, entry2, entry3, entry4, entry5, entry6, entry7, entry8, entry9, entry10, entry11, entry12, entry13, entry14, entry15]
    let expectedDelay: Int = 15
    let eta: Date = dateFormatter.date(from: "18:00")!
    let object = ["delays": projArrivalDelays, "expectedDelay": expectedDelay, "eta": eta] as [String : Any]
//    print(object)
    return object
}

struct ProjArrivalDelaysJSON: Codable {
        let time: String
        let delay: Int
        let mindelay: Int
        let maxdelay: Int
    }
