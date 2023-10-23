//
//  HomeFlightSectionView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI

struct HomeFlightSectionView: View {
    var viewInformationModel = ListFlightInformationModel()
    @EnvironmentObject var coreDataModel: CoreDataModelState
    @EnvironmentObject var modelState: TabModelState
    @EnvironmentObject var sideMenuState: SideMenuModelState
    
    @State private var goHome = UUID()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            GeometryReader { geo in
                // Menu Top
                VStack(alignment: .leading, spacing: 0) {
                    // Tabs
                    switch modelState.selectedTab.screenName {
                        case NavigationEnumeration.FlightOverviewSectionView:
                            if coreDataModel.selectedEvent?.flightStatus == FlightStatusEnum.COMPLETED.rawValue {
                                FlightOverviewCompleteSectionView()
                                    .tag(NavigationEnumeration.FlightOverviewSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            } else {
                                FlightOverviewSectionView()
                                    .tag(NavigationEnumeration.FlightOverviewSectionView)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .toolbar(.hidden, for: .tabBar)
                                    .ignoresSafeArea()
                            }
                        case NavigationEnumeration.PreflightSectionView:
                            PreflightSectionView()
                                .tag(NavigationEnumeration.PreflightSectionView)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.DepartureScreen:
                            DepartureSectionView()
                                .tag(NavigationEnumeration.DepartureScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.EnrouteScreen:
                            EnrouteSectionView()
                                .tag(NavigationEnumeration.EnrouteScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()
                        case NavigationEnumeration.ArrivalScreen:
                            ArrivalSectionView()
                                .tag(NavigationEnumeration.ArrivalScreen)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .toolbar(.hidden, for: .tabBar)
                                .ignoresSafeArea()

                        case NavigationEnumeration.AtlasSearchScreen:
                            AISearchContainerView()
                                .tag(NavigationEnumeration.AtlasSearchScreen)
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
//                .background(Color.theme.sonicSilver.opacity(0.12))
                .hasTabbar()
                .hasToolbar()
            }
            
        }
    }
}
