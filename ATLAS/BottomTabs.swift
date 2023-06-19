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
        VStack(spacing: 0) {
            GeometryReader {proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.tabs, id: \.self) { item in
                            if item.isExternal {
                                VStack(alignment: .center) {
                                    Image(systemName: item.iconName)
                                        .resizable()
                                        .foregroundColor(Color.theme.azure)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 22, height: 26)
                                    Text(item.name).foregroundColor(Color.theme.azure).font(.custom("Inter-SemiBold", size: 10))
                                }
                                .frame(width: proxy.size.width / 4)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        if let url = URL(string: item.scheme) {
                                            if UIApplication.shared.canOpenURL(url) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }.padding()
                    }
                }
            }
        }.frame(height: 80)
    }
    
    func getDestinationSplit(item: ITabs) -> AnyView {
        if item.screenName == NavigationEnumeration.FlightPlanScreen {
            return AnyView(FlightPlanSplit())
        }
        
        if item.screenName == NavigationEnumeration.AirCraftScreen {
            return AnyView(AircraftSplit())
        }
        
        if item.screenName == NavigationEnumeration.FuelScreen {
            return AnyView(FuelViewSplit())
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
