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
    case FlightInformationDetailScreen
    case NotamDetailScreen
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
    case ScratchPadScreen
}

enum NavigationEnumerationToString: CustomStringConvertible {
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
    case TableScreen
    case FuelScreen
    case ChartScreen
    case WeatherScreen
    case ReportingScreen
    
    var description: String {
        switch self {
            case .HomeScreen:
                return "Home"
            case .FlightScreen:
                return "Flight Note"
            case .OverviewScreen:
                return "Reference"
            case .NoteScreen:
                return "Note"
            case .FlightPlanScreen:
                return "Flight Plan"
            case .AirCraftScreen:
                return "Aircraft Status"
            case .DepartureScreen:
                return "Departure"
            case .EnrouteScreen:
                return "Enroute"
            case .ArrivalScreen:
                return "Arrival"
            case .AtlasSearchScreen:
                return "AI Search"
            case .TableScreen:
                return "Utilities"
            case .FuelScreen:
                return "Fuel"
            case .ChartScreen:
                return "Chart"
            case .WeatherScreen:
                return "Weather"
            case .ReportingScreen:
                return "Reporting"
        }
    }
}

struct ITabs: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var iconName: String
    var isExternal: Bool = false
    var isShowTabbar: Bool = false // for Overview, it won't display on Tabbar
    var screenName: NavigationEnumeration
    var isDefault = false
    var scheme: String = ""
}

class TabModelState: ObservableObject {
    let Data = [
        ITabs(name: "Reference", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.OverviewScreen, isDefault: false),
        ITabs(name: "Flight Plan", iconName: "doc.plaintext", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightPlanScreen,  isDefault: false),
        ITabs(name: "Flight Notes", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightScreen, isDefault: true),
        ITabs(name: "Fuel", iconName: "fuelpump", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FuelScreen, isDefault: false),
        ITabs(name: "Charts", iconName: "map", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.ChartScreen, isDefault: false, scheme: "jdmpro.jeppesen://"),
        ITabs(name: "Weather", iconName: "sun.max", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.WeatherScreen, isDefault: false, scheme: "ewas://"),
        ITabs(name: "eDocuments", iconName: "doc.viewfinder", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.ChartScreen, isDefault: false, scheme: "com.adobe.Adobe-Reader://"),
        ITabs(name: "AI Search", iconName: "globe", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.AtlasSearchScreen, isDefault: false),
        ITabs(name: "Reporting", iconName: "rectangle.stack", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.ReportingScreen, isDefault: false),
    ]
    
    @Published var selectedNav: NavigationEnumeration
    @Published var tabs: [ITabs]
    @Published var selectedTab: ITabs
    
    init() {
        self.selectedNav = NavigationEnumeration.FlightScreen
        self.tabs = Data
        self.selectedTab = Data[0]
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
