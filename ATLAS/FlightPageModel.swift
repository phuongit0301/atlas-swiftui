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
