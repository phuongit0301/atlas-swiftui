//
//  FlightPageHeaderModel.swift
//  ATLAS
//
//  Created by phuong phan on 19/05/2023.
//

import Foundation

struct ListFlightItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
    var imageWidth: Double
    var imageHeight: Double
    var isExternal: Bool
}

struct ListFlightModel {
    let ListItem = {
        let MainItem = [
            ListFlightItem(name: "Flight Notes", image: "icon_flight_notes", imageWidth: 28, imageHeight: 40, isExternal: false),
            ListFlightItem(name: "Fuel", image: "icon_fuel", imageWidth: 32, imageHeight: 32, isExternal: false),
            ListFlightItem(name: "Flight Plan", image: "icon_flight_plan", imageWidth: 28, imageHeight: 36, isExternal: false),
            ListFlightItem(name: "Charts", image: "icon_chart", imageWidth: 34, imageHeight: 32, isExternal: true),
            ListFlightItem(name: "Weather", image: "icon_weather", imageWidth: 40, imageHeight: 40, isExternal: true),
            ListFlightItem(name: "Atlas Search", image: "icon_atlas_search", imageWidth: 32, imageHeight: 32, isExternal: false),
            ListFlightItem(name: "Reporting", image: "icon_reporting", imageWidth: 32, imageHeight: 32, isExternal: false),
        ]
        
        return MainItem
    }()
}

struct ListFlightInformationItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var date: String
}

struct ListFlightInformationModel {
    let ListItem = {
        let MainItem = [
            ListFlightInformationItem(name: "Scheduled Departure", date: "XX:XX (UTC+8)"),
            ListFlightInformationItem(name: "Scheduled Arrival", date: "XX:XX (UTC+8)"),
            ListFlightInformationItem(name: "Block Time", date: "XX:XX"),
            ListFlightInformationItem(name: "Flight Time", date: "XX:XX"),
            ListFlightInformationItem(name: "Taxi Time", date: "00:XX"),
            ListFlightInformationItem(name: "Buffer", date: "XX:XX"),
            ListFlightInformationItem(name: "POB", date: "XXX"),
            ListFlightInformationItem(name: "Aircraft", date: "XXX"),
            ListFlightInformationItem(name: "Gate", date: "XXX"),
            ListFlightInformationItem(name: "Crew", date: "XXX"),
            ListFlightInformationItem(name: "Password", date: "XXX"),
        ]
        
        return MainItem
    }()
}

struct ListFlightNoteInformationModel {
    let ListItem = {
        let MainItem = [
            ListFlightInformationItem(name: "POB", date: "XXX"),
            ListFlightInformationItem(name: "Aircraft", date: "XXX"),
            ListFlightInformationItem(name: "Crew", date: "XXX"),
            ListFlightInformationItem(name: "Password", date: "XXX"),
        ]
        
        return MainItem
    }()
}

struct ITag: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var isChecked = false
}
    
struct IFlightInfoModel: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var tags: [ITag]
    var isDefault: Bool = true
}

struct DepartureFlightInfoModel {
    var ListItem = {
        var MainItem = [
            IFlightInfoModel(name: "All crew to be simulator-qualified for RNP approach", tags: [ITag(name: "Preflight")], isDefault: true),
            IFlightInfoModel(name: "Note digital clearance requirements 10mins before pushback", tags: [ITag(name: "Departure")], isDefault: true),
            IFlightInfoModel(name: "Reduce ZFW by 1 ton for preliminary fuel", tags: [ITag(name: "Dispatch")], isDefault: true),
            IFlightInfoModel(name: "Expected POB: 315", tags: [ITag(name: "Dispatch")], isDefault: true),
        ]
        
        return MainItem
    }()
}

struct DepartureTags {
    let TagList = {
        let MainItem = [
            ITag(name: "Preflight"),
            ITag(name: "Departure"),
            ITag(name: "Dispatch"),
        ]
        
        return MainItem
    }()
}

struct EnrouteFlightInfoModel {
    let ListItem = {
        let MainItem = [
            IFlightInfoModel(name: "Non-standard levels when large scale weather deviation in progress", tags: [ITag(name: "Enroute")], isDefault: true),
            IFlightInfoModel(name: "Hills to the north of aerodrome", tags: [ITag(name: "Terrain")], isDefault: true),
        ]
        
        return MainItem
    }()
}

