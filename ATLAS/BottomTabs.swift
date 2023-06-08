//
//  File.swift
//  ATLAS
//
//  Created by phuong phan on 28/05/2023.
//

import Foundation
import SwiftUI

struct BottomTabs: View {
    private var viewModel = TabModelState()
    @State private var currentScreen = MainScreen.HomeScreen
    @State var selectedItem: BottomMenuItem? = nil
    @Environment(\.sceneSession) private var sceneSession: UISceneSession?
    
    var body: some View {
        // header list icons
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 0) {
                ForEach(viewModel.tabs, id: \.self) { item in
                    if(item.name != "Overview") {
                        if item.isExternal {
                            VStack(spacing: 0) {
                                VStack(alignment: .center) {
                                    Image(systemName: item.iconName)
                                        .frame(width: 16, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                }.frame(width: 32, height: 32, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                            }.onTapGesture {
                                withAnimation(.easeInOut) {
                                    if let url = URL(string: "App-Prefs://root=NOTES") {
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }
                                    
                                    //                                else {
                                    //                                    let userActivity = NSUserActivity(
                                    //                                        activityType: "sg.accumulus.ios.book-flight"
                                    //                                    )
                                    //                                    userActivity.targetContentIdentifier =
                                    //                                    "sg.accumulus.ios.book-flight"
                                    //
                                    //                                    UIApplication.shared.requestSceneSessionActivation(
                                    //                                        nil,
                                    //                                        userActivity: userActivity,
                                    //                                        options: nil,
                                    //                                        errorHandler: nil
                                    //                                    )
                                    //                                }
                                }
                            }
                            
                        } else {
                            NavigationLink(destination: getDestinationSplit(item: item)) {
                                VStack(alignment: .center) {
                                    Image(systemName: item.iconName)
                                        .foregroundColor(Color.theme.eerieBlack)
                                        .frame(width: 16, height: 16)
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fit)
                                }.frame(width: 32, height: 32, alignment: .center).padding().background(Color.theme.aeroBlue).cornerRadius(12)
                            }
                        }
                        
                    }

                }.padding(12)
            }
        }
    }
    
    func getDestinationSplit(item: ITabs) -> AnyView {
        if item.screenName == NavigationEnumeration.FlightPlanScreen {
            return AnyView(FlightPlanSplit())
        }
        
        if item.screenName == NavigationEnumeration.AirCraftScreen {
            return AnyView(AircraftSplit())
        }
        
        if item.screenName == NavigationEnumeration.FuelScreen {
            return AnyView(SummaryCardViewSlideOver())
        }
        
        if item.screenName == NavigationEnumeration.DepartureScreen {
            return AnyView(DepartureSplit())
        }
        
        if item.screenName == NavigationEnumeration.EnrouteScreen {
            return AnyView(EnrouteSplit())
        }
        
        if item.screenName == NavigationEnumeration.ArrivalScreen {
            return AnyView(ArrivalSplit())
        }
        
        if item.screenName == NavigationEnumeration.AtlasSearchScreen {
            return AnyView(AtlasSearchSplit())
        }
        
        if item.screenName == NavigationEnumeration.ReportingScreen {
            return AnyView(ReportingView())
        }
        
        return AnyView(HomeViewSplit())
    }
}
