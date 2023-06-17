//
//  FlightPageHeaderModel.swift
//  ATLAS
//
//  Created by phuong phan on 19/05/2023.
//

import Foundation
import SwiftUI

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
            ListFlightInformationItem(name: "Flight Plan", date: "XX:XX (UTC+8)"),
            ListFlightInformationItem(name: "Aircraft Status", date: "XX:XX (UTC+8)"),
            ListFlightInformationItem(name: "Fuel", date: "XX:XX"),
            ListFlightInformationItem(name: "Departure", date: "XX:XX"),
            ListFlightInformationItem(name: "Enroute", date: "00:XX"),
            ListFlightInformationItem(name: "Arrival", date: "XX:XX"),
            ListFlightInformationItem(name: "AI Search", date: "XXX"),
            ListFlightInformationItem(name: "Scratchpad", date: "XXX"),
        ]
        
        return MainItem
    }()
}

struct ListFlightUtilitiesModel {
    let ListItem = {
        let MainItem = [
            ListFlightInformationItem(name: "China RVSM (Westbound)", date: "XX:XX (UTC+8)"),
            ListFlightInformationItem(name: "China RVSM (Eastbound)", date: "XX:XX (UTC+8)"),
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

struct ITagStorage: Identifiable, Encodable, Decodable {
    var id = UUID()
    var name: String
    var isChecked = false
}

struct IFlightInfoStorageModel: Identifiable, Encodable, Decodable {
    var id = UUID()
    var name: String
    var tags: [ITagStorage]
    var isDefault: Bool = true
    var canDelete: Bool = true
}

struct DepartureTags {
    let TagList = {
        let MainItem = [
            ITagStorage(name: "Preflight"),
            ITagStorage(name: "Departure"),
            ITagStorage(name: "Dispatch"),
        ]
        
        return MainItem
    }()
}

struct EnrouteTags {
    let TagList = {
        let MainItem = [
            ITagStorage(name: "Enroute"),
            ITagStorage(name: "Terrain"),
        ]
        
        return MainItem
    }()
}

struct ArrivalTags {
    let TagList = {
        let MainItem = [
            ITagStorage(name: "Threats"),
            ITagStorage(name: "Weather"),
            ITagStorage(name: "Arrival"),
            ITagStorage(name: "Approach"),
            ITagStorage(name: "Landing"),
            ITagStorage(name: "Ground"),
        ]
        
        return MainItem
    }()
}

struct CommonTags {
    let TagList = {
        let MainItem = [
            ITagStorage(name: "Dispatch"),
            ITagStorage(name: "Terrain"),
            ITagStorage(name: "Weather"),
            ITagStorage(name: "Approach"),
            ITagStorage(name: "Airport"),
            ITagStorage(name: "ATC"),
            ITagStorage(name: "Aircraft"),
            ITagStorage(name: "Environment"),
        ]
        
        return MainItem
    }()
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
            ListFlightSplitItem(name: "Flight Plan", screen: NavigationEnumeration.FlightScreen, subMenuItems: []),
            ListFlightSplitItem(name: "Aircraft Status", screen: NavigationEnumeration.AirCraftScreen, subMenuItems: []),
            ListFlightSplitItem(name: "Departure", screen: NavigationEnumeration.DepartureScreen, subMenuItems: []),
            ListFlightSplitItem(name: "Enroute", screen: NavigationEnumeration.EnrouteScreen, subMenuItems: []),
            ListFlightSplitItem(name: "Arrival", screen: NavigationEnumeration.ArrivalScreen, subMenuItems: []),
            ListFlightSplitItem(name: "Atlas Search Notes", screen: NavigationEnumeration.AtlasSearchScreen, subMenuItems: []),
//            ListFlightSplitItem(name: "Reporting", screen: NavigationEnumeration.airCraftDetail, subMenuItems: []),
        ];
        
        let subMenu1 = [
            ListFlightSplitItem(name: "China RVSM (Westbound)", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", subMenuItems: [], idReference: "1"),
            ListFlightSplitItem(name: "China RVSM (Eastbound)", description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat 12.", subMenuItems: [], idReference: "2"),
        ];
        
        let MainItem = [
            ListFlightSplitItem(name: "Notes", screen: NavigationEnumeration.NoteScreen, subMenuItems: subMenu),
            ListFlightSplitItem(name: "Tables", screen: NavigationEnumeration.TableScreen, description: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", subMenuItems: subMenu1),
        ]
        
        return MainItem
    }()
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


// New Structure

class FlightNoteModelState: ObservableObject {
    
    // Aircraft, Aircraft QR
    @AppStorage("aircraftDataArray") private var aircraftDataStorage: Data = Data()
        
    @Published var aircraftDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayAircraft()
        }
    }
    
    @AppStorage("aircraftQRDataArray") private var aircraftQRDataStorage: Data = Data()
        
    @Published var aircraftQRDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayAircraftQR()
        }
    }
    
    // END Aircraft, Aircraft QR
    
    // Departure, Departure QR
    @AppStorage("departureDataArray") private var departureDataStorage: Data = Data()
        
    @Published var departureDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayDeparture()
        }
    }
    
    @AppStorage("departureQRDataArray") private var departureQRDataStorage: Data = Data()
        
    @Published var departureQRDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayDepartureQR()
        }
    }
    
    // END Departure, Departure QR
    
    // Enroute, Enroute QR
    @AppStorage("enrouteDataArray") private var enrouteDataStorage: Data = Data()
        
    @Published var enrouteDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayEnroute()
        }
    }
    
    @AppStorage("enrouteQRDataArray") private var enrouteQRDataStorage: Data = Data()
        
    @Published var enrouteQRDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayEnrouteQR()
        }
    }
    
    // END Enroute, Enroute QR
    
    // Arrival, Arrival QR
    @AppStorage("arrivalDataArray") private var arrivalDataStorage: Data = Data()
        
    @Published var arrivalDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayArrival()
        }
    }
    
    @AppStorage("arrivalQRDataArray") private var arrivalQRDataStorage: Data = Data()
        
    @Published var arrivalQRDataArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrayArrivalQR()
        }
    }
    
    // END Arrival, Arrival QR
    
    init() {
        loadArrayAircraft()
        loadArrayAircraftQR()
        loadArrayDeparture()
        loadArrayDepartureQR()
        loadArrayEnroute()
        loadArrayEnrouteQR()
        loadArrayArrival()
        loadArrayArrivalQR()
    }
    
    func addAircraftQR(item: IFlightInfoStorageModel) {
        let exists = self.aircraftQRDataArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.aircraftQRDataArray.append(item)
        }
    }
    
    func updateAircraft(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.aircraftDataArray.firstIndex(where: {$0.id == item.id}) {
            self.aircraftDataArray[matchingIndex].isDefault = false
        }
    }

    func addDepartureQR(item: IFlightInfoStorageModel) {
        let exists = self.departureQRDataArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.departureQRDataArray.append(item)
        }
    }
    
    func updateDeparture(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.departureDataArray.firstIndex(where: {$0.id == item.id}) {
            self.departureDataArray[matchingIndex].isDefault = false
        }
    }

    func addEnrouteQR(item: IFlightInfoStorageModel) {
        let exists = self.enrouteQRDataArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.enrouteQRDataArray.append(item)
        }
    }
    
    func updateEnroute(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.enrouteDataArray.firstIndex(where: {$0.id == item.id}) {
            self.enrouteDataArray[matchingIndex].isDefault = false
        }
    }

    func addArrivalQR(item: IFlightInfoStorageModel) {
        let exists = self.arrivalQRDataArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.arrivalQRDataArray.append(item)
        }
    }
    
    func updateArrival(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.arrivalDataArray.firstIndex(where: {$0.id == item.id}) {
            self.arrivalDataArray[matchingIndex].isDefault = false
        }
    }
    
    func removeItemAircraft(item: IFlightInfoStorageModel) {
        self.aircraftDataArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeItemAircraftQR(item: IFlightInfoStorageModel) {
        self.aircraftQRDataArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeItemDeparture(item: IFlightInfoStorageModel) {
        self.departureDataArray.removeAll(where: {$0.id == item.id })
//        objectWillChange.send()
    }

    func removeItemDepartureQR(item: IFlightInfoStorageModel) {
        self.departureQRDataArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeItemEnroute(item: IFlightInfoStorageModel) {
        self.enrouteDataArray.removeAll(where: {$0.id == item.id })
    }

    func removeItemEnrouteQR(item: IFlightInfoStorageModel) {
        self.enrouteQRDataArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeItemArrival(item: IFlightInfoStorageModel) {
        self.arrivalDataArray.removeAll(where: {$0.id == item.id })
    }

    func removeItemArrivalQR(item: IFlightInfoStorageModel) {
        self.arrivalQRDataArray.removeAll(where: {$0.id == item.id })
    }
    
    // Aircraft, Aircraft QR
    
    private func loadArrayAircraft() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: aircraftDataStorage)
        else {
            aircraftDataArray = []
            return
        }
        
        aircraftDataArray = decodedArray
    }
    
    private func saveArrayAircraft() {
        guard let encodedArray = try? JSONEncoder().encode(aircraftDataArray) else {
            return
        }
        aircraftDataStorage = encodedArray
    }
    
    private func loadArrayAircraftQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: aircraftQRDataStorage)
        else {
            aircraftQRDataArray = []
            return
        }
        
        aircraftQRDataArray = decodedArray
    }
    
    private func saveArrayAircraftQR() {
        guard let encodedArray = try? JSONEncoder().encode(aircraftQRDataArray) else {
            return
        }
        aircraftQRDataStorage = encodedArray
    }
    
    // End Aircraft, Aircraft QR
    
    // Departure, Departure QR
    
    private func loadArrayDeparture() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: departureDataStorage)
        else {
            departureDataArray = [
                IFlightInfoStorageModel(name: "All crew to be simulator-qualified for RNP approach", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false),
                IFlightInfoStorageModel(name: "Note digital clearance requirements 10mins before pushback", tags: [ITagStorage(name: "Airport")], isDefault: false, canDelete: false),
                IFlightInfoStorageModel(name: "Reduce ZFW by 1 ton for preliminary fuel", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false),
                IFlightInfoStorageModel(name: "Expected POB: 315", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false),
                IFlightInfoStorageModel(name: "Hills to the north of aerodrome", tags: [ITagStorage(name: "Terrain")], isDefault: false, canDelete: false)
            ]
            return
        }
        
        departureDataArray = decodedArray
    }
    
    private func saveArrayDeparture() {
        guard let encodedArray = try? JSONEncoder().encode(departureDataArray) else {
            return
        }
        departureDataStorage = encodedArray
    }
    
    private func loadArrayDepartureQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: departureQRDataStorage)
        else {
            departureQRDataArray = []
            return
        }
        
        departureQRDataArray = decodedArray
    }
    
    private func saveArrayDepartureQR() {
        guard let encodedArray = try? JSONEncoder().encode(departureQRDataArray) else {
            return
        }
        departureQRDataStorage = encodedArray
    }
    
    // End Departure, Departure QR
    
    // Enroute, EnrouteQR
    private func loadArrayEnroute() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: enrouteDataStorage)
        else {
            enrouteDataArray = [
                IFlightInfoStorageModel(name: "Non-standard levels when large scale weather deviation in progress", tags: [ITagStorage(name: "ATC")], isDefault: false, canDelete: false),
            ]
            return
        }
        
        enrouteDataArray = decodedArray
    }
    
    private func saveArrayEnroute() {
        guard let encodedArray = try? JSONEncoder().encode(enrouteDataArray) else {
            return
        }
        enrouteDataStorage = encodedArray
    }
    
    private func loadArrayEnrouteQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: enrouteQRDataStorage)
        else {
            enrouteQRDataArray = []
            return
        }
        
        enrouteQRDataArray = decodedArray
    }
    
    private func saveArrayEnrouteQR() {
        guard let encodedArray = try? JSONEncoder().encode(enrouteQRDataArray) else {
            return
        }
        enrouteQRDataStorage = encodedArray
    }
    
    // END Enroute, EnrouteQR
    
    // Arrival, ArrivalQR
    private func loadArrayArrival() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: arrivalDataStorage)
        else {
            arrivalDataArray = [
                IFlightInfoStorageModel(name: "Birds in vicinity", tags: [ITagStorage(name: "Environment")], isDefault: false, canDelete: false),
                IFlightInfoStorageModel(name: "Any +TS expected to last 15mins", tags: [ITagStorage(name: "Weather")], isDefault: false, canDelete: false)
            ]
            return
        }
        
        arrivalDataArray = decodedArray
    }
    
    private func saveArrayArrival() {
        guard let encodedArray = try? JSONEncoder().encode(arrivalDataArray) else {
            return
        }
        arrivalDataStorage = encodedArray
    }
    
    private func loadArrayArrivalQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: arrivalQRDataStorage)
        else {
            arrivalQRDataArray = []
            return
        }
        
        arrivalQRDataArray = decodedArray
    }
    
    private func saveArrayArrivalQR() {
        guard let encodedArray = try? JSONEncoder().encode(arrivalQRDataArray) else {
            return
        }
        arrivalQRDataStorage = encodedArray
    }
    
    // END Arrival, ArrivalQR
}
