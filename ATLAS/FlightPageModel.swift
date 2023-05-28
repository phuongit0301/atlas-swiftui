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
    var description: String?
    var subMenuItems: [ListFlightSplitItem]
}



struct ListFlightSplitModel {
    let ListItem = {
        let subMenu = [
            ListFlightSplitItem(name: "Flight Plan", subMenuItems: []),
            ListFlightSplitItem(name: "Aircraft Status", subMenuItems: []),
            ListFlightSplitItem(name: "Departure", subMenuItems: []),
            ListFlightSplitItem(name: "Enroute", subMenuItems: []),
            ListFlightSplitItem(name: "Arrival", subMenuItems: []),
            ListFlightSplitItem(name: "Atlas Search Notes", subMenuItems: []),
            ListFlightSplitItem(name: "Reporting", subMenuItems: []),
        ];
        
        let subMenu1 = [
            ListFlightSplitItem(name: "China RVSM (Westbound)", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", subMenuItems: []),
            ListFlightSplitItem(name: "China RVSM (Eastbound)", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat 12.", subMenuItems: []),
            ListFlightSplitItem(name: "China RVSM (Eastbound) 1", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat 12.", subMenuItems: []),
        ];
        
        let MainItem = [
            ListFlightSplitItem(name: "Notes", subMenuItems: subMenu),
            ListFlightSplitItem(name: "Tables", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", subMenuItems: subMenu1),
        ]
        
        return MainItem
    }()
}
