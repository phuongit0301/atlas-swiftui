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
}
    
struct IFlightInfoModel: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var tags: [ITag]
    var isDefault: Bool
}

struct DepartureFlightInfoModel {
    var ListItem = {
        var MainItem = [
            IFlightInfoModel(name: "All crew to be simulator-qualified for RNP approach", tags: [ITag(name: "Preflight")], isDefault: false),
            IFlightInfoModel(name: "Note digital clearance requirements 10mins before pushback", tags: [ITag(name: "Departure")], isDefault: false),
            IFlightInfoModel(name: "Reduce ZFW by 1 ton for preliminary fuel", tags: [ITag(name: "Dispatch")], isDefault: false),
            IFlightInfoModel(name: "Expected POB: 315", tags: [ITag(name: "Dispatch")], isDefault: false),
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
            IFlightInfoModel(name: "Non-standard levels when large scale weather deviation in progress", tags: [ITag(name: "Enroute")], isDefault: false),
            IFlightInfoModel(name: "Hills to the north of aerodrome", tags: [ITag(name: "Terrain")], isDefault: false),
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
            IFlightInfoModel(name: "Birds in vicinity", tags: [ITag(name: "Threats")], isDefault: false),
            IFlightInfoModel(name: "Any +TS expected to last 15mins", tags: [ITag(name: "Weather")], isDefault: false),
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
