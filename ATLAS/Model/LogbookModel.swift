//
//  LogbookEnumeration.swift
//  ATLAS
//
//  Created by phuong phan on 21/09/2023.
//

import Foundation

enum LogbookEnumeration: CustomStringConvertible {
    case OverviewScreen
    case EntriesScreen
    case LimitationsScreen
    
    var description: String {
        switch self {
            case .OverviewScreen:
                return "Overview"
            case .EntriesScreen:
                return "Entries"
            case .LimitationsScreen:
                return "Limitations"
        }
    }
}

let ILogbookTabs = [
    LogbooksTab(title: LogbookEnumeration.OverviewScreen.description, screenName: LogbookEnumeration.OverviewScreen),
    LogbooksTab(title: LogbookEnumeration.EntriesScreen.description, screenName: LogbookEnumeration.EntriesScreen),
    LogbooksTab(title: LogbookEnumeration.LimitationsScreen.description, screenName: LogbookEnumeration.LimitationsScreen),
]

struct LogbooksTab {
    var title: String
    var screenName: LogbookEnumeration
}

enum AircraftDataDropDown: String, CaseIterable, Identifiable {
    case aircraft1
    case aircraft2
    case aircraft3
    var id: Self { self }
}

enum RecencyDataDropDown: String, CaseIterable, Identifiable {
    case selection1
    case selection2
    case selection3
    var id: Self { self }
}

