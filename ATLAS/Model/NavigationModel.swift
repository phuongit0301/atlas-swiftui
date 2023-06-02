//
//  TabModel.swift
//  ATLAS
//
//  Created by phuong phan on 01/06/2023.
//

import Foundation
import SwiftUI

enum NavigationEnumeration {
    case HomeScreen
    case FlightScreen
    case OverviewScreen
    case NoteScreen
    case FightPlanScreen
    case AirCraftScreen
    case DepartureScreen
    case EnrouteScreen
    case ArrivalScreen
    case AtlasSearchScreen
    case TableScreen // For split screen
}

struct ITabs: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var iconName: String
    var isExternal: Bool = false
    var isShowTabbar: Bool = false // for Overview, it won't display on Tabbar
    var screenName: NavigationEnumeration
}

class TabModelState: ObservableObject {
    @Published var selectedNav: NavigationEnumeration
    @Published var tabs: [ITabs]
    @Published var selectedTab: ITabs
    
    init() {
        self.selectedNav = NavigationEnumeration.FlightScreen
        self.tabs = [
            ITabs(name: "Overview", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: false, screenName: NavigationEnumeration.OverviewScreen),
            ITabs(name: "Flight Notes", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightScreen),
            ITabs(name: "Fuel", iconName: "fuelpump", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen),
            ITabs(name: "Flight Plan", iconName: "doc.plaintext", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen),
            ITabs(name: "Charts", iconName: "map", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen),
            ITabs(name: "Weather", iconName: "sun.max", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen),
            ITabs(name: "Atlas Search", iconName: "globe", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen),
            ITabs(name: "Reporting", iconName: "rectangle.stack", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen),
        ]
        
        self.selectedTab = ITabs(name: "Overview", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: false, screenName: NavigationEnumeration.OverviewScreen)
    }
}


enum MainScreen {
    case HomeScreen, FlightScreen
}

class MainNavModelState: ObservableObject {
    @Published var currentScreen: MainScreen
    
    init() {
        self.currentScreen = MainScreen.HomeScreen
    }
}
