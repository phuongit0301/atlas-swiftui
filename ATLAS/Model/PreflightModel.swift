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

struct INoteCommentResponse: Decodable {
    var comment_id: String
    var post_id: String
    var user_id: String
    var comment_date: String
    var comment_text: String
    var username: String
}

struct INotePostResponse: Decodable {
    var post_id: String
    var user_id: String
    var post_date: String
    var post_title: String
    var post_text: String
    var upvote_count: String
    var comment_count: String
    var category: String
    var comments: [INoteCommentResponse]
    var username: String
    var favourite: Bool
    var blue: Bool
}

struct INoteResponse: Decodable {
    var name: String
    var lat: String
    var long: String
    var post_count: Int
    var posts: [INotePostResponse]
}

struct INotePostJson: Decodable {
    var departure: [INoteResponse]
    var arrival: [INoteResponse]
    var preflight: [INoteResponse]
    var enroute: [INoteResponse]
}
