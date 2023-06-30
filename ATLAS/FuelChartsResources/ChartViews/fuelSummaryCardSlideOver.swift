//
//  fuelSummaryCardSlideOver.swift
//  ATLAS
//
//  Created by Muhammad Adil on 6/6/23.
//

import Foundation
import SwiftUI

struct SummaryCardViewSlideOver: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
//    @ObservedObject var apiManager = APIManager.shared
    @ObservedObject var globalResponse = GlobalResponse.shared
#endif
        
    var body: some View {
        let allAPIresponse = convertAllresponseFromAPI(jsonString: globalResponse.response)
        let projDelaysResponse = allAPIresponse["projDelays"]
        let flightLevelResponse = allAPIresponse["flightLevel"]
        let trackMilesResponse = allAPIresponse["trackMiles"]
        let taxiResponse = allAPIresponse["taxi"]
        let enrWXResponse = allAPIresponse["enrWX"]
        
        // arrival delays
        let fetchedDelays: [String: Any] = projDelaysResponse as! [String : Any]
        let projDelay: Int = fetchedDelays["expectedDelay"] as! Int
        
        // taxi
        let fetchedTimes: [String : [String : Any]] = taxiResponse as! [String : [String : Any]]
        let threeFlightsTaxi = fetchedTimes["flights3"]!
        let aveDiffTaxi: Int = threeFlightsTaxi["aveDiff"] as! Int
        
        // track miles
        let fetchedMiles: [String : [String : Any]] = trackMilesResponse as! [String : [String : Any]]
        let threeFlightsMiles = fetchedMiles["flights3"]!
        let sumMINS: Int = threeFlightsMiles["sumMINS"] as! Int
        
        // enroute weather
        let fetchedEnrWX: [String : [String : Any]] = enrWXResponse as! [String : [String : Any]]
        let threeFlightsEnrWX = fetchedEnrWX["flights3"]!
        let aveDiffEnrWX: Int = threeFlightsEnrWX["aveMINS"] as! Int
        
        // flight level
        let fetchedLevels: [String : [String : Any]] = flightLevelResponse as! [String : [String : Any]]
        let threeFlightsLevels = fetchedLevels["flights3"]!
        let aveDiffLevels: Int = threeFlightsLevels["aveDiff"] as! Int
        
        //let extraFuel = projDelay + aveDiffTaxi + sumMINS + aveDiffEnrWX
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Extra fuel requirement")
                  .font(.title2)
                  .foregroundColor(.blue)
                  .fontWeight(.regular)
                Text("Aggregate extra fuel requirement in mins")
                  .font(.subheadline)
                  .fontWeight(.light)
                
            }
            .padding()
            Divider()
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    if (projDelay < 0) {
                        Text("0 mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                    } else {
                        Text("+\(projDelay.formatted()) mins")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Projected arrival delay")
                            .font(.callout)
                            .fontWeight(.regular)
                            .padding(.top, 1)
                    }
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
                    Text("Additional taxi time")
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
        .navigationTitle("Fuel Summary")
        .background()
    }
}

struct SummaryCardViewSlideOver_Previews: PreviewProvider {
    
    struct Preview: View {
        var body: some View {
            SummaryCardViewSlideOver()
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
        .previewDevice("iPhone 14")
    }
}

