//
//  FlightView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct FlightView: View {
    @State private var currentTab: ITabs
    @State private var selectedTab: Int = 1
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
                    TabbarScrollable(tabbarItems: [ "Flight Notes", "Fuel", "Atlas Search", "Flight Plan", "Charts", "Weather" ], selectedIndex: $selectedTab).previewDisplayName("TabBarView")
                    
                    Rectangle().fill(Color.theme.cultured).frame(height: 8)
                    Rectangle().fill(Color.theme.eerieBlack).frame(height: 1)
                    Rectangle().fill(Color.theme.cultured).frame(height: 8)
                    
                    TabView(selection: $selectedTab,
                            content: {
                        //                    OverviewView()
                        //                        .tag(0)
                        //                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        //                        .toolbar(.hidden, for: .tabBar)
                        //                        .ignoresSafeArea()
                        FlightNoteView(geoWidth: geo.size.width)
                            .tag(0)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.theme.cultured)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FuelView()
                            .tag(1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        AtlasSearchView()
                            .tag(2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FlightPlanView()
                            .tag(3)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        ChartView()
                            .tag(4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        WeatherView()
                            .tag(5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        //                    ReportingView()
                        //                        .tag(7)
                        //                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        //                        .toolbar(.hidden, for: .tabBar)
                        //                        .ignoresSafeArea()
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
