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
    
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
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
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("icon_arrow_left")
                                .frame(width: 41, height: 72)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            
                        }) {
                            Image("icon_arrow_right")
                                .frame(width: 41, height: 72)
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        HStack(alignment: .center) {
                            Text(sideMenuState.selectedMenu?.name ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 20).font(.custom("Inter-SemiBold", size: 17))
                            
                            Text(sideMenuState.selectedMenu?.flight ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 20).font(.custom("Inter-SemiBold", size: 17))
                            
                            Text(sideMenuState.selectedMenu?.date ?? "").foregroundColor(Color.theme.eerieBlack).padding(.horizontal, 20).font(.custom("Inter-SemiBold", size: 17))
                        }
                    }
                }
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
