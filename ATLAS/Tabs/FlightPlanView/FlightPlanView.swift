//
//  FlightPlanView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightPlanView: View {
    
    @State private var selectedTab: Int = 0
    @State private var planTab = IFlightPlanTabs().ListItem
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                TabView(selection: $selectedTab,
                        content: {
                    FlightInformationView()
                        .tag(0)
                        .toolbar(.hidden, for: .tabBar)
                }).id("tabView")
                
                Tabs(tabs: planTab, geoWidth: proxy.size.width, selectedTab: $selectedTab).id("tabViewBottom")
                Spacer()
            }
        }
    }
}

struct FlightPlanView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanView()
    }
}
