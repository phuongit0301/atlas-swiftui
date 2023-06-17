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
        VStack(spacing: 0) {
            // Menu Top
            GeometryReader { geo in
                VStack(alignment: .leading, spacing: 0) {
                    // Tabs
                    TabbarScrollable(tabbarItems: modelState.tabs, selectedTab: $modelState.selectedTab).previewDisplayName("TabBarView")
                    
                    TabView(selection: $modelState.selectedTab.screenName,
                            content: {
                        OverviewView()
                            .tag(NavigationEnumeration.OverviewScreen)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .toolbar(.hidden, for: .tabBar)
                            .ignoresSafeArea()
                        FlightNoteView(geoWidth: geo.size.width)
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
                        AtlasSearchView()
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
                    // flight informations
                    //            List {
                    //                HStack {
                    //                    Text("Flight Information").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 20))
                    //                    Rectangle().fill(.white).frame(width: 32)
                    //                    Text("Last updated: 28 May 2023, 22:30 (UTC+8)").foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 11))
                    //                    Spacer()
                    //                    Button(action: {
                    //                        print("Three dot clicked!!")
                    //                    }) {
                    //                        Image("icon_ellipsis_circle")
                    //                            .frame(width: 24, height: 24)
                    //                            .scaledToFit()
                    //                            .aspectRatio(contentMode: .fit)
                    //                    }
                    //                }
                    //                ForEach(viewInformationModel.ListItem, id: \.self) { item in
                    //                    Button(action: {
                    //                        print("Clicked 11!")
                    //                    }) {
                    //                        HStack {
                    //                            Text(item.name).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-SemiBold", size: 16))
                    //                            Spacer()
                    //                            Text(item.date).foregroundColor(Color.theme.eerieBlack).font(.custom("Inter-Regular", size: 16))
                    //                        }
                    //                    }
                    //                }
                    //            }
                    //            .scrollContentBackground(.hidden)
                    //            .background(Color.theme.cultured)
                    //            .listStyle(.insetGrouped)
                    //            .navigationBarTitleDisplayMode(.inline)
                }
            }
            
        }
        .toolbarBackground(Color.white, for: .navigationBar)
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
