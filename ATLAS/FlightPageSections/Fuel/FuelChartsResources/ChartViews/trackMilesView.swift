//
//  trackMilesView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct trackMilesView: View {
    @Binding var dataTrackMiles: [FuelTrackMilesList]
    @SceneStorage("historyTimeframe") private var timeframe: trackMilesTimeframe = .threeFlights
    @State private var showMiles = true
    @State private var trackMiles: [TrackMiles]?
    
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
                        let filteredMiles = trackMiles?.filter { $0.condition != "mins" }
                        trackMilesChart(trackMiles: filteredMiles ?? [], units: "nm")
                            .frame(minHeight: 300)
                    } else {
                        Text("\(sumMINS.formatted()) mins")
                            .font(.headline)
                        let filteredMiles = trackMiles?.filter { $0.condition != "nm" }
                        trackMilesChart(trackMiles: filteredMiles ?? [], units: "mins")
                            .frame(minHeight: 300)
                    }
                    
                }
                .padding()
                .onAppear {
                    handleData()
                }.onChange(of: timeframe) { _ in
                    handleData()
                }
            }
        }
        .navigationTitle("Track shortening")
        .background()
    }
    
    func handleData() {
        trackMiles = trackMilesFunc()
    }
    
    func dataFilter() -> [String: FuelTrackMilesList?] {
        var flights3: FuelTrackMilesList?
        var weeks: FuelTrackMilesList?
        var months: FuelTrackMilesList?
        
        dataTrackMiles.forEach { item in
            if item.type == "flights3" {
                flights3 = item
            } else if item.type == "week1" {
                weeks = item
            } else if item.type == "months3" {
                months = item
            }
        }
        
        return ["flights3": flights3, "weeks": weeks, "months": months]
    }
    
    // switcher by period
    func trackMilesFunc() -> [TrackMiles] {
        let fetchedTrackMiles = dataFilter()
        var temp = [TrackMiles]()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTrackMiles["flights3"] {
                    let items = (threeFlights?.trackMiles?.allObjects as! [FuelTrackMilesRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(TrackMiles(phase: item.phase ?? "", condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                    }
                }
                return temp
            case .week:
                if let weeks = fetchedTrackMiles["weeks"] {
                    let items = (weeks?.trackMiles?.allObjects as! [FuelTrackMilesRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(TrackMiles(phase: item.phase ?? "", condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                    }
                }
                return temp
            case .months:
                if let months = fetchedTrackMiles["months"] {
                    let items = (months?.trackMiles?.allObjects as! [FuelTrackMilesRefList]).sorted(by: {$0.order < $1.order})
                    
                    items.forEach {item in
                        temp.append(TrackMiles(phase: item.phase ?? "", condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                    }
                }
                return temp
        }
    }
    
    var sumMINS: Int {
        let fetchedTrackMiles = dataFilter()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTrackMiles["flights3"] as? FuelTrackMilesList {
                    return threeFlights.sumMINS
                }
                return 0
            case .week:
                if let weeks = fetchedTrackMiles["weeks"] as? FuelTrackMilesList {
                    return weeks.sumMINS
                }
                return 0
            case .months:
                if let months = fetchedTrackMiles["months"] as? FuelTrackMilesList {
                    return months.sumMINS
                }
                return 0
        }
    }
    
    var sumNM: Int{
        let fetchedTrackMiles = dataFilter()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTrackMiles["flights3"] as? FuelTrackMilesList {
                    return threeFlights.sumNM
                }
                return 0
            case .week:
                if let weeks = fetchedTrackMiles["weeks"] as? FuelTrackMilesList {
                    return weeks.sumNM
                }
                return 0
            case .months:
                if let months = fetchedTrackMiles["months"] as? FuelTrackMilesList {
                    return months.sumNM
                }
                return 0
        }
    }
}

struct TrackMilesJSON: Codable {
        let phase: String
        let condition: String
        let trackMilesDiff: Int
    }
