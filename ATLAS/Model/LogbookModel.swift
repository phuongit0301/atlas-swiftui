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

struct ILogbookEntriesData: Decodable {
    var log_id: String
    var date: String
    var aircraft_category: String
    var aircraft_type: String
    var aircraft: String
    var departure: String
    var destination: String
    var pic_day: String
    var pic_u_us_day: String
    var p1_day: String
    var p2_day: String
    var pic_night: String
    var pic_u_us_night: String
    var p1_night: String
    var p2_night: String
    var instr: String
    var exam: String
    var comments: String
    var signature: String
}

struct ILogbookLimitationData: Decodable {
    var id: String
    var limitation_type: String
    var limitation: String
    var limitation_days: String
    var limitation_period: String
    var limitation_status: String
}

struct ILogbookJson: Decodable {
    var logbook_data: [ILogbookEntriesData]
    var limitation_data: [ILogbookLimitationData]
}

class LogbookDropDown: ObservableObject {
    @Published var dataDayNight: [String] = ["Day and Night", "Day", "Night"]
}
