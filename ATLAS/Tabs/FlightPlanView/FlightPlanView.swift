//
//  FlightPlanView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightPlanView: View {
    @State var selectedTab: FlightPlanEnumeration = IFlightPlanTabs.first?.screenName ?? FlightPlanEnumeration.SummaryScreen
    @State var planTab = IFlightPlanTabs
    @StateObject var viewModel = ViewModelSummary()
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    switch selectedTab {
                        case .SummaryScreen:
//                        FlightInformationView()
                            FlightPlanSummaryView().environmentObject(viewModel)
                        case .DepartureScreen:
                            FlightPlanDepView()
                        case .EnrouteScreen:
                            FlightPlanEnrView()
                        case .ArrivalScreen:
                            FlightPlanArrView()
                        case .NOTAMScreen:
                            FlightPlanNOTAMView()
                        case .METARSScreen:
                            FlightPlanMETARTAFView()
                    }
                    
                    FlightPlanSegmented(preselected: $selectedTab, options: planTab, geoWidth: proxy.size.width)
                }.frame(maxHeight: .infinity)
                    
            }
        }
    }
}

struct FlightPlanView_Previews: PreviewProvider {
    static var previews: some View {
         FlightPlanView()
//        //FlightPlanSummaryView()
//        //FlightPlanDepView()
//        FlightPlanEnrView()
//        //FlightPlanArrView()
//        //FlightPlanNOTAMView()
//        //FlightPlanMETARTAFView()
    }
}
