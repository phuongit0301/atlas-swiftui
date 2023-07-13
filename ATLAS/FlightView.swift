//
//  FlightView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightView: View {
    @State var selectedTab: ITabs
    @EnvironmentObject var sideMenuState: SideMenuModelState
    @EnvironmentObject var modelState: TabModelState
    
    // Custom Back button
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(sideMenuState.selectedMenu?.name ?? "").foregroundColor(Color.theme.eerieBlack).padding(.trailing, 10).font(.custom("Inter-SemiBold", size: 34))
                VStack {
                    Text(sideMenuState.selectedMenu?.flight ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 15))
                    Text(sideMenuState.selectedMenu?.date ?? "").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 15))
                }
                Spacer()
            }.padding(16)
            
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0) {
                    // Tabs
                    TabbarScrollable(tabbarItems: modelState.tabs, selectedTab: $modelState.selectedTab).previewDisplayName("TabBarView")
                    
                    Rectangle().fill(Color.theme.cultured).frame(height: 8)
                    Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                    Rectangle().fill(Color.theme.cultured).frame(height: 8)
                    
                    TabView(selection: $modelState.selectedTab.screenName,
                            content: {
                        OverviewView()
                            .tag(NavigationEnumeration.OverviewScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FlightNoteView()
                            .tag(NavigationEnumeration.FlightScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.theme.cultured)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FuelView()
                            .tag(NavigationEnumeration.FuelScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        AISearchView()
                            .tag(NavigationEnumeration.AtlasSearchScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FlightPlanView()
                            .tag(NavigationEnumeration.FlightPlanScreen)
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
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                    }).id("Parent-TabView")
                    //                    .navigationBarHidden(true)
                    //                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                .background(Color.theme.cultured)
                .padding(16)
                .navigationBarBackButtonHidden(true)
                .ignoresSafeArea()
            }
        }.background(Color.theme.cultured)
            .onAppear {
                modelState.selectedTab = selectedTab
            }
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
            }
    }
}

struct FlightView_Previews: PreviewProvider {
    static var previews: some View {
        FlightView(selectedTab: TabModelState().selectedTab)
            .environmentObject(SideMenuModelState())
            .environmentObject(TabModelState())
            .environmentObject(FlightNoteModelState())
    }
}
