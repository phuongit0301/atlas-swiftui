//
//  FlightView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightView: View {
    @State private var selectedTab: Int = 0

    @State private var tabs: [Tab] = [
        .init(title: "Overview"),
        .init(title: "Flight Notes"),
        .init(title: "Fuel"),
        .init(title: "Flight Plan"),
        .init(icon: Image("icon_external"), title: "Charts"),
        .init(icon: Image("icon_external"), title: "Weather"),
        .init(title: "Atlas Search"),
        .init(title: "Reporting"),
    ]
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                // Tabs
                TabbarScrollable(tabbarItems: [ "Overview", "Flight Notes", "Fuel", "Flight Plan", "Charts", "Weather", "Atlas Search", "Reporting" ], selectedIndex: $selectedTab).previewDisplayName("TabBarView")
                
                Rectangle().fill(Color.theme.cultured).frame(height: 8)
                Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                Rectangle().fill(Color.theme.cultured).frame(height: 8)

                TabView(selection: $selectedTab,
                        content: {
                    OverviewView()
                        .tag(0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    FlightNoteView(geoWidth: geo.size.width)
                        .tag(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.theme.cultured)
                        .ignoresSafeArea()
                    FuelView()
                        .tag(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    FlightPlanView()
                        .tag(3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    ChartView()
                        .tag(4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    WeatherView()
                        .tag(5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    AtlasSearchView()
                        .tag(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    ReportingView()
                        .tag(7)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                }).id("Parent-TabView")
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(Color.theme.cultured)
            .padding(16)
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea()
        }
    }
}
