//
//  PreflightModel.swift
//  ATLAS
//
//  Created by phuong phan on 26/09/2023.
//

import Foundation

enum PreflightTabEnumeration: CustomStringConvertible {
    case SummaryScreen
    case NotamScreen
    case MetarTafScreen
    case StatisticsScreen
    case Mapcreen
    case NotesScreen
    
    var description: String {
        switch self {
            case .SummaryScreen:
                return "Summary"
            case .NotamScreen:
                return "NOTAMs"
            case .MetarTafScreen:
                return "METAR & TAF"
            case .StatisticsScreen:
                return "Statistics"
            case .Mapcreen:
                return "Map"
            case .NotesScreen:
                return "Notes"
        }
    }
}

struct PreflightTab {
    var title: String
    var screenName: PreflightTabEnumeration
}

let IPreflightTabs = [
    PreflightTab(title: "Summary", screenName: PreflightTabEnumeration.SummaryScreen),
    PreflightTab(title: "NOTAMs", screenName: PreflightTabEnumeration.NotamScreen),
    PreflightTab(title: "METAR & TAF", screenName: PreflightTabEnumeration.MetarTafScreen),
    PreflightTab(title: "Statistics", screenName: PreflightTabEnumeration.StatisticsScreen),
    PreflightTab(title: "Map", screenName: PreflightTabEnumeration.Mapcreen),
    PreflightTab(title: "Notes", screenName: PreflightTabEnumeration.NotesScreen),
]
