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
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    if selectedTab == 0 {
                        FlightInformationView()
                    } else {
                        ExampleView()
                    }
                    
                    CustomSegmentedControl(preselectedIndex: $selectedTab, options: planTab, geoWidth: proxy.size.width)
                }.frame(maxHeight: .infinity)
                    
            }
        }
    }
}

struct FlightPlanView_Previews: PreviewProvider {
    static var previews: some View {
        FlightPlanView()
    }
}
