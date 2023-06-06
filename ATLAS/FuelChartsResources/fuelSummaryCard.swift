//
//  SummaryCard.swift
//  ATLAS
//
//  Created by Muhammad Adil on 26/5/23.
//

import Foundation
import SwiftUI

struct SummaryCardView: View {
    let fetchedDelays: [String: Any]
    let fetchedTimes: [String : [String : Any]]
    let fetchedMiles: [String : [String : Any]]
    let fetchedEnrWX: [String : [String : Any]]
    let fetchedLevels: [String : [String : Any]]

    var body: some View {
        // arrival delays
        let projDelay: Int = fetchedDelays["expectedDelay"] as! Int
        
        // taxi
        let threeFlightsTaxi = fetchedTimes["flights3"]!
        let aveDiffTaxi: Int = threeFlightsTaxi["aveDiff"] as! Int
        
        // track miles
        let threeFlightsMiles = fetchedMiles["flights3"]!
        let sumMINS: Int = threeFlightsMiles["sumMINS"] as! Int
        
        // enroute weather
        let threeFlightsEnrWX = fetchedEnrWX["flights3"]!
        let aveDiffEnrWX: Int = threeFlightsEnrWX["aveMINS"] as! Int
        
        // flight level
        let threeFlightsLevels = fetchedLevels["flights3"]!
        let aveDiffLevels: Int = threeFlightsLevels["aveDiff"] as! Int
        
        let extraFuel = projDelay + aveDiffTaxi + sumMINS + aveDiffEnrWX
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Extra fuel requirement")
                  .font(.title2)
                  .foregroundColor(.blue)
                  .fontWeight(.regular)
                Text("Aggregate extra fuel requirement in mins")
                  .font(.subheadline)
                  .fontWeight(.light)
                if (extraFuel < 0) {
                    let savings = extraFuel * -1
                    Text("0 mins")
                      .font(.largeTitle)
                      .fontWeight(.semibold)
                      .padding(.top, 1)
                    Text("Fuel savings of \(savings) mins expected")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("+\(extraFuel.formatted()) mins")
                      .font(.largeTitle)
                      .fontWeight(.semibold)
                      .padding(.top, 1)
                }
                
            }
            .padding()
            Divider()
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("+\(projDelay.formatted()) mins")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Projected arrival delay")
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.top, 1)
                }
                .padding()
                VStack(alignment: .leading) {
                    if (aveDiffTaxi < 0) {
                        Text("\(aveDiffTaxi.formatted()) mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } else {
                        Text("+\(aveDiffTaxi.formatted()) mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Text("Actual minus plan taxi time")
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.top, 1)
                }
                .padding()
                VStack(alignment: .leading) {
                    if (sumMINS < 0) {
                        Text("\(sumMINS.formatted()) mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } else {
                        Text("0 mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Text("Expected track shortening")
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.top, 1)
                }
                .padding()
                VStack(alignment: .leading) {
                    if (aveDiffEnrWX < 0) {
                        Text("0 mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } else {
                        Text("+\(aveDiffEnrWX.formatted()) mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Text("Enroute weather deviation")
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.top, 1)
                }
                .padding()
                VStack(alignment: .leading) {
                    if (aveDiffLevels < 0) {
                        Text("\(aveDiffLevels.formatted()) ft")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } else {
                        Text("+\(aveDiffLevels.formatted()) ft")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    Text("Actual minus plan flight level")
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.top, 1)
                }
                .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Summary Card")
        .background()
    }
}