struct EnrouteTags {
    let TagList = {
        let MainItem = [
            ITag(name: "Enroute"),
            ITag(name: "Terrain"),
        ]
        
        return MainItem
    }()
}

struct ArrivalFlightInfoModel {
    let ListItem = {
        let MainItem = [
            IFlightInfoModel(name: "Birds in vicinity", tags: [ITag(name: "Threats")], isDefault: true),
            IFlightInfoModel(name: "Any +TS expected to last 15mins", tags: [ITag(name: "Weather")], isDefault: true),
        ]
        
        return MainItem
    }()
}

struct ArrivalTags {
    let TagList = {
        let MainItem = [
            ITag(name: "Threats"),
            ITag(name: "Weather"),
            ITag(name: "Arrival"),
            ITag(name: "Approach"),
            ITag(name: "Landing"),
            ITag(name: "Ground"),
        ]
        
        return MainItem
    }()
}

class DepViewModel: ObservableObject {
    @Published var depTags: [ITag] = []

    init() {
        fetchDepTags()
    }
    
    func fetchDepTags() {
        depTags = DepartureTags().TagList
    }
}

struct ListFlightSplitItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var screen: NavigationEnumeration?
    var description: String?
    var subMenuItems: [ListFlightSplitItem]
    var idReference: String?
}

struct ListFlightSplitModel {
    let ListItem = {
        let subMenu = [
            ListFlightSplitItem(name: "Flight Plan", screen: NavigationEnumeration.fightPlanDetail, subMenuItems: []),
            ListFlightSplitItem(name: "Aircraft Status", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
            ListFlightSplitItem(name: "Departure", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
            ListFlightSplitItem(name: "Enroute", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
            ListFlightSplitItem(name: "Arrival", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
            ListFlightSplitItem(name: "Atlas Search Notes", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
            ListFlightSplitItem(name: "Reporting", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
        ];
        
        let subMenu1 = [
            ListFlightSplitItem(name: "China RVSM (Westbound)", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", subMenuItems: [], idReference: "1"),
            ListFlightSplitItem(name: "China RVSM (Eastbound)", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat 12.", subMenuItems: [], idReference: "2"),
            ListFlightSplitItem(name: "China RVSM (Eastbound) 1", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat 12.", subMenuItems: [], idReference: "2"),
        ];
        
        let MainItem = [
            ListFlightSplitItem(name: "Notes", screen: NavigationEnumeration.noteDetail, subMenuItems: subMenu),
            ListFlightSplitItem(name: "Tables", screen: NavigationEnumeration.tableDetail, description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", subMenuItems: subMenu1),
        ]
        
        return MainItem
    }()
}


enum NavigationEnumeration {
    case noteDetail
    case tableDetail
    case fightPlanDetail
    case airCraftDetail
}

struct ListDataDetail {
    var id: String
    var name: String
    var location: String
    var fromDegree: String
    var toDegree: String
    var cleared: [Int]
    var select: [Int]
}

var CLEARS_MOCK_WEST = [12200, 11600, 11000, 10400, 9800, 9200, 8400, 7800, 7200, 6600, 6000, 5400, 4800, 4200, 3600, 3000, 2400, 1800, 1200, 600]

var SELECT_MOCK_WEST = [40100, 38100, 36100, 34100, 32100, 30100, 27600, 25600, 23600, 21700, 19700, 17700, 15700, 13800, 11800, 9800, 7900, 5900, 3900, 2000]

var CLEARS_MOCK_EAST = [12500, 11900, 11300, 10700, 10100, 9500, 8900, 8100, 7500, 6900, 6300, 5700, 5100, 4500, 3900, 3300, 2700, 2100, 1500, 900]

var SELECT_MOCK_EAST = [41100, 39100, 37100, 35100, 33100, 31100, 29100, 26600, 24600, 22600, 20700, 18700, 16700, 14800, 12800, 10800, 8900, 6900, 4900, 3000]

struct ListDetailModel {
    let ListItem = {        
        let MainItem = [
            ListDataDetail(id: "1", name: "China RVSM (Westbound)", location: "Westbound", fromDegree: "180°", toDegree: "359°", cleared: CLEARS_MOCK_WEST, select: SELECT_MOCK_WEST),
            ListDataDetail(id: "2", name: "China RVSM (Eastbound)", location: "Eastbound", fromDegree: "000°", toDegree: "179°", cleared: CLEARS_MOCK_EAST, select: SELECT_MOCK_EAST),
        ]
        
        return MainItem
    }()
}
