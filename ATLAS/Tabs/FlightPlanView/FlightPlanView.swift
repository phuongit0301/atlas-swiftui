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
        VStack(spacing: 0) {
            GeometryReader { proxy in
                VStack {
                    if selectedTab == 0 {
                        FlightInformationView()
                    } else {
                        ExampleView()
                    }
                    Spacer()
                    CustomSegmentedControl(preselectedIndex: $selectedTab, options: planTab, geoWidth: proxy.size.width)
                }
            }
        }
    }
}

struct FlightPlanView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanView()
    }
}
