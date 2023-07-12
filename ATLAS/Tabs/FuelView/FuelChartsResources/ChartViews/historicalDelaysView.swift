//
//  arrDelaysView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 25/5/23.
//

import Foundation
import SwiftUI

struct historicalDelaysView: View {
    var convertedJSON: processedFuelDataModel.arrivalDelaysNestedJSON
    @SceneStorage("historyTimeframe") private var timeframe: delayTimeframe = .days
    
    @State private var showWeather = true
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        Text("Historical delays")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Spacer()
                        Toggle(isOn: $showWeather) {
                        Text("Weather delays")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    Picker("Timeframe", selection: $timeframe) {
                        Label("3 Days", systemImage: "calendar")
                            .tag(delayTimeframe.days)
                        
                        Label("1 Week", systemImage: "calendar")
                            .tag(delayTimeframe.week)
                        
                        Label("3 Months", systemImage: "calendar")
                            .tag(delayTimeframe.months)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 10)
                    if showWeather {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelayWX.formatted()) mins")
                            .font(.headline)
                        historicalDelaysChart(arrivalDelays: delays, eta: eta, arrTimeDelay: arrTimeDelayWX, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    } else {
                        Text("Historical average delay during arrival time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(arrTimeDelay.formatted()) mins")
                            .font(.headline)
                        let filteredDelays = delays.filter { $0.condition != "Added delay due WX" }
                        historicalDelaysChart(arrivalDelays: filteredDelays, eta: eta, arrTimeDelay: arrTimeDelay, ymax: ymax)
                            .frame(minHeight: 300)
                            .chartYScale(domain: 0 ... ymax) // set dynamic domain to max of y value
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Historical Delays")
        .background()
    }
    // switcher by period
    var delays: [ArrivalDelays] {
        let fetchedDelays: processedFuelDataModel.arrivalDelaysNestedJSON = convertedJSON

        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays.days3
            return fetchedDelaysItems!.delays 
        case .week:
            let fetchedDelaysItems = fetchedDelays.week1
            return fetchedDelaysItems!.delays
        case .months:
            let fetchedDelaysItems = fetchedDelays.months3
            return fetchedDelaysItems!.delays 
        }
    }
    var arrTimeDelay: Int {
        let fetchedDelays: processedFuelDataModel.arrivalDelaysNestedJSON = convertedJSON

        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays.days3
            return fetchedDelaysItems!.arrTimeDelay
        case .week:
            let fetchedDelaysItems = fetchedDelays.week1
            return fetchedDelaysItems!.arrTimeDelay
        case .months:
            let fetchedDelaysItems = fetchedDelays.months3
            return fetchedDelaysItems!.arrTimeDelay
        }
    }
    var arrTimeDelayWX: Int{
        let fetchedDelays: processedFuelDataModel.arrivalDelaysNestedJSON = convertedJSON

        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays.days3
            return fetchedDelaysItems!.arrTimeDelayWX
        case .week:
            let fetchedDelaysItems = fetchedDelays.week1
            return fetchedDelaysItems!.arrTimeDelayWX
        case .months:
            let fetchedDelaysItems = fetchedDelays.months3
            return fetchedDelaysItems!.arrTimeDelayWX
        }
    }
    var eta: Date{
        let fetchedDelays: processedFuelDataModel.arrivalDelaysNestedJSON = convertedJSON

        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays.days3
            return fetchedDelaysItems!.eta
        case .week:
            let fetchedDelaysItems = fetchedDelays.week1
            return fetchedDelaysItems!.eta
        case .months:
            let fetchedDelaysItems = fetchedDelays.months3
            return fetchedDelaysItems!.eta
        }
    }
    var ymax: Int{
        let fetchedDelays: processedFuelDataModel.arrivalDelaysNestedJSON = convertedJSON

        switch timeframe {
        case .days:
            let fetchedDelaysItems = fetchedDelays.days3
            return fetchedDelaysItems!.ymax
        case .week:
            let fetchedDelaysItems = fetchedDelays.week1
            return fetchedDelaysItems!.ymax
        case .months:
            let fetchedDelaysItems = fetchedDelays.months3
            return fetchedDelaysItems!.ymax
        }
    }
    
}

struct ArrivalDelaysJSON: Codable {
        let condition: String
        let time: String
        let delay: Int
    }
