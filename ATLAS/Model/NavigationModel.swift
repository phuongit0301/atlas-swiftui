//
//  TabModel.swift
//  ATLAS
//
//  Created by phuong phan on 01/06/2023.
//

import Foundation
import SwiftUI

enum NavigationEnumeration {
    case FlightSummaryScreen
    case FlightOverviewSectionView
    case SummarySubSectionView
    case PreflightSectionView
    case HomeScreen
    case FlightScreen
    case OverviewScreen
    case ClipboardScreen
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
    //New Item
    case ClipboardFlightOverviewScreen
    case ClipboardPreflight
    case ClipboardCrewBriefing
    case ClipboardDepature
    case ClipboardEnroute
    case ClipboardArrival
    case ClipboardAISearch
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
    var isDisabled = false // tabbar top disabled or not
    var scheme: String = ""
}

class TabModelState: ObservableObject {
    let Data = [
        ITabs(name: "Flight Overview", iconName: "doc.plaintext", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightOverviewSectionView,  isDefault: false, isDisabled: false),
        ITabs(name: "Preflight", iconName: "doc.plaintext", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.PreflightSectionView,  isDefault: false, isDisabled: false),
//        ITabs(name: "Flight Plan", iconName: "doc.plaintext", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.FlightPlanScreen,  isDefault: false, isDisabled: false),
        ITabs(name: "Depature", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.DepartureScreen, isDefault: true, isDisabled: false),
        ITabs(name: "Enroute", iconName: "fuelpump", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.EnrouteScreen, isDefault: false, isDisabled: false),
        ITabs(name: "Arrival", iconName: "map", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.ArrivalScreen, isDefault: false, isDisabled: false),
//        ITabs(name: "Arrival", iconName: "map", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.ArrivalScreen, isDefault: false, isDisabled: false, scheme: "jdmpro.jeppesen://"),
//        ITabs(name: "Weather", iconName: "sun.max", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.WeatherScreen, isDefault: false, isDisabled: false, scheme: "ewas://"),
//        ITabs(name: "eDocuments", iconName: "doc.viewfinder", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.ChartScreen, isDefault: false, isDisabled: false, scheme: "com.adobe.Adobe-Reader://"),
        ITabs(name: "AI Search", iconName: "globe", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.AtlasSearchScreen, isDefault: false, isDisabled: false),
        ITabs(name: "Utilities", iconName: "rectangle.stack", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.ReportingScreen, isDefault: false, isDisabled: true),
        ITabs(name: "Clipboard", iconName: "list.bullet.clipboard", isExternal: false, isShowTabbar: true, screenName: NavigationEnumeration.ClipboardScreen, isDefault: false, isDisabled: false),
    ]
    
    let DataSlideOver = [
        ITabs(name: "Charts", iconName: "map", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.ChartScreen, isDefault: false, isDisabled: false, scheme: "jdmpro.jeppesen://"),
        ITabs(name: "Weather", iconName: "sun.max", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.WeatherScreen, isDefault: false, isDisabled: false, scheme: "ewas://"),
        ITabs(name: "eDocuments", iconName: "doc.viewfinder", isExternal: true, isShowTabbar: true, screenName: NavigationEnumeration.ChartScreen, isDefault: false, isDisabled: false, scheme: "com.adobe.Adobe-Reader://"),
    ]
    
    @Published var selectedNav: NavigationEnumeration
    @Published var tabs: [ITabs]
    @Published var tabsSlideOver: [ITabs]
    @Published var selectedTab: ITabs
    
    init() {
        self.selectedNav = NavigationEnumeration.FlightScreen
        self.tabs = Data
        self.tabsSlideOver = DataSlideOver
        self.selectedTab = Data[0]
    }
}


enum MainNavigationEnumeration {
    case HomeSectionView
    case CalendarSectionView
    case LogbookSectionView
    case RecencySectionView
    case AABBASectionView
    case ChatSectionView
}

struct IMainTabs: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var screenName: MainNavigationEnumeration
    var isShowTabbar: Bool = true
    var isDisabled = false // tabbar top disabled or not
}

class MainTabModelState: ObservableObject {
    let Data = [
        IMainTabs(id: UUID(), name: "Home", screenName: MainNavigationEnumeration.HomeSectionView, isShowTabbar: true, isDisabled: false),
        IMainTabs(id: UUID(), name: "Calendar", screenName: MainNavigationEnumeration.CalendarSectionView, isShowTabbar: true, isDisabled: false),
        IMainTabs(id: UUID(), name: "Logbook", screenName: MainNavigationEnumeration.LogbookSectionView, isShowTabbar: true, isDisabled: false),
        IMainTabs(id: UUID(), name: "Recency", screenName: MainNavigationEnumeration.RecencySectionView, isShowTabbar: true, isDisabled: false),
        IMainTabs(id: UUID(), name: "AABBA", screenName: MainNavigationEnumeration.AABBASectionView, isShowTabbar: true, isDisabled: false),
        IMainTabs(id: UUID(), name: "Chat", screenName: MainNavigationEnumeration.ChatSectionView, isShowTabbar: true, isDisabled: true),
    ]
    
    @Published var selectedNav: MainNavigationEnumeration
    @Published var tabs: [IMainTabs]
    @Published var selectedTab: IMainTabs
    
    init() {
        self.selectedNav = MainNavigationEnumeration.HomeSectionView
        self.tabs = Data
        self.selectedTab = Data[0]
    }
}
