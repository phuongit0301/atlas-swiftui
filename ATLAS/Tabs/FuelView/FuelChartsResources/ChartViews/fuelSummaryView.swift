//
//  SummaryView.swift
//  ATLAS
//
//  Created by Muhammad Adil on 15/05/2023.
//

import SwiftUI
import UIKit
import MobileCoreServices
import QuickLookThumbnailing
import Foundation

struct SummaryView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) private var sizeClass
//    @ObservedObject var apiManager = APIManager.shared
    @ObservedObject var globalResponse = GlobalResponse.shared
    @EnvironmentObject var coreDataModel: CoreDataModelState
#endif
    var body: some View {
        // decode, split into charts and assign to variables
//        let allAPIresponse = convertAllresponseFromAPI(jsonString: globalResponse.response)
//        let projDelaysResponse = allAPIresponse["projDelays"]
//        let historicalDelaysResponse = allAPIresponse["historicalDelays"]
//        let flightLevelResponse = allAPIresponse["flightLevel"]
//        let trackMilesResponse = allAPIresponse["trackMiles"]
//        let taxiResponse = allAPIresponse["taxi"]
//        let enrWXResponse = allAPIresponse["enrWX"]
        
        WidthThresholdReader(widthThreshold: 520) { proxy in
            ScrollView(.vertical) {
                VStack(spacing: 16) {
//                    SummaryCardView(fetchedDelays: coreDataModel.dataProjDelays as! [String : Any], fetchedTimes: taxiResponse as! [String : [String : Any]], fetchedMiles: trackMilesResponse as! [String : [String : Any]], fetchedEnrWX: enrWXResponse as! [String : [String : Any]], fetchedLevels: flightLevelResponse as! [String : [String : Any]])
//                        .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                        .fixedSize(horizontal: false, vertical: true)
//                        .padding([.horizontal, .top], 12)
//                        .frame(maxWidth: .infinity)
//
                    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                        if proxy.isCompact {
//                            projArrivalDelaysView(dataProjDelays: $coreDataModel.dataProjDelays)
//                            historicalDelaysView(convertedJSON: historicalDelaysResponse as! [String : [String : Any]])
//                            taxiView(convertedJSON: taxiResponse as! [String : [String : Any]])
//                            trackMilesView(convertedJSON: trackMilesResponse as! [String : [String : Any]])
//                            enrWXView(convertedJSON: enrWXResponse as! [String : [String : Any]])
//                            flightLevelView(convertedJSON: flightLevelResponse as! [String : [String : Any]])
//
                        } else {
                            GridRow {
//                                projArrivalDelaysView(dataProjDelays: $coreDataModel.dataProjDelays)
//                                historicalDelaysView(convertedJSON: coreDataModel.dataProjDelays as! [String : [String : Any]])
                            }
//                            GridRow {
//                                taxiView(convertedJSON: taxiResponse as! [String : [String : Any]])
//                                trackMilesView(convertedJSON: trackMilesResponse as! [String : [String : Any]])
//                            }
//                            GridRow {
//                                enrWXView(convertedJSON: enrWXResponse as! [String : [String : Any]])
//                                flightLevelView(convertedJSON: flightLevelResponse as! [String : [String : Any]])
//                            }
//                            .containerShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
//                            .fixedSize(horizontal: false, vertical: true)
//                            .padding([.horizontal, .bottom], 16)
//                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }.padding(.vertical, 32)
        }
#if os(iOS)
        .background(Color(uiColor: .systemGroupedBackground))
#else
        .background(.quaternary.opacity(0.5))
#endif
        .background()
        .navigationTitle("Summary")
        
    }
    // MARK: - Cards
    
//    var summaryCard: some View {
//        SummaryCardView(fetchedDelays: projDelaysResponse, fetchedTimes: taxiResponse, fetchedMiles: trackMilesResponse, fetchedEnrWX: enrWXResponse, fetchedLevels: flightLevelResponse)
//    }
    
}

struct SummaryView_Previews: PreviewProvider {
    struct Preview: View {
        var body: some View {
            SummaryView()
        }
    }
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}

