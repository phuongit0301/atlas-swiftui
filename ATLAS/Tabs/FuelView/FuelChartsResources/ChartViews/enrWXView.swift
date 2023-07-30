//
//  enrWXView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct enrWXView: View {
    @Binding var dataEnrWX: [FuelEnrWXList]
    @SceneStorage("historyTimeframe") private var timeframe: enrWXTimeframe = .threeFlights
    @State private var showMiles = false
    @State private var trackMiles: [EnrWXTrackMiles]?
    
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
                        let filteredMiles = trackMiles?.filter { $0.condition != "mins" }
                        enrWXChart(trackMiles: filteredMiles ?? [], averageValue: aveNM)
                            .frame(minHeight: 300)
                    } else {
                        Text("Average additional flight time due to enroute weather deviation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(aveMINS.formatted()) mins")
                            .font(.headline)
                        let filteredMiles = trackMiles?.filter { $0.condition != "nm" }
                        enrWXChart(trackMiles: filteredMiles ?? [], averageValue: aveMINS)
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
    
    func dataFilter() -> [String: FuelEnrWXList?] {
        var flights3: FuelEnrWXList?
        var weeks: FuelEnrWXList?
        var months: FuelEnrWXList?
        
        dataEnrWX.forEach { item in
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
    func trackMilesFunc() -> [EnrWXTrackMiles] {
            let fetchedTrackMiles = dataFilter()
            var temp = [EnrWXTrackMiles]()
            
        switch timeframe {
        case .threeFlights:
            if let threeFlights = fetchedTrackMiles["flights3"] {
                let items = (threeFlights?.trackMiles?.allObjects as! [FuelEnrWXRefList]).sorted(by: {$0.order > $1.order})
                
                items.forEach {item in
                    temp.append(EnrWXTrackMiles(date: parseDateString(item.date!)!, condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                }
            }
            return temp
        case .week:
            if let weeks = fetchedTrackMiles["weeks"] {
                let items = (weeks?.trackMiles?.allObjects as! [FuelEnrWXRefList]).sorted(by: {$0.order > $1.order})
                
                items.forEach {item in
                    temp.append(EnrWXTrackMiles(date: parseDateString(item.date!)!, condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                }
            }
            return temp
        case .months:
            if let months = fetchedTrackMiles["months"] {
                let items = (months?.trackMiles?.allObjects as! [FuelEnrWXRefList]).sorted(by: {$0.order > $1.order})
                
                items.forEach {item in
                    temp.append(EnrWXTrackMiles(date: parseDateString(item.date!)!, condition: item.condition ?? "", trackMilesDiff: item.trackMilesDiff))
                }
            }
            return temp
        }
    }
    
    var aveMINS: Int {
        let fetchedTrackMiles = dataFilter()
        
        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTrackMiles["flights3"] as? FuelEnrWXList {
                    return threeFlights.aveMINS
                }
                return 0
            case .week:
                if let weeks = fetchedTrackMiles["weeks"] as? FuelEnrWXList {
                    return weeks.aveMINS
                }
                return 0
            case .months:
                if let months = fetchedTrackMiles["months"] as? FuelEnrWXList {
                    return months.aveMINS
                }
                return 0
        }
    }
    
    var aveNM: Int{
        let fetchedTrackMiles = dataFilter()

        switch timeframe {
            case .threeFlights:
                if let threeFlights = fetchedTrackMiles["flights3"] as? FuelEnrWXList {
                    return threeFlights.aveNM
                }
                return 0
            case .week:
                if let weeks = fetchedTrackMiles["weeks"] as? FuelEnrWXList {
                    return weeks.aveNM
                }
                return 0
            case .months:
                if let months = fetchedTrackMiles["months"] as? FuelEnrWXList {
                    return months.aveNM
                }
                return 0
        }
    }
}

struct EnrWXTrackMilesJSON: Codable {
        let date: String
        let condition: String
        let trackMilesDiff: Int
    }
