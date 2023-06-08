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
    case FlightPlanScreen
    case AirCraftScreen
    case DepartureScreen
    case EnrouteScreen
    case ArrivalScreen
    case AtlasSearchScreen
    case TableScreen // For split screen
    case FuelScreen
    case ChartScreen
    case WeatherScreen
    case ReportingScreen
}

struct ITabs: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var iconName: String
    var isExternal: Bool = false
    var isShowTabbar: Bool = false // for Overview, it won't display on Tabbar
    var screenName: NavigationEnumeration
    var isDefault = false
}

struct DataTabs {
    let Data = {
        return [
            ITabs(name: "Overview", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen, isDefault: false),
            ITabs(name: "Flight Notes", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightScreen, isDefault: true),
            ITabs(name: "Flight Plan", iconName: "doc.plaintext", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightPlanScreen,  isDefault: false),
            ITabs(name: "Fuel", iconName: "fuelpump", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FuelScreen, isDefault: false),
            ITabs(name: "Charts", iconName: "map", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.ChartScreen, isDefault: false),
            ITabs(name: "Weather", iconName: "sun.max", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.WeatherScreen, isDefault: false),
            ITabs(name: "Atlas Search", iconName: "globe", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.AtlasSearchScreen, isDefault: false),
            ITabs(name: "Reporting", iconName: "rectangle.stack", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.ReportingScreen, isDefault: false),
        ]
    }()
}

class TabModelState: ObservableObject {
    @Published var selectedNav: NavigationEnumeration
    @Published var tabs: [ITabs]
    @Published var selectedTab: ITabs
    
    init() {
        self.selectedNav = NavigationEnumeration.FlightScreen
        self.tabs = DataTabs().Data
        self.selectedTab = DataTabs().Data[1]

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
