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
    var isTextBox: Bool = false
    var screenName: NavigationEnumeration?
    var idReference: String?
    var nextScreen: NavigationEnumeration?
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
            ListFlightInformationItem(name: "POB", date: "XXX", isTextBox: true),
            ListFlightInformationItem(name: "Aircraft", date: "XXX", isTextBox: true),
            ListFlightInformationItem(name: "Gate", date: "XXX"),
            ListFlightInformationItem(name: "Crew", date: "XXX", isTextBox: true),
            ListFlightInformationItem(name: "Password", date: "XXX", isTextBox: true),
            ListFlightInformationItem(name: "Chocks Off", date: "XXX"),
            ListFlightInformationItem(name: "Chocks On", date: "XXX"),
        ]
        
        return MainItem
    }()
}

class ScreenReferenceModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var selectedItem: ListFlightInformationItem?
    @Published var isTable: Bool = false
}

struct ListReferenceModel {
    let ListItem = {
        let MainItem = [
            ListFlightInformationItem(name: "Flight Overview", date: "XX:XX (UTC+8)", screenName: NavigationEnumeration.ClipboardFlightOverviewScreen),
            ListFlightInformationItem(name: "Preflight", date: "XX:XX (UTC+8)", screenName: NavigationEnumeration.ClipboardPreflight),
            ListFlightInformationItem(name: "Crew Briefing", date: "XX:XX (UTC+8)", screenName: NavigationEnumeration.NotamDetailScreen),
//            ListFlightInformationItem(name: "Fuel", date: "XX:XX", screenName: NavigationEnumeration.FuelScreen),
            ListFlightInformationItem(name: "Departure", date: "XX:XX", screenName: NavigationEnumeration.DepartureScreen, nextScreen: NavigationEnumeration.EnrouteScreen),
            ListFlightInformationItem(name: "Enroute", date: "00:XX", screenName: NavigationEnumeration.EnrouteScreen, nextScreen: NavigationEnumeration.ArrivalScreen),
            ListFlightInformationItem(name: "Arrival", date: "XX:XX", screenName: NavigationEnumeration.ArrivalScreen, nextScreen: NavigationEnumeration.DepartureScreen),
            ListFlightInformationItem(name: "AI Search Results", date: "XXX", screenName: NavigationEnumeration.AtlasSearchScreen),
            ListFlightInformationItem(name: "Utilities", date: "XXX", screenName: NavigationEnumeration.ScratchPadScreen),
        ]
        
        return MainItem
    }()
}

struct ListUtilitiesModel {
    let ListItem = {
        let MainItem = [
            ListFlightInformationItem(name: "China RVSM (Westbound)", date: "XX:XX (UTC+8)", screenName: NavigationEnumeration.TableScreen, idReference: "1"),
            ListFlightInformationItem(name: "China RVSM (Eastbound)", date: "XX:XX (UTC+8)", screenName: NavigationEnumeration.TableScreen, idReference: "2"),
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
    var fromParent: Bool = false
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
    @AppStorage("aircraftArray") private var aircraftDataStorage: Data = Data()
        
    @Published var aircraftArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveAircraft()
        }
    }
    
    @AppStorage("aircraftQRArray") private var aircraftQRDataStorage: Data = Data()
        
