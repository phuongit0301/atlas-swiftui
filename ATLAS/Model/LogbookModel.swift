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
    var sign_file_name: String
    var sign_file_url: String
    var licence_number: String
}

struct ILogbookLimitationData: Decodable {
    var id: String
    var limitation_type: String
    var limitation_requirement: String
    var limitation_limit: String
    var limitation_start: String
    var limitation_end: String
    var limitation_status: String
    var limitation_colour: String
    var limitation_text: String
    var limitation_period_text: String
    var limitation_status_text: String
}

struct ILogbookExperienceData: Decodable {
    var model: String
    var p1: String
    var p2: String
    var pic: String
    var picUs: String
    var totalTime: String
}

struct ILogbookJson: Decodable {
    var logbook_data: [ILogbookEntriesData]
    var experience: [ILogbookExperienceData]
}

struct ILimitationJson: Decodable {
    var limitation_data: [ILogbookLimitationData]
}

struct IRecencyData: Decodable {
    var id: String
    var recency_type: String
    var recency_requirement: String
    var recency_limit: String
    var recency_text: String
}

struct IVisaData: Decodable {
    var id: String
    var visa: String
    var expiry: String
}

struct IExpiryData: Decodable {
    var id: String
    var medical: String
    var sep: String
    var base_check: String
    var line_check: String
    var instructor_rating: String
    var examiner_rating: String
    var passport: String
}


struct IRecencyJson: Decodable {
    var recency_data: [IRecencyData]
    var expiry_data: [String: String]
}

struct LogbookEntryTotal {
    let aircraftType: String
    let pic: String
    let picUs: String
    let p1: String
    let p2: String
    let instr: String
    let exam: String
    let date: Date
}

struct ILobookTotalTimeData: Decodable {
    var aircraftType: String
    var pic: Int
    var picUUs: Int
    var p1: Int
    var p2: Int
    var instr: Int
    var exam: Int
    var date: Date
    var totalTime: Int
}

struct ILobookTotalTimeDataResponse: Decodable {
    var aircraftType: String
    var pic: String
    var picUUs: String
    var p1: String
    var p2: String
    var instr: String
    var exam: String
    var totalTime: String
}

class LogbookDropDown: ObservableObject {
    @Published var dataDayNight: [String] = ["Day and Night", "Day", "Night"]
}
