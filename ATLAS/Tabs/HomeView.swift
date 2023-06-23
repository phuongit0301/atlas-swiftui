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
    
    @State private var goHome = UUID()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geo in
                // Menu Top
                VStack(alignment: .leading, spacing: 0) {
                    // Tabs
//                    TabView(selection: $modelState.selectedTab.screenName,
//                            content: {
//                            OverviewView()
//                                .tag(NavigationEnumeration.OverviewScreen)
//                                                        .frame(height: geo.size.height)
//                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                .toolbar(.hidden, for: .tabBar)
//                                .gesture(DragGesture())
//                                .ignoresSafeArea()
//                        FlightNoteView()
//                            .tag(NavigationEnumeration.FlightScreen)
//                            .frame(height: CGFloat(geo.size.height - 65) > 0 ? CGFloat(geo.size.height - 65) : geo.size.height)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color.theme.cultured)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//                        FuelView()
//                            .tag(NavigationEnumeration.FuelScreen)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//                        AtlasSearchView()
//                            .tag(NavigationEnumeration.AtlasSearchScreen)
//                            .frame(height: geo.size.height)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//                        FlightPlanView()
//                            .tag(NavigationEnumeration.FlightPlanScreen)
//                            .frame(height: CGFloat(geo.size.height - 65) > 0 ? CGFloat(geo.size.height - 65) : geo.size.height)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//                        ChartView()
//                            .tag(NavigationEnumeration.ChartScreen)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//
//                        WeatherView()
//                            .tag(NavigationEnumeration.WeatherScreen)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//
//                        ReportingView()
//                            .tag(NavigationEnumeration.ReportingScreen)
//                            .frame(height: geo.size.height)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .toolbar(.hidden, for: .tabBar)
//                            .gesture(DragGesture())
//                            .ignoresSafeArea()
//                    }).id("Parent-TabView")
//                        .ignoresSafeArea()
//                            .tabViewStyle(.page(indexDisplayMode: .never))
//        }.navigationBarTitleDisplayMode(.inline)
//            .background(Color.theme.sonicSilver.opacity(0.12))
//            .hasTabbar()
//            .hasToolbar()

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
                .hasTabbar()
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