    @Published var aircraftQRArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveAircraftQR()
        }
    }
    
    // END Aircraft, Aircraft QR
    
    // Departure, Departure QR
    @AppStorage("departureArray") private var departureDataStorage: Data = Data()
        
    @Published var departureArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveDeparture()
        }
    }
    
    @AppStorage("departureQRArray") private var departureQRDataStorage: Data = Data()
        
    @Published var departureQRArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveDepartureQR()
        }
    }
    
    // END Departure, Departure QR
    
    // Enroute, Enroute QR
    @AppStorage("enrouteArray") private var enrouteDataStorage: Data = Data()
        
    @Published var enrouteArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveEnroute()
        }
    }
    
    @AppStorage("enrouteQRArray") private var enrouteQRDataStorage: Data = Data()
        
    @Published var enrouteQRArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveEnrouteQR()
        }
    }
    
    // END Enroute, Enroute QR
    
    // Arrival, Arrival QR
    @AppStorage("arrivalArray") private var arrivalDataStorage: Data = Data()
        
    @Published var arrivalArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrival()
        }
    }
    
    @AppStorage("arrivalQRArray") private var arrivalQRDataStorage: Data = Data()
        
    @Published var arrivalQRArray: [IFlightInfoStorageModel] = [] {
        didSet {
            saveArrivalQR()
        }
    }
    
    // END Arrival, Arrival QR
    
    init() {
        loadAircraft()
        loadAircraftQR()
        loadDeparture()
        loadDepartureQR()
        loadEnroute()
        loadEnrouteQR()
        loadArrival()
        loadArrivalQR()
    }
    
    func addAircraftQR(item: IFlightInfoStorageModel) {
        let exists = self.aircraftQRArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.aircraftQRArray.append(item)
        }
    }
    
    func updateAircraft(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.aircraftArray.firstIndex(where: {$0.id == item.id}) {
            self.aircraftArray[matchingIndex].isDefault = false
        }
    }

    func addDepartureQR(item: IFlightInfoStorageModel) {
        let exists = self.departureQRArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.departureQRArray.append(item)
        }
    }
    
    func updateDeparture(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.departureArray.firstIndex(where: {$0.id == item.id}) {
            self.departureArray[matchingIndex].isDefault = false
        }
    }

    func addEnrouteQR(item: IFlightInfoStorageModel) {
        let exists = self.enrouteQRArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.enrouteQRArray.append(item)
        }
    }
    
    func updateEnroute(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.enrouteArray.firstIndex(where: {$0.id == item.id}) {
            self.enrouteArray[matchingIndex].isDefault = false
        }
    }

    func addArrivalQR(item: IFlightInfoStorageModel) {
        let exists = self.arrivalQRArray.first(where: {$0.id == item.id});
        if exists == nil {
            self.arrivalQRArray.append(item)
        }
    }
    
    func updateArrival(item: IFlightInfoStorageModel) {
        if let matchingIndex = self.arrivalArray.firstIndex(where: {$0.id == item.id}) {
            self.arrivalArray[matchingIndex].isDefault = false
        }
    }
    
    func removeAircraft(item: IFlightInfoStorageModel) {
        self.aircraftArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeAircraftQR(item: IFlightInfoStorageModel) {
        self.aircraftQRArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeDeparture(item: IFlightInfoStorageModel) {
        self.departureArray.removeAll(where: {$0.id == item.id })
//        objectWillChange.send()
    }

    func removeDepartureQR(item: IFlightInfoStorageModel) {
        self.departureQRArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeEnroute(item: IFlightInfoStorageModel) {
        self.enrouteArray.removeAll(where: {$0.id == item.id })
    }

    func removeEnrouteQR(item: IFlightInfoStorageModel) {
        self.enrouteQRArray.removeAll(where: {$0.id == item.id })
    }
    
    func removeArrival(item: IFlightInfoStorageModel) {
        self.arrivalArray.removeAll(where: {$0.id == item.id })
    }

    func removeArrivalQR(item: IFlightInfoStorageModel) {
        self.arrivalQRArray.removeAll(where: {$0.id == item.id })
    }
    
    // Aircraft, Aircraft QR
    
    private func loadAircraft() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: aircraftDataStorage)
        else {
            aircraftArray = []
            return
        }
        
        aircraftArray = decodedArray
    }
    
    private func saveAircraft() {
        guard let encodedArray = try? JSONEncoder().encode(aircraftArray) else {
            return
        }
        aircraftDataStorage = encodedArray
    }
    
    private func loadAircraftQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: aircraftQRDataStorage)
        else {
            aircraftQRArray = []
            return
        }
        
        aircraftQRArray = decodedArray
    }
    
    private func saveAircraftQR() {
        guard let encodedArray = try? JSONEncoder().encode(aircraftQRArray) else {
            return
        }
        aircraftQRDataStorage = encodedArray
    }
    
    // End Aircraft, Aircraft QR
    
    // Departure, Departure QR
    
    private func loadDeparture() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: departureDataStorage)
        else {
            departureArray = [
                IFlightInfoStorageModel(name: "All crew to be simulator-qualified for RNP approach", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false, fromParent: false),
                IFlightInfoStorageModel(name: "Note digital clearance requirements 10mins before pushback", tags: [ITagStorage(name: "Airport")], isDefault: false, canDelete: false, fromParent: false),
                IFlightInfoStorageModel(name: "Reduce ZFW by 1 ton for preliminary fuel", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false, fromParent: false),
                IFlightInfoStorageModel(name: "Expected POB: 315", tags: [ITagStorage(name: "Dispatch")], isDefault: false, canDelete: false, fromParent: false),
                IFlightInfoStorageModel(name: "Hills to the north of aerodrome", tags: [ITagStorage(name: "Terrain")], isDefault: false, canDelete: false, fromParent: false)
            ]
            return
        }
        
        departureArray = decodedArray
    }
    
    private func saveDeparture() {
        guard let encodedArray = try? JSONEncoder().encode(departureArray) else {
            return
        }
        departureDataStorage = encodedArray
    }
    
    private func loadDepartureQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: departureQRDataStorage)
        else {
            departureQRArray = []
            return
        }
        
        departureQRArray = decodedArray
    }
    
    private func saveDepartureQR() {
        guard let encodedArray = try? JSONEncoder().encode(departureQRArray) else {
            return
        }
        departureQRDataStorage = encodedArray
    }
    
    // End Departure, Departure QR
    
    // Enroute, EnrouteQR
    private func loadEnroute() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: enrouteDataStorage)
        else {
            enrouteArray = [
                IFlightInfoStorageModel(name: "Non-standard levels when large scale weather deviation in progress", tags: [ITagStorage(name: "ATC")], isDefault: false, canDelete: false, fromParent: false),
            ]
            return
        }
        
        enrouteArray = decodedArray
    }
    
    private func saveEnroute() {
        guard let encodedArray = try? JSONEncoder().encode(enrouteArray) else {
            return
        }
        enrouteDataStorage = encodedArray
    }
    
    private func loadEnrouteQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: enrouteQRDataStorage)
        else {
            enrouteQRArray = []
            return
        }
        
        enrouteQRArray = decodedArray
    }
    
    private func saveEnrouteQR() {
        guard let encodedArray = try? JSONEncoder().encode(enrouteQRArray) else {
            return
        }
        enrouteQRDataStorage = encodedArray
    }
    
    // END Enroute, EnrouteQR
    
    // Arrival, ArrivalQR
    private func loadArrival() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: arrivalDataStorage)
        else {
            arrivalArray = [
                IFlightInfoStorageModel(name: "Birds in vicinity", tags: [ITagStorage(name: "Environment")], isDefault: false, canDelete: false, fromParent: false),
                IFlightInfoStorageModel(name: "Any +TS expected to last 15mins", tags: [ITagStorage(name: "Weather")], isDefault: false, canDelete: false, fromParent: false)
            ]
            return
        }
        
        arrivalArray = decodedArray
    }
    
    private func saveArrival() {
        guard let encodedArray = try? JSONEncoder().encode(arrivalArray) else {
            return
        }
        arrivalDataStorage = encodedArray
    }
    
    private func loadArrivalQR() {
        guard let decodedArray = try? JSONDecoder().decode([IFlightInfoStorageModel].self, from: arrivalQRDataStorage)
        else {
            arrivalQRArray = []
            return
        }
        
        arrivalQRArray = decodedArray
    }
    
    private func saveArrivalQR() {
        guard let encodedArray = try? JSONEncoder().encode(arrivalQRArray) else {
            return
        }
        arrivalQRDataStorage = encodedArray
    }
    
    // END Arrival, ArrivalQR
}

class NotamSection: ObservableObject {
    @Published var dataDropDown: [String] = ["Runway", "Taxiway", "Approach/Departure", "Navaid", "Obstacles", "Others"]
}
