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
            // Menu Top
        VStack(alignment: .leading, spacing: 0) {
            // Tabs
            TabbarScrollable(tabbarItems: modelState.tabs, selectedTab: $modelState.selectedTab).previewDisplayName("TabBarView")
            
            TabView(selection: $modelState.selectedTab.screenName,
                    content: {
                OverviewView()
                    .tag(NavigationEnumeration.OverviewScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                FlightNoteView()
                    .tag(NavigationEnumeration.FlightScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.theme.cultured)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                FuelView()
                    .tag(NavigationEnumeration.FuelScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                AtlasSearchView()
                    .tag(NavigationEnumeration.AtlasSearchScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                FlightPlanView()
                    .tag(NavigationEnumeration.FlightPlanScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                ChartView()
                    .tag(NavigationEnumeration.ChartScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                WeatherView()
                    .tag(NavigationEnumeration.WeatherScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
                ReportingView()
                    .tag(NavigationEnumeration.ReportingScreen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea()
            }).id("Parent-TabView")
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))
            
        }
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SideMenuModelState())
            .environmentObject(TabModelState())
    }
}
