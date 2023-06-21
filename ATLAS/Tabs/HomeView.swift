//
//  HomeView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var viewInformationModel = ListFlightInformationModel()
    @EnvironmentObject var modelState: TabModelState
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geo in
                // Menu Top
                VStack(alignment: .leading, spacing: 0) {
                    // Tabs
                    TabbarScrollable(tabbarItems: modelState.tabs, selectedTab: $modelState.selectedTab).previewDisplayName("TabBarView")
                    
                    switch modelState.selectedTab.screenName {
                        case NavigationEnumeration.OverviewScreen:
                            OverviewView()
                                .tag(NavigationEnumeration.OverviewScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.FlightPlanScreen:
                            FlightPlanView()
                                .tag(NavigationEnumeration.FlightPlanScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.FlightScreen:
                            FlightNoteView()
                                .tag(NavigationEnumeration.FlightScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.theme.cultured)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                            
                        case NavigationEnumeration.FuelScreen:
                            FuelView()
                                .tag(NavigationEnumeration.FuelScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.ChartScreen:
                            ChartView()
                                .tag(NavigationEnumeration.ChartScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.WeatherScreen:
                            WeatherView()
                                .tag(NavigationEnumeration.WeatherScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.AtlasSearchScreen:
                            AtlasSearchView()
                                .tag(NavigationEnumeration.AtlasSearchScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.ReportingScreen:
                            ReportingView()
                                .tag(NavigationEnumeration.ReportingScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        default:
                            OverviewView()
                                .tag(NavigationEnumeration.OverviewScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        }
                            
                }
                .background(Color.theme.sonicSilver.opacity(0.12))
                .hasToolbar()
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SideMenuModelState())
            .environmentObject(TabModelState())
    }
}
