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
                    
                    TabView(selection: $modelState.selectedTab.screenName,
                            content: {
                        OverviewView()
                            .tag(NavigationEnumeration.OverviewScreen)
                            .frame(height: geo.size.height)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FlightNoteView()
                            .tag(NavigationEnumeration.FlightScreen)
                            .frame(height: CGFloat(geo.size.height - 65) > 0 ? CGFloat(geo.size.height - 65) : geo.size.height)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.theme.cultured)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FuelView()
                            .tag(NavigationEnumeration.FuelScreen)
                            .frame(height: geo.size.height)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        AtlasSearchView()
                            .tag(NavigationEnumeration.AtlasSearchScreen)
                            .frame(height: geo.size.height)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FlightPlanView()
                            .tag(NavigationEnumeration.FlightPlanScreen)
                            .frame(height: CGFloat(geo.size.height - 65) > 0 ? CGFloat(geo.size.height - 65) : geo.size.height)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        ChartView()
                            .tag(NavigationEnumeration.ChartScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        WeatherView()
                            .tag(NavigationEnumeration.WeatherScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        ReportingView()
                            .tag(NavigationEnumeration.ReportingScreen)
                            .frame(height: geo.size.height)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                    }).id("Parent-TabView")
                        .ignoresSafeArea()
//                        .tabViewStyle(.page(indexDisplayMode: .never))
                    
                }.navigationBarTitleDisplayMode(.inline)
                //        .toolbarBackground(Color.white, for: .navigationBar)
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
