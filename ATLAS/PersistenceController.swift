//
//  PersistenceController.swift
//  ATLAS
//
//  Created by phuong phan on 21/06/2023.
//

import CoreData
import SwiftUI
import MapKit
import iCalendarParser

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Unable to load sample data: \(error.localizedDescription)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Notes")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        })
    }
}

struct IScratchPad: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var content: String
    var createdAt: Date = Date()
}


//let perfData = PerfData(fltRules: "RVSM", gndMiles: "6385", airMiles: "7004", crzComp: "M42", apd: "1.4", ci: "100", zfwChange: "557", lvlChange: "500", planZFW: "143416", maxZFW: "161025", limZFW: "Structural", planTOW: "227883", maxTOW: "227930", limTOW: "Perf - Obstacle", planLDW: "151726", maxLDW: "172365", limLDW: "Structural")

class CoreDataModelState: ObservableObject {
    var remoteService = RemoteService.shared
    let service = PersistenceController.shared
    
    @Published var loading: Bool = true
    @Published var loadingInit: Bool = false
    @Published var loadingInitFuel: Bool = false
    @Published var tagList: [TagList] = []
    @Published var tagListCabinDefects: [TagList] = []
    @Published var tagListWeather: [TagList] = []
    @Published var noteListIncludeCrew: [NoteList] = []
    @Published var preflightArray: [NoteList] = []
    @Published var departureArray: [NoteList] = []
    @Published var enrouteArray: [NoteList] = []
    @Published var arrivalArray: [NoteList] = []
    @Published var preflightRefArray: [NoteList] = []
    @Published var departureRefArray: [NoteList] = []
    @Published var enrouteRefArray: [NoteList] = []
    @Published var arrivalRefArray: [NoteList] = []
    //    @Published var dataFlightPlan: FlightPlanList?
    //    @Published var dataEvents: [EventList] = []
    
    @Published var dataNoteAabbaPreflight: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaDeparture: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaEnroute: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaArrival: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaPreflightRef: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaDepartureRef: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaEnrouteRef: [NoteAabbaPostList] = []
    @Published var dataNoteAabbaArrivalRef: [NoteAabbaPostList] = []
    
    @Published var dataPostPreflight: [NotePostList] = []
    @Published var dataPostPreflightRef: [NotePostList] = []
    
    @Published var dataPostDeparture: [NotePostList] = []
    @Published var dataPostDepartureRef: [NotePostList] = []
    
    @Published var dataPostEnroute: [NotePostList] = []
    @Published var dataPostEnrouteRef: [NotePostList] = []
    
    @Published var dataPostArrival: [NotePostList] = []
    @Published var dataPostArrivalRef: [NotePostList] = []
    
    @Published var dataFlightPlan: FlightPlanList?
    @Published var dataEvents: [EventList] = []
    
    // For summary info
    @Published var dataSummaryInfo: SummaryInfoList!
    @Published var existDataSummaryInfo: Bool = false
    
    // For summary route
    @Published var dataSummaryRoute: SummaryRouteList!
    @Published var existDataSummaryRoute: Bool = false
    
    // For Perf Info
    @Published var dataPerfInfo: [PerfInfoList] = []
    @Published var existDataPerfInfo: Bool = false
    
//    @Published var perfChangesTable: [perfChanges] = []
    
    // For Perf Data
    @Published var dataPerfData: PerfDataList!
    @Published var existDataPerfData: Bool = false
    
    // For Perf Weight
    @Published var dataPerfWeight: [PerfWeightList] = []
    @Published var existDataPerfWeight: Bool = false
    
    // For Fuel List
    @Published var dataFuelDataList: FuelDataList!
    @Published var existDataFuelDataList: Bool = false
    
    // For Fuel Table List
    @Published var dataFuelTableList: [FuelTableList] = []
    @Published var existDataFuelTableList: Bool = false
    
    // For Fuel Extra
    @Published var dataFuelExtra: FuelExtraList!
    @Published var existDataFuelExtra: Bool = false
    
    // For Altn
    @Published var dataAltnList: [AltnDataList] = []
    
    // For NoTams
    @Published var dataNotams: [NotamsDataList] = []
    @Published var dataNotamsRef: [NotamsDataList] = []
    
    @Published var dataDepartureNotamsRef: [NotamsDataList] = []
    @Published var dataEnrouteNotamsRef: [NotamsDataList] = []
    @Published var dataArrivalNotamsRef: [NotamsDataList] = []
    @Published var dataDestinationNotamsRef: [NotamsDataList] = []
    @Published var existDataNotams: Bool = false
    
    // For Metar Taf
    @Published var dataDepartureMetarTaf: MetarTafDataList?
    @Published var dataEnrouteMetarTaf: MetarTafDataList?
    @Published var dataArrivalMetarTaf: MetarTafDataList?
    @Published var dataDestinationMetarTaf: MetarTafDataList?
    
    @Published var dataMetarTaf: MetarTafDataList!
    @Published var existDataMetarTaf: Bool = false
    
    // For Altn Taf
    @Published var dataAltnTaf: [AltnTafDataList] = []
    @Published var existDataAltnTaf: Bool = false
    
    @Published var existDataAltn: Bool = false
    
    @Published var existDataFlightPlan: Bool = false
    @Published var dataDepartureAtc: DepartureATCList!
    @Published var existDataDepartureAtc: Bool = false
    @Published var dataDepartureAtis: DepartureATISList!
    @Published var existDataDepartureAtis: Bool = false
    @Published var dataDepartureEntries: DepartureEntriesList!
    @Published var existDataDepartureEntries: Bool = false
    
    @Published var dataFPEnroute: [EnrouteList] = []
    @Published var existDataFPEnroute: Bool = false
    
    @Published var dataArrivalAtc: ArrivalATCList!
    @Published var existDataArrivalAtc: Bool = false
    @Published var dataArrivalAtis: ArrivalATISList!
    @Published var existDataArrivalAtis: Bool = false
    @Published var dataArrivalEntries: ArrivalEntriesList!
    @Published var existDataArrivalEntries: Bool = false
    
    @Published var scratchPadArray: [ScratchPadList] = []
    
    // For Fuel Chart
    @Published var dataProjDelays: ProjDelaysList!
    @Published var dataHistoricalDelays: [HistoricalDelaysList] = []
    @Published var dataProjTaxi: [FuelTaxiList] = []
    @Published var dataTrackMiles: [FuelTrackMilesList] = []
    @Published var dataEnrWX: [FuelEnrWXList] = []
    @Published var dataFlightLevel: [FuelFlightLevelList] = []
    @Published var dataReciprocalRwy: FuelReciprocalRwyList!
    
    @Published var isUpdating: Bool = false
    
    @Published var dataAISearch: [AISearchList] = []
    @Published var dataAISearchFavorite: [AISearchList] = []
    
    // For Map View
    @Published var dataWaypointMap: [WaypointMapList] = []
    @Published var dataAirportMap: [AirportMapList] = []
    @Published var dataAirportColorMap: [AirportMapColorList] = []
    @Published var dataTrafficMap: [TrafficMapList] = []
    @Published var dataAabbaMap = [AabbaMapList]()
    
    // For Logbook
    @Published var dataLogbookLimitation = [LogbookLimitationList]()
    @Published var dataLogbookEntries = [LogbookEntriesList]()
    
    // For Recency
    let monthsAhead = 6
    @Published var dataExpiringSoon = [DocumentExpiry]()
    @Published var dataRecency = [RecencyList]()
    @Published var dataRecencyExpiry = [RecencyExpiryList]()
    
    // For Route Alternate
    @Published var dataAlternate = [RouteAlternateList]()
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.988333, longitude: 104.105), span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8))
    @Published var lineCoordinates = [CLLocationCoordinate2D]()
    @Published var pointsOfInterest = [MKAnnotation]()
    @Published var image: UIImage!
    @Published var imageLoading = true
    
    // For Event Calendar
    @Published var dateRange: [ClosedRange<Date>] = []
    @Published var dataEventUpcoming: [EventList] = []
    @Published var dataEventCompleted: [EventList] = []
    
    let dateFormatter = DateFormatter()
    
    init() {
        
    }
    
    @MainActor
    func checkAndSyncData() async {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dataTrafficMap = readDataTrafficMapList()
        
        if dataTrafficMap.count > 0 {
            self.loadingInit = true
            Task {
                async let calendarService = remoteService.getCalendarData()
                
                // For Notam, MetarTaf
    //            async let notamService = remoteService.updateNotamData(payloadNotam)
                
                //array handle call API parallel
                let services = await [calendarService]
//                let response = await remoteService.getFuelData()
//                let responseMap = await remoteService.getMapData()
//                let responseLogbook = await remoteService.getLogbookData()
//                let responseRecency = await remoteService.getRecencyData()
                
                DispatchQueue.main.async {
                    //For calendar
                    if let dataDateRange = services[0]?.COP_date_ranges, dataDateRange.count > 0 {
                        for item in dataDateRange {
                            var dateRange: ClosedRange<Date> {
                                let startDate = self.dateFormatter.date(from: item.startDate) ?? Date()
                                let endDate = self.dateFormatter.date(from: item.endDate) ?? Date()
                                return startDate...endDate
                            }
                            
                            self.dateRange.append(dateRange)
                        }
                        
                    }
                    
                    if let events = services[0]?.events, events.count > 0 {
                        self.initDataEvent(events)
                    }
                    
                    
//                    self.initDataSummaryInfo()
//                    if let waypointsData = data?.waypointsData {
//                        self.initDataEnroute(waypointsData)
//                    }
//
//                    if let infoData = data?.infoData {
//                        self.initDataSummaryInfo(infoData)
//                    }
//
//                    if let routeData = data?.routeData {
//                        self.initDataSummaryRoute(routeData)
////                        self.initDataWaypoint(routeData.waypoints)
//                        let waypointData: IWaypointDataJson = self.remoteService.load("waypoint_data.json")
//                        let airportData: IAirportDataJson = self.remoteService.load("airport_data.json")
//                        let airportDataColor: [IAirportColor] = self.remoteService.load("airport_data_color.json")
//                        let trafficData: [ITrafficData] = self.remoteService.load("traffic_data.json")
//                        let dataAabba: [IAabbaData] = self.remoteService.load("aabba_data.json")
//
//                        self.initDataWaypoint(waypointData)
//                        self.initDataAirport(airportData)
//                        self.initDataAirportColor(airportDataColor)
//                        self.initDataTraffic(trafficData)
//                        self.initDataAabba(dataAabba)
//                    }
                    
//                    if let trafficData = responseMap?.traffic_data {
//                        self.initDataTraffic(trafficData)
//                    }
//
//                    if let aabbaData = responseMap?.aabba_data {
//                        self.initDataAabba(aabbaData)
//                    }
//
                    // Init Logbook
//                    if let logbookEntry = responseLogbook?.logbook_entry {
//                        self.initDataLogbookEntries(logbookEntry)
//                    }
//
//                    if let limitationData = responseLogbook?.limitation_data {
//                        self.initDataLogbookLimitation(limitationData)
//                    }
//
//                    // Init data recency
//
//                    if let recencyData = responseRecency?.recency_data {
//                        self.initDataRecency(recencyData)
//                    }
//
//                    if let expiryData = responseRecency?.expiry_data {
//                        self.initDataRecencyExpiry(expiryData)
//                    }
                    
//                    if let waypointData = responseMap?.all_waypoints_data {
//                        self.initDataWaypoint(waypointData)
//                    }
//
//                    if let airportData = responseMap?.all_airports_data {
//                        self.initDataAirport(airportData)
//                        self.initDataAirportColor(airportData)
//                    }
//
//                    let postData: INotePostJson = self.remoteService.load("aabba_note_data.json")
//
//                    // For Note Relevant
//                    self.initDataNoteAabbaPreflight(postData.preflight)
//                    self.initDataNoteAabbaDepature(postData.departure)
//                    self.initDataNoteAabbaEnroute(postData.enroute)
//                    self.initDataNoteAabbaArrival(postData.arrival)

//                    if let perfData = data?.perfData {
//                        self.initDataPerfData(perfData)
//
////                        self.initDataPerfInfo(perfData)
//
//                        self.dataPerfWeight = self.readPerfWeight()
//
////                        self.initDataPerfWeight(perfData)
//                    }
//
////                    if let fuelData = data?.fuelData {
////                        self.initDataFuelList(fuelData)
////                    }
//
//                    if let altnData = data?.altnData {
//                        self.dataAltnList = self.readAltnList()
//                        self.initDataAltn(altnData)
//                    }
//
//                    if let notamsData = data?.notamsData {
//                        self.initDataNotams(notamsData)
//                    }
//
//                    if let metarTafData = data?.metarTafData {
//                        self.initDataMetarTaf(metarTafData)
//                        self.initDataAltnTaf(metarTafData)
//                    }

                    // For init Calendar
//                    self.initDataEvent()
                    
                    self.loadingInit = false
                    print("Fetch data")
                }
            }
        }
    }
    
    @MainActor
    func checkAndSynDataFuel() async {
        readHistoricalDelays()
        
        Task {
            if self.dataHistoricalDelays.count <= 0  {
                self.loadingInitFuel = true
                
                let response = await self.remoteService.getFuelData()
                
                if let historicalDelays = response?.historicalDelays {
                    self.initHistoricalDelays(historicalDelays)
                }
                
                if let projDelays = response?.projDelays {
                    self.initProjDelays(projDelays)
                }
                
                if let taxi = response?.taxi {
                    self.initProjTaxi(taxi)
                }
                
                if let trackMiles = response?.trackMiles {
                    self.initTrackMiles(trackMiles)
                }
                
                if let enrWX = response?.enrWX {
                    self.initEnrWX(enrWX)
                }
                
                if let flightLevel = response?.flightLevel {
                    self.initFlightLevel(flightLevel)
                }
                
                if let reciprocalRwy = response?.reciprocalRwy {
                    self.initReciprocalRwy(reciprocalRwy)
                }
                
                self.loadingInitFuel = false
            }
        }
    }
    
    func syncDataMetarTaf() async {
        let response = await remoteService.getFlightPlanWX()
        
//        if let metarTafData = response {
//            self.updateDataMetarTaf(metarTafData)
//            self.updateDataAltnTaf(metarTafData)
//        }
    }
    
    @MainActor
    func initFetchData() async {
        DispatchQueue.main.async {
            self.tagList = self.readTag()
            self.tagListCabinDefects = self.readTagByName("Cabin Defects")
            self.tagListWeather = self.readTagByName("Weather")
            self.noteListIncludeCrew = self.readNoteListIncludeCrew()
            self.preflightArray = self.read("preflight")
            self.departureArray = self.read("departure")
            self.enrouteArray = self.read("enroute")
            self.arrivalArray = self.read("arrival")
            self.preflightRefArray = self.read("preflightref")
            self.departureRefArray = self.read("departureref")
            self.enrouteRefArray = self.read("enrouteref")
            self.arrivalRefArray = self.read("arrivalref")
            self.scratchPadArray = self.readScratchPad()
            self.dataFPEnroute = self.readEnrouteList()
            //        readFlightPlan()
            self.readSummaryInfo()
            self.dataWaypointMap = self.readDataWaypontMapList()
            self.dataAirportMap = self.readDataAirportMapList()
            self.dataAirportColorMap = self.readDataAirportMapColorList()
            self.dataTrafficMap = self.readDataTrafficMapList()
            self.dataAabbaMap = self.readDataAabbaMapList()
            
            self.dataLogbookEntries = self.readDataLogbookEntries()
            self.dataLogbookLimitation = self.readDataLogbookLimitation()
            
            // For Recency
            self.dataRecency = self.readDataRecency()
            self.dataRecencyExpiry = self.readDataRecencyExpiry()
            self.dataExpiringSoon = self.extractExpiringDocuments(expiryData: self.dataRecencyExpiry, monthsAhead: self.monthsAhead)
            
            self.dataAlternate = self.readDataAlternate()
            self.loadImage(for: "https://tilecache.rainviewer.com/v2/radar/3e919cac9c01/8000/2/0_1.png")
//            self.loadImage(for: "https://tile.openweathermap.org/map/precipitation_new/0/0/0.png?appid=51689caed7a11007a1c5dd75a7678b5c")
//            self.prepareDataForWaypointMap()
//            self.prepareDataForAirportMap()
            self.dataNoteAabbaPreflight = self.readDataNoteAabbaPostList("preflight")
            
            self.dataPostPreflight = self.readDataPostList("preflight", "")
            self.dataPostPreflightRef = self.readDataPostList("preflight", "ref")
            
            self.dataPostDeparture = self.readDataPostList("departure", "")
            self.dataPostDepartureRef = self.readDataPostList("departure", "ref")
            
            self.dataPostEnroute = self.readDataPostList("enroute", "")
            self.dataPostEnrouteRef = self.readDataPostList("enroute", "ref")
            
            self.dataPostArrival = self.readDataPostList("arrival", "")
            self.dataPostArrivalRef = self.readDataPostList("arrival", "ref")
            
            self.dataNoteAabbaDeparture = self.readDataNoteAabbaPostList("departure")
            self.dataNoteAabbaEnroute = self.readDataNoteAabbaPostList("enroute")
            self.dataNoteAabbaArrival = self.readDataNoteAabbaPostList("arrival")
            self.dataNoteAabbaPreflightRef = self.readDataNoteAabbaPostList("preflightref")
            self.dataNoteAabbaDepartureRef = self.readDataNoteAabbaPostList("departureref")
            self.dataNoteAabbaEnrouteRef = self.readDataNoteAabbaPostList("enrouteref")
            self.dataNoteAabbaArrivalRef = self.readDataNoteAabbaPostList("arrivalref")
            
            self.readSummaryRoute()
            self.readPerfData()
//            self.dataPerfInfo = self.readPerfInfo()
            self.dataPerfWeight = self.readPerfWeight()
            self.readFuelDataList()
            self.dataFuelTableList = self.readFuelTableList()
            self.readFuelExtra()
            self.dataAltnList = self.readAltnList()
            self.readDepartureAtc()
            self.readDepartureAtis()
            self.readDepartureEntries()
            self.readArrivalAtc()
            self.readArrivalAtis()
            self.readArrivalEntries()
            self.dataNotams = self.readDataNotamsList()
            self.dataNotamsRef = self.readDataNotamsRefList()
            self.dataDepartureNotamsRef = self.readDataNotamsByType("depNotams")
            self.dataEnrouteNotamsRef = self.readDataNotamsByType("enrNotams")
            self.dataArrivalNotamsRef = self.readDataNotamsByType("arrNotams")
            self.dataDestinationNotamsRef = self.readDataNotamsByType("destNotams")
            
            self.dataDepartureMetarTaf = self.readDataMetarTafByType("depMetarTaf")
            self.dataEnrouteMetarTaf = self.readDataMetarTafByType("enrMetarTaf")
            self.dataArrivalMetarTaf = self.readDataMetarTafByType("arrMetarTaf")
            self.dataDestinationMetarTaf = self.readDataMetarTafByType("altnMetarTaf")
            
            self.readDataMetarTafList()
            self.dataAltnTaf = self.readDataAltnTafList()
            // For Fuel
            self.readProjDelays()
            self.readHistoricalDelays()
            self.readProjTaxi()
            self.readTrackMiles()
            self.readEnrWX()
            self.readFlightLevel()
            self.readReciprocalRwy()
            
            // For AISearch
            self.dataAISearch = self.readAISearch()
            self.dataAISearchFavorite = self.readAISearch(target: true)
            
            // For Calendar
            self.dataEvents = self.readEvents()
            self.dataEventCompleted = self.readEventsByStatus(status: "2")
            self.dataEventUpcoming = self.readEventsByStatus(status: "5")
        }
    }
    
    func checkAndSyncDataNote() async {
        let response = read()
        
        if response.count == 0 {
            initData()
        }
    }
    
    func initDataTag() {
        let newTags1 = TagList(context: service.container.viewContext)
        newTags1.id = UUID()
        newTags1.name = "Dispatch"
        
        let newTags2 = TagList(context: service.container.viewContext)
        newTags2.id = UUID()
        newTags2.name = "Terrain"
        
        let newTags3 = TagList(context: service.container.viewContext)
        newTags3.id = UUID()
        newTags3.name = "Weather"
        
        let newTags4 = TagList(context: service.container.viewContext)
        newTags4.id = UUID()
        newTags4.name = "Approach"
        
        let newTags5 = TagList(context: service.container.viewContext)
        newTags5.id = UUID()
        newTags5.name = "Airport"
        
        let newTags6 = TagList(context: service.container.viewContext)
        newTags6.id = UUID()
        newTags6.name = "ATC"
        
        let newTags7 = TagList(context: service.container.viewContext)
        newTags7.id = UUID()
        newTags7.name = "Aircraft"
        
        let newTags8 = TagList(context: service.container.viewContext)
        newTags8.id = UUID()
        newTags8.name = "Environment"
        
        service.container.viewContext.performAndWait {
            do {
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
                print("saved successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
        }
    }
    
    func initData() {
        let newTags1 = TagList(context: service.container.viewContext)
        newTags1.id = UUID()
        newTags1.name = "Terrain"
        
        let newTags2 = TagList(context: service.container.viewContext)
        newTags2.id = UUID()
        newTags2.name = "ATC"
        
        let newTags3 = TagList(context: service.container.viewContext)
        newTags3.id = UUID()
        newTags3.name = "Cabin Defects"
        
        let newTags4 = TagList(context: service.container.viewContext)
        newTags4.id = UUID()
        newTags4.name = "Aircraft Status"
        
        let newTags5 = TagList(context: service.container.viewContext)
        newTags5.id = UUID()
        newTags5.name = "Preflight"
        
        let newTags6 = TagList(context: service.container.viewContext)
        newTags6.id = UUID()
        newTags6.name = "Departure"
        
        let newTags7 = TagList(context: service.container.viewContext)
        newTags7.id = UUID()
        newTags7.name = "Enroute"
        
        let newTags8 = TagList(context: service.container.viewContext)
        newTags8.id = UUID()
        newTags8.name = "Arrival"
        
        let newTags9 = TagList(context: service.container.viewContext)
        newTags9.id = UUID()
        newTags9.name = "Crew Briefing"
        
        service.container.viewContext.performAndWait {
            do {
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
                print("saved successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()

            }
        }
        
//        let newDep1 = NoteList(context: service.container.viewContext)
//        newDep1.id = UUID()
//        newDep1.name = "All crew to be simulator-qualified for RNP approach"
//        newDep1.isDefault = false
//        newDep1.canDelete = false
//        newDep1.fromParent = false
//        newDep1.target = "departure"
//        newDep1.tags = NSSet(array: [newTags1])
//
//        let newDep2 = NoteList(context: service.container.viewContext)
//        newDep2.id = UUID()
//        newDep2.name = "Note digital clearance requirements 10mins before pushback"
//        newDep2.isDefault = false
//        newDep2.canDelete = false
//        newDep2.fromParent = false
//        newDep2.target = "departure"
//        newDep2.tags = NSSet(array: [newTags5])
//
//        let newDep3 = NoteList(context: service.container.viewContext)
//        newDep3.id = UUID()
//        newDep3.name = "Reduce ZFW by 1 ton for preliminary fuel"
//        newDep3.isDefault = false
//        newDep3.canDelete = false
//        newDep3.fromParent = false
//        newDep3.target = "departure"
//        newDep3.tags = NSSet(array: [newTags1])
//
//        let newDep4 = NoteList(context: service.container.viewContext)
//        newDep4.id = UUID()
//        newDep4.name = "Expected POB: 315"
//        newDep4.isDefault = false
//        newDep4.canDelete = false
//        newDep4.fromParent = false
//        newDep4.target = "departure"
//        newDep4.tags = NSSet(array: [newTags1])
//
//        let newDep5 = NoteList(context: service.container.viewContext)
//        newDep5.id = UUID()
//        newDep5.name = "Hills to the north of aerodrome"
//        newDep5.isDefault = false
//        newDep5.canDelete = false
//        newDep5.fromParent = false
//        newDep5.target = "departure"
//        newDep5.tags = NSSet(array: [newTags2])
//
//        let newEnroute1 = NoteList(context: service.container.viewContext)
//        newEnroute1.id = UUID()
//        newEnroute1.name = "Non-standard levels when large scale weather deviation in progress"
//        newEnroute1.isDefault = false
//        newEnroute1.canDelete = false
//        newEnroute1.fromParent = false
//        newEnroute1.target = "enroute"
//        newEnroute1.tags = NSSet(array: [newTags6])
//
//        let newArrival1 = NoteList(context: service.container.viewContext)
//        newArrival1.id = UUID()
//        newArrival1.name = "Birds in vicinity"
//        newArrival1.isDefault = false
//        newArrival1.canDelete = false
//        newArrival1.fromParent = false
//        newArrival1.target = "arrival"
//        newArrival1.tags = NSSet(array: [newTags8])
//
//        let newArrival2 = NoteList(context: service.container.viewContext)
//        newArrival2.id = UUID()
//        newArrival2.name = "Any +TS expected to last 15mins"
//        newArrival2.isDefault = false
//        newArrival2.canDelete = false
//        newArrival2.fromParent = false
//        newArrival2.target = "arrival"
//        newArrival2.tags = NSSet(array: [newTags3])
//
//        service.container.viewContext.performAndWait {
//            do {
//                // Persist the data in this managed object context to the underlying store
//                try service.container.viewContext.save()
//                print("saved successfully")
//            } catch {
//                // Something went wrong 😭
//                print("Failed to save: \(error)")
//                // Rollback any changes in the managed object context
//                service.container.viewContext.rollback()
//
//            }
//        }
    }
    
    
    func save() {
        if service.container.viewContext.hasChanges {
            do {
                try service.container.viewContext.save()
            }
            catch {
                fatalError("Unable to save data: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        service.container.viewContext.delete(object)
    }
    
    func readTag() -> [TagList] {
        // create a temp array to save fetched notes
        var data: [TagList] = []
        // initialize the fetch request
        let request: NSFetchRequest<TagList> = TagList.fetchRequest()
        
        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch tag from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readTagByName(_ target: String = "") -> [TagList] {
        // create a temp array to save fetched notes
        var data: [TagList] = []
        // initialize the fetch request
        let request: NSFetchRequest<TagList> = TagList.fetchRequest()
        
        if target != "" {
            request.predicate = NSPredicate(format: "name == %@", target)
        }
        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch tag from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readNoteListIncludeCrew() -> [NoteList] {
        // create a temp array to save fetched notes
        var data: [NoteList] = []
        // initialize the fetch request
        let request: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        
        request.predicate = NSPredicate(format: "includeCrew == 1")
        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch tag from Core Data.")
        }
        
        // return results
        return data
    }
    
    func initDataEnroute(_ dataEnroute: [IEnrouteDataResponseModel]) {
        dataEnroute.forEach { item in
            let newObject = EnrouteList(context: service.container.viewContext)
            
            newObject.id = UUID()
            newObject.posn = item.posn ?? ""
            newObject.actm = item.actm
            newObject.ztm = item.ztm
            newObject.eta = item.eta
            newObject.ata = item.ata
            newObject.afl = item.afl
            newObject.oat = item.oat
            newObject.adn = item.adn
            newObject.awind = item.aWind
            newObject.tas = item.tas
            newObject.vws = item.vws
            newObject.zfrq = item.zfrq
            newObject.afrm = item.afrm
            newObject.cord = item.Cord
            newObject.msa = item.Msa
            newObject.dis = item.Dis
            newObject.diff = item.Diff
            newObject.pfl = item.Pfl
            newObject.imt = item.Imt
            newObject.pdn = item.Pdn
            newObject.fwind = item.fWind
            newObject.gsp = item.Gsp
            newObject.drm = item.Drm
            newObject.pfrm = item.Pfrm
            newObject.fdiff = item.fDiff
            
            service.container.viewContext.performAndWait {
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to data route save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
        
        self.existDataFPEnroute = true
        dataFPEnroute = readEnrouteList()
        
        updateValues(0, dataFPEnroute)
    }
    
    func initDataSummaryInfo() {
        let newObj = SummaryInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.planNo = ""
        newObj.fltNo = "TR753"
        newObj.tailNo = ""
        newObj.dep = "BKK"
        newObj.dest = "SIN"
        newObj.depICAO = "VTBS"
        newObj.destICAO = "WSSS"
        newObj.flightDate = "2023-10-04"
        newObj.stdUTC = "2023-10-04 0815"
        newObj.staUTC = "2023-10-04 1015"
        newObj.stdLocal = "2023-10-04 1515"
        newObj.staLocal = "2023-10-04 1615"
        newObj.blkTime = "02:00"
        newObj.fltTime = "01:45"
        newObj.timeDiffArr = "8"
        newObj.timeDiffDep = "9"
        
//        newObj.planNo = infoData.planNo
//        newObj.fltNo = infoData.fltNo
//        newObj.tailNo = infoData.tailNo
//        newObj.dep = infoData.dep
//        newObj.dest = infoData.dest
//        newObj.depICAO = infoData.depICAO
//        newObj.destICAO = infoData.destICAO
//        newObj.flightDate = infoData.flightDate
//        newObj.stdUTC = infoData.STDUTC
//        newObj.staUTC = infoData.STAUTC
//        newObj.stdLocal = infoData.STDLocal
//        newObj.staLocal = infoData.STALocal
//        newObj.blkTime = infoData.blkTime
//        newObj.fltTime = infoData.fltTime
//        newObj.timeDiffArr = infoData.time_diff_arr
//        newObj.timeDiffDep = infoData.time_diff_dep
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataSummaryInfo = true
            readSummaryInfo()
            print("saved successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to summary info save: \(error)")
            // Rollback any changes in the managed object context
            existDataSummaryInfo = false
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataSummaryRoute(_ routeData: ISummaryDataResponseModel) {
        let newObj = SummaryRouteList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.routeNo = routeData.routeNo
        newObj.route = routeData.route
        newObj.depRwy = routeData.depRwy
        newObj.arrRwy = routeData.arrRwy
        newObj.levels = routeData.levels
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataSummaryRoute = true
            readSummaryRoute()
            print("saved summary route successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to summary route save: \(error)")
            existDataSummaryRoute = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataWaypoint(_ data: [IWaypointData]) {
        if data.count > 0 {
            data.forEach { item in
                let newObj = WaypointMapList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.name = item.waypoint_id
                newObj.latitude = item.lat
                newObj.longitude = item.long
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved waypoint data successfully")
                    } catch {
                        print("Failed to waypoint data save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataWaypointMap = readDataWaypontMapList()
//            self.prepareDataForWaypointMap()
        }
    }
    
    func initDataAirport(_ data: [IAirportData]) {
        if data.count > 0 {
            data.forEach { item in
                let newObj = AirportMapList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.name = item.airport_id
                newObj.latitude = item.lat
                newObj.longitude = item.long
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data airport successfully")
                    } catch {
                        print("Failed to data airport save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataAirportMap = readDataAirportMapList()
        }
    }
    
    func initDataAirportColor(_ data: [IAirportData]) {
        let depAirport = "VTBS"
        let arrAirport = "WSSS"
        let enrAirports = ["WMKK", "WMKP"]
        let altnAirports = ["WMKJ", "WIDD"]
        
        let airportInformation: [IAirportColor] = extractAirportInformation(allAirportsData: data, depAirport: depAirport, arrAirport: arrAirport, enrAirports: enrAirports, altnAirports: altnAirports)
        
        if airportInformation.count > 0 {
            airportInformation.forEach { item in
                let newObj = AirportMapColorList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.airportId = item.airportID
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.selection = item.selection
                newObj.colour = item.colour
//                newObj.notams = item.notams
                newObj.metar = item.metar
                newObj.taf = item.taf
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data airport color successfully")
                    } catch {
                        print("Failed to data airport color save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataAirportColorMap = readDataAirportMapColorList()
        }
    }
    
    func extractAirportInformation(allAirportsData: [IAirportData], depAirport: String, arrAirport: String, enrAirports: [String], altnAirports: [String]) -> [IAirportColor] {
        var airportInfo: [IAirportColor] = []
        
        for airportData in allAirportsData {
            if airportData.airport_id == depAirport {
                airportInfo.append(
                    IAirportColor(airportID: airportData.airport_id, lat: airportData.lat, long: airportData.long, selection: "Departure", colour: "blue", notams: [], metar: "", taf: "")
                )
            } else if airportData.airport_id == arrAirport {
                airportInfo.append(
                    IAirportColor(airportID: airportData.airport_id, lat: airportData.lat, long: airportData.long, selection: "Arrival", colour: "blue", notams: [], metar: "", taf: "")
                )
            } else if enrAirports.contains(airportData.airport_id) || altnAirports.contains(airportData.airport_id) {
                airportInfo.append(
                    IAirportColor(airportID: airportData.airport_id, lat: airportData.lat, long: airportData.long, selection: "ALTN", colour: "green", notams: [], metar: "", taf: "")
                )
            }
        }
        
        return airportInfo
    }
    
    func initDataTraffic(_ data: [ITrafficData]) {
        if data.count > 0 {
            data.forEach { item in
                let newObj = TrafficMapList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.colour = item.colour
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.callsign = item.callsign
                newObj.trueTrack = item.true_track
                newObj.baroAltitude = item.baro_altitude
                newObj.aircraftType = item.aircraft_type
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data traffic successfully")
                    } catch {
                        print("Failed to data traffic save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataTrafficMap = readDataTrafficMapList()
        }
    }
    
    func initDataAabba(_ data: [IAabbaData]) {
        if data.count > 0 {
            for item in data {
                var posts = [AabbaPostList]()
                
                if (item.post_count as? NSString)!.integerValue > 0 {
                    for post in item.posts {
                        var comments = [AabbaCommentList]()
                        
                        if (post.comment_count as NSString).intValue > 0 {
                            for comment in post.comments {
                                let newComment = AabbaCommentList(context: service.container.viewContext)
                                newComment.id = UUID()
                                newComment.commentId = comment.comment_id
                                newComment.postId = comment.post_id
                                newComment.userId = comment.user_id
                                newComment.commentDate = comment.comment_date
                                newComment.commentText = comment.comment_text
                                newComment.userName = comment.username
                                
                                comments.append(newComment)
                            }
                        }
                        
                        let newPost = AabbaPostList(context: service.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = post.post_id
                        newPost.userId = post.user_id
                        newPost.userName = post.username
                        newPost.postDate = post.post_date
                        newPost.postTitle = post.post_title
                        newPost.postText = post.post_text
                        newPost.upvoteCount = Int32(post.upvote_count)
                        newPost.commentCount = post.comment_count
                        newPost.category = post.category
                        newPost.postUpdated = Date()
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = AabbaMapList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = item.post_count
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.posts = NSSet(array: posts)
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data aabba successfully")
                    } catch {
                        print("Failed to data aabba save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()

                    }
                }
            }

            self.dataAabbaMap = readDataAabbaMapList()
        }
    }
    
    func initDataLogbookEntries(_ data: [ILogbookEntriesData]) {
        if data.count > 0 {
            data.forEach { item in
                let newObj = LogbookEntriesList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.logId = item.log_id
                newObj.date = item.date
                newObj.aircraftCategory = item.aircraft_category
                newObj.aircraftType = item.aircraft_type
                newObj.aircraft = item.aircraft
                newObj.departure = item.departure
                newObj.destination = item.destination
                newObj.picDay = item.pic_day
                newObj.picUUsDay = item.pic_u_us_day
                newObj.p1Day = item.p1_day
                newObj.p2Day = item.p2_day
                newObj.picNight = item.pic_night
                newObj.picUUsNight = item.pic_u_us_night
                newObj.p1Night = item.p1_night
                newObj.p2Night = item.p2_night
                newObj.instr = item.instr
                newObj.exam = item.exam
                newObj.comments = item.comments
                newObj.signature = item.signature
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data logbook entries successfully")
                    } catch {
                        print("Failed to logbook entries save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataLogbookEntries = readDataLogbookEntries()
        }
    }
    
    func initDataLogbookLimitation(_ data: [ILogbookLimitationData]) {
        if data.count > 0 {
            data.forEach { item in
                let newObj = LogbookLimitationList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.remoteId = item.id
                newObj.type = item.limitation_type
                newObj.requirement = item.limitation_requirement
                newObj.limit = item.limitation_limit
                newObj.start = item.limitation_start
                newObj.end = item.limitation_end
                newObj.text = item.limitation_text

                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data logbook limitation successfully")
                    } catch {
                        print("Failed to logbook limitation save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataLogbookLimitation = readDataLogbookLimitation()
        }
    }
    
    func initDataRecency(_ data: [IRecencyData]) {
        if data.count > 0 {
            data.forEach { item in
                let newObj = RecencyList(context: service.container.viewContext)
                
                newObj.id = UUID()
                newObj.type = item.recency_type
                newObj.text = item.recency_text
                newObj.limit = item.recency_limit
                newObj.requirement = item.recency_requirement

                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data recency successfully")
                    } catch {
                        print("Failed to data recency save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            self.dataRecency = readDataRecency()
        }
    }
    
    func initDataRecencyExpiry(_ data: [String: String]) {
        for key in data.keys {
            if key != "id" {
                let newObj = RecencyExpiryList(context: service.container.viewContext)
                newObj.id = UUID()
                newObj.name = key
                newObj.expiredDate = data[key]
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data recency expiry successfully")
                    } catch {
                        print("Failed to data recency expiry save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
        }
        
        self.dataRecencyExpiry = readDataRecencyExpiry()
    }
    
    func initDataNoteAabbaPreflight(_ data: [INoteResponse]) {
        if data.count > 0 {
            for item in data {
                var posts = [NotePostList]()
                
                if item.post_count > 0 {
                    for post in item.posts {
                        var comments = [NoteCommentList]()
                        
                        if (post.comment_count as NSString).intValue > 0 {
                            for comment in post.comments {
                                let newComment = NoteCommentList(context: service.container.viewContext)
                                newComment.id = UUID()
                                newComment.commentId = comment.comment_id
                                newComment.postId = comment.post_id
                                newComment.userId = comment.user_id
                                newComment.commentDate = comment.comment_date
                                newComment.commentText = comment.comment_text
                                newComment.userName = comment.username
                                
                                comments.append(newComment)
                            }
                        }
                        
                        let newPost = NotePostList(context: service.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = post.post_id
                        newPost.userId = post.user_id
                        newPost.userName = post.username
                        newPost.postDate = post.post_date
                        newPost.postTitle = post.post_title
                        newPost.postText = post.post_text
                        newPost.upvoteCount = post.upvote_count
                        newPost.commentCount = post.comment_count
                        newPost.category = post.category
                        newPost.postUpdated = Date()
                        newPost.favourite = post.favourite
                        newPost.blue = post.blue
                        newPost.type = "preflight"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = "\(item.post_count)"
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "preflight"
                newObj.posts = NSSet(array: posts)
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data aabba successfully")
                    } catch {
                        print("Failed to data aabba save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()

                    }
                }
            }

            self.dataNoteAabbaPreflight = readDataNoteAabbaPostList("preflight")
        }
    }
    
    func initDataNoteAabbaDepature(_ data: [INoteResponse]) {
        if data.count > 0 {
            for item in data {
                var posts = [NotePostList]()
                
                if item.post_count > 0 {
                    for post in item.posts {
                        var comments = [NoteCommentList]()
                        
                        if (post.comment_count as NSString).intValue > 0 {
                            for comment in post.comments {
                                let newComment = NoteCommentList(context: service.container.viewContext)
                                newComment.id = UUID()
                                newComment.commentId = comment.comment_id
                                newComment.postId = comment.post_id
                                newComment.userId = comment.user_id
                                newComment.commentDate = comment.comment_date
                                newComment.commentText = comment.comment_text
                                newComment.userName = comment.username
                                
                                comments.append(newComment)
                            }
                        }
                        
                        let newPost = NotePostList(context: service.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = post.post_id
                        newPost.userId = post.user_id
                        newPost.userName = post.username
                        newPost.postDate = post.post_date
                        newPost.postTitle = post.post_title
                        newPost.postText = post.post_text
                        newPost.upvoteCount = post.upvote_count
                        newPost.commentCount = post.comment_count
                        newPost.category = post.category
                        newPost.postUpdated = Date()
                        newPost.favourite = post.favourite
                        newPost.blue = post.blue
                        newPost.type = "departure"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = "\(item.post_count)"
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "departure"
                newObj.posts = NSSet(array: posts)
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data aabba departure successfully")
                    } catch {
                        print("Failed to data aabba departure save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()

                    }
                }
            }

            self.dataNoteAabbaPreflight = readDataNoteAabbaPostList("departure")
        }
    }
    
    func initDataNoteAabbaEnroute(_ data: [INoteResponse]) {
        if data.count > 0 {
            for item in data {
                var posts = [NotePostList]()
                
                if item.post_count > 0 {
                    for post in item.posts {
                        var comments = [NoteCommentList]()
                        
                        if (post.comment_count as NSString).intValue > 0 {
                            for comment in post.comments {
                                let newComment = NoteCommentList(context: service.container.viewContext)
                                newComment.id = UUID()
                                newComment.commentId = comment.comment_id
                                newComment.postId = comment.post_id
                                newComment.userId = comment.user_id
                                newComment.commentDate = comment.comment_date
                                newComment.commentText = comment.comment_text
                                newComment.userName = comment.username
                                
                                comments.append(newComment)
                            }
                        }
                        
                        let newPost = NotePostList(context: service.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = post.post_id
                        newPost.userId = post.user_id
                        newPost.userName = post.username
                        newPost.postDate = post.post_date
                        newPost.postTitle = post.post_title
                        newPost.postText = post.post_text
                        newPost.upvoteCount = post.upvote_count
                        newPost.commentCount = post.comment_count
                        newPost.category = post.category
                        newPost.postUpdated = Date()
                        newPost.favourite = post.favourite
                        newPost.blue = post.blue
                        newPost.type = "enroute"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = "\(item.post_count)"
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "enroute"
                newObj.posts = NSSet(array: posts)
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data aabba enroute successfully")
                    } catch {
                        print("Failed to data aabba enroute save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()

                    }
                }
            }

            self.dataNoteAabbaPreflight = readDataNoteAabbaPostList("enroute")
        }
    }
    
    func initDataNoteAabbaArrival(_ data: [INoteResponse]) {
        if data.count > 0 {
            for item in data {
                var posts = [NotePostList]()
                
                if item.post_count > 0 {
                    for post in item.posts {
                        var comments = [NoteCommentList]()
                        
                        if (post.comment_count as NSString).intValue > 0 {
                            for comment in post.comments {
                                let newComment = NoteCommentList(context: service.container.viewContext)
                                newComment.id = UUID()
                                newComment.commentId = comment.comment_id
                                newComment.postId = comment.post_id
                                newComment.userId = comment.user_id
                                newComment.commentDate = comment.comment_date
                                newComment.commentText = comment.comment_text
                                newComment.userName = comment.username
                                
                                comments.append(newComment)
                            }
                        }
                        
                        let newPost = NotePostList(context: service.container.viewContext)
                        newPost.id = UUID()
                        newPost.postId = post.post_id
                        newPost.userId = post.user_id
                        newPost.userName = post.username
                        newPost.postDate = post.post_date
                        newPost.postTitle = post.post_title
                        newPost.postText = post.post_text
                        newPost.upvoteCount = post.upvote_count
                        newPost.commentCount = post.comment_count
                        newPost.category = post.category
                        newPost.postUpdated = Date()
                        newPost.favourite = post.favourite
                        newPost.blue = post.blue
                        newPost.type = "arrival"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = "\(item.post_count)"
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "arrival"
                newObj.posts = NSSet(array: posts)
                
                service.container.viewContext.performAndWait {
                    do {
                        try service.container.viewContext.save()
                        print("saved data aabba arrival successfully")
                    } catch {
                        print("Failed to data aabba arrival save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()

                    }
                }
            }

            self.dataNoteAabbaPreflight = readDataNoteAabbaPostList("arrival")
        }
    }
    
    func initDataEvent(_ events: [IEventResponse]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for item in events {
            let event = EventList(context: service.container.viewContext)
            event.id = UUID()
            event.dep = item.dep
            event.dest = item.dest
            event.startDate = item.startDate
            event.endDate = item.endDate
            event.location = item.location
            event.name = item.name
            event.status = Int32(item.status) ?? 0
            event.type = item.type
            
            service.container.viewContext.performAndWait {
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved calendar successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
        }
        
        self.dataEvents = self.readEvents()
        self.dataEventCompleted = self.readEventsByStatus(status: "2")
        self.dataEventUpcoming = self.readEventsByStatus(status: "5")
    }
    
    func initDataPerfData(_ perfData: IPerfDataResponseModel) {
        let newObj = PerfDataList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.fltRules = perfData.fltRules
        newObj.gndMiles = perfData.gndMiles
        newObj.airMiles = perfData.airMiles
        newObj.crzComp = perfData.crzComp
        newObj.apd = perfData.apd
        newObj.ci = perfData.ci
        newObj.zfwChange = perfData.minus_zfwChange
        newObj.lvlChange = perfData.lvlChange
        newObj.planZFW = perfData.planZFW
        newObj.maxZFW = perfData.maxZFW
        newObj.limZFW = perfData.limZFW
        newObj.planTOW = perfData.planTOW
        newObj.maxTOW = perfData.maxTOW
        newObj.limTOW = perfData.limTOW
        newObj.planLDW = perfData.planLDW
        newObj.maxLDW = perfData.maxLDW
        newObj.limLDW = perfData.limLDW
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataPerfData = true
            readPerfData()
            print("saved perf info successfully")
        } catch {
            print("Failed to perf data save: \(error)")
            existDataPerfData = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
//    func initDataPerfInfo(_ perfData: IPerfDataResponseModel) {
//        let newObj = PerfInfoList(context: service.container.viewContext)
//        newObj.id = UUID()
//        newObj.fltRules = perfData.fltRules
//        newObj.gndMiles = perfData.gndMiles
//        newObj.airMiles = perfData.airMiles
//        newObj.crzComp = perfData.crzComp
//        newObj.apd = perfData.apd
//        newObj.ci = perfData.ci
//        newObj.zfwChange = "M1000KG BURN LESS \(perfData.minus_zfwChange!)KG"
//        newObj.lvlChange = "P2000FT BURN LESS \(perfData.lvlChange!)KG"
//
//        do {
//            // Persist the data in this managed object context to the underlying store
//            try service.container.viewContext.save()
//            existDataPerfInfo = true
//            dataPerfInfo = readPerfInfo()
//            print("saved perf info successfully")
//        } catch {
//            print("Failed to perf info save: \(error)")
//            existDataPerfInfo = false
//            // Rollback any changes in the managed object context
//            service.container.viewContext.rollback()
//
//        }
//    }
    
//    func initDataPerfWeight(_ perfData: IPerfDataResponseModel) {
//        let perfWeightsTable = [
//            perfWeights(weight: "ZFW", plan: perfData.planZFW ?? "", actual: "", max: perfData.maxZFW ?? "", limitation: perfData.limZFW ?? ""),
//            perfWeights(weight: "TOW", plan: perfData.planTOW ?? "", actual: "", max: perfData.maxTOW ?? "", limitation: perfData.limTOW ?? ""),
//            perfWeights(weight: "LDW", plan: perfData.planLDW ?? "", actual: "", max: perfData.maxLDW ?? "", limitation: perfData.limLDW ?? ""),
//        ]
//
//        perfWeightsTable.forEach { item in
//            let newObj = PerfWeightList(context: service.container.viewContext)
//            newObj.id = UUID()
//            newObj.weight = item.weight
//            newObj.plan = item.plan
//            newObj.actual = ""
//            newObj.max = item.max
//            newObj.limitation = item.limitation
//
//            service.container.viewContext.performAndWait {
//                do {
//                    try service.container.viewContext.save()
//                    print("saved perf weight successfully")
//                } catch {
//                    print("Failed to perf weight save: \(error)")
//                    // Rollback any changes in the managed object context
//                    service.container.viewContext.rollback()
//
//                }
//            }
//        }
//        existDataPerfWeight = true
//        dataPerfWeight = readPerfWeight()
//    }
//
//    func initDataFuelList(_ fuelData: IFuelDataResponseModel) {
//        let fuelTable = [
//            fuel(firstColumn: "(A) Burnoff", time: fuelData.burnoff["time"] ?? "", fuel: fuelData.burnoff["fuel"] ?? "", policy_reason: ""),
//            fuel(firstColumn: "(B) Contingency Fuel", time: fuelData.cont["time"] ?? "", fuel: fuelData.cont["fuel"] ?? "", policy_reason: fuelData.cont["policy"]!),
//            fuel(firstColumn: "(C) Altn Fuel", time: fuelData.altn["time"] ?? "", fuel: fuelData.altn["fuel"] ?? "", policy_reason: ""),
//            fuel(firstColumn: "(D) Altn Hold", time: fuelData.hold["time"] ?? "", fuel: fuelData.hold["fuel"] ?? "", policy_reason: ""),
//            fuel(firstColumn: "(E) 60min Topup Fuel", time: fuelData.topup60["time"] ?? "", fuel: fuelData.topup60["fuel"] ?? "", policy_reason: ""),
//            fuel(firstColumn: "(F) Taxi Fuel", time: fuelData.taxi["time"] ?? "", fuel: fuelData.taxi["fuel"] ?? "", policy_reason: fuelData.taxi["policy"]!),
//            fuel(firstColumn: "(G) Flight Plan Requirement (A + B + C + D + E + F)", time: fuelData.planReq["time"] ?? "", fuel: fuelData.planReq["fuel"] ?? "", policy_reason: ""),
//            fuel(firstColumn: "(H) Dispatch Additional Fuel", time: fuelData.dispAdd["time"] ?? "", fuel: fuelData.dispAdd["fuel"] ?? "", policy_reason: fuelData.dispAdd["policy"]!)
//        ]
//
//        do {
//            let newFuelData = FuelDataList(context: service.container.viewContext)
//            newFuelData.id = UUID()
//            newFuelData.burnoff = try NSKeyedArchiver.archivedData(withRootObject: fuelData.burnoff, requiringSecureCoding: true)
//
//            newFuelData.cont = try NSKeyedArchiver.archivedData(withRootObject: fuelData.cont, requiringSecureCoding: true)
//
//            newFuelData.altn = try NSKeyedArchiver.archivedData(withRootObject: fuelData.altn, requiringSecureCoding: true)
//
//            newFuelData.hold = try NSKeyedArchiver.archivedData(withRootObject: fuelData.hold, requiringSecureCoding: true)
//
//            newFuelData.topup60 = try NSKeyedArchiver.archivedData(withRootObject: fuelData.topup60, requiringSecureCoding: true)
//
//            newFuelData.taxi = try NSKeyedArchiver.archivedData(withRootObject: fuelData.taxi, requiringSecureCoding: true)
//
//            newFuelData.planReq = try NSKeyedArchiver.archivedData(withRootObject: fuelData.planReq, requiringSecureCoding: true)
//
//            newFuelData.dispAdd = try NSKeyedArchiver.archivedData(withRootObject: fuelData.dispAdd, requiringSecureCoding: true)
//
//            try service.container.viewContext.save()
//            existDataFuelDataList = true
//            readFuelDataList()
//        } catch {
//            existDataFuelDataList = false
//            print("failed to fuel data save: \(error)")
//        }
//
//        fuelTable.forEach { item in
//            let newObj = FuelTableList(context: self.service.container.viewContext)
//            newObj.id = UUID()
//            newObj.firstColumn = item.firstColumn
//            newObj.time = item.time
//            newObj.fuel = item.fuel
//            newObj.policyReason = item.policy_reason
//
//            service.container.viewContext.performAndWait {
//                do {
//                    // Persist the data in this managed object context to the underlying store
//                    try service.container.viewContext.save()
//                    print("saved perf weight successfully")
//                } catch {
//                    // Something went wrong 😭
//                    print("Failed to fuel table list save: \(error)")
//                    // Rollback any changes in the managed object context
//                    service.container.viewContext.rollback()
//
//                }
//            }
//        }
//
//        dataFuelTableList = readFuelTableList()
//        readFuelExtra()
//    }
    
    func initDataAltn(_ altnData: [IAltnDataResponseModel]) {
        altnData.forEach { item in
            let newObj = AltnDataList(context: self.service.container.viewContext)
            newObj.id = UUID()
            newObj.altnRwy = item.altnRwy
            newObj.rte = item.rte
            newObj.vis = item.vis
            newObj.minima = item.minima
            newObj.dist = item.dist
            newObj.fl = item.fl
            newObj.comp = item.comp
            newObj.time = item.time
            newObj.fuel = item.fuel
            
            do {
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
                existDataAltn = true
                dataAltnList = readAltnList()
                print("saved data altn successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to data altn save: \(error)")
                existDataAltn = false
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
            }
        }
    }
    
    func insertDataNotams(airport: String, type: String, category: String, item: INotamWXChildJson) {
        
        let newObj = NotamsDataList(context: self.service.container.viewContext)
        newObj.id = UUID()
        newObj.airport = airport
        newObj.type = type
        newObj.notam = item.notam
        newObj.date = item.date
        newObj.rank = item.rank
        newObj.isChecked = false
        newObj.category = category
        self.service.container.viewContext.performAndWait {
            do {
                try self.service.container.viewContext.save()
                print("saved notams successfully")
            } catch {
                print("Failed to Notams depNotams save: \(error)")
            }

        }
    }
    
    func initDataNotams(_ notamsData: INotamWXJson) {
        if notamsData.depNotams.Runway.count > 0 {
            for item in notamsData.depNotams.Runway {
                insertDataNotams(airport: notamsData.depNotams.Airport, type: "depNotams", category: "Runway", item: item)
            }
        }
        
        if notamsData.depNotams.Taxiway.count > 0 {
            for item in notamsData.depNotams.Taxiway {
                insertDataNotams(airport: notamsData.depNotams.Airport, type: "depNotams", category: "Taxiway", item: item)
            }
        }
        
        if notamsData.depNotams.Approach_Departure.count > 0 {
            for item in notamsData.depNotams.Approach_Departure {
                insertDataNotams(airport: notamsData.depNotams.Airport, type: "depNotams", category: "Approach_Departure", item: item)
            }
        }
        
        if notamsData.depNotams.Obstacles.count > 0 {
            for item in notamsData.depNotams.Obstacles {
                insertDataNotams(airport: notamsData.depNotams.Airport, type: "depNotams", category: "Obstacles", item: item)
            }
        }
        
        if notamsData.depNotams.Others.count > 0 {
            for item in notamsData.depNotams.Others {
                insertDataNotams(airport: notamsData.depNotams.Airport, type: "depNotams", category: "Others", item: item)
            }
        }
        
        // End Dep
        
        if notamsData.arrNotams.Runway.count > 0 {
            for item in notamsData.arrNotams.Runway {
                insertDataNotams(airport: notamsData.arrNotams.Airport, type: "arrNotams", category: "Runway", item: item)
            }
        }
        
        if notamsData.arrNotams.Taxiway.count > 0 {
            for item in notamsData.arrNotams.Taxiway {
                insertDataNotams(airport: notamsData.arrNotams.Airport, type: "arrNotams", category: "Taxiway", item: item)
            }
        }
        
        if notamsData.arrNotams.Approach_Departure.count > 0 {
            for item in notamsData.arrNotams.Approach_Departure {
                insertDataNotams(airport: notamsData.arrNotams.Airport, type: "arrNotams", category: "Approach_Departure", item: item)
            }
        }
        
        if notamsData.arrNotams.Obstacles.count > 0 {
            for item in notamsData.arrNotams.Obstacles {
                insertDataNotams(airport: notamsData.arrNotams.Airport, type: "arrNotams", category: "Obstacles", item: item)
            }
        }
        
        if notamsData.arrNotams.Others.count > 0 {
            for item in notamsData.arrNotams.Others {
                insertDataNotams(airport: notamsData.arrNotams.Airport, type: "arrNotams", category: "Others", item: item)
            }
        }
        
        // End Arr
        
        if notamsData.enrNotams.count > 0 {
            
            for enr in notamsData.enrNotams {
                if enr.Runway.count > 0 {
                    for item in enr.Runway {
                        insertDataNotams(airport: enr.Airport.Airport, type: "enrNotams", category: "Runway", item: item)
                    }
                }
                
                if enr.Taxiway.count > 0 {
                    for item in enr.Taxiway {
                        insertDataNotams(airport: enr.Airport.Airport, type: "enrNotams", category: "Taxiway", item: item)
                    }
                }
                
                if enr.Approach_Departure.count > 0 {
                    for item in enr.Approach_Departure {
                        insertDataNotams(airport: enr.Airport.Airport, type: "enrNotams", category: "Approach_Departure", item: item)
                    }
                }
                
                if enr.Obstacles.count > 0 {
                    for item in enr.Obstacles {
                        insertDataNotams(airport: enr.Airport.Airport, type: "enrNotams", category: "Obstacles", item: item)
                    }
                }
                
                if enr.Others.count > 0 {
                    for item in enr.Others {
                        insertDataNotams(airport: enr.Airport.Airport, type: "enrNotams", category: "Others", item: item)
                    }
                }
            }
        }
        
        // End Enr
        
        if notamsData.altnNotams.count > 0 {
            for altn in notamsData.altnNotams {
                if altn.Runway.count > 0 {
                    for item in altn.Runway {
                        insertDataNotams(airport: altn.Airport.Airport, type: "altnNotams", category: "Runway", item: item)
                    }
                }
                
                if altn.Taxiway.count > 0 {
                    for item in altn.Taxiway {
                        insertDataNotams(airport: altn.Airport.Airport, type: "altnNotams", category: "Taxiway", item: item)
                    }
                }
                
                if altn.Approach_Departure.count > 0 {
                    for item in altn.Approach_Departure {
                        insertDataNotams(airport: altn.Airport.Airport, type: "altnNotams", category: "Approach_Departure", item: item)
                    }
                }
                
                if altn.Obstacles.count > 0 {
                    for item in altn.Obstacles {
                        insertDataNotams(airport: altn.Airport.Airport, type: "altnNotams", category: "Obstacles", item: item)
                    }
                }
                
                if altn.Others.count > 0 {
                    for item in altn.Others {
                        insertDataNotams(airport: altn.Airport.Airport, type: "altnNotams", category: "Others", item: item)
                    }
                }
            }
        }
        
        // End Altn
        
        
//        notamsData.arrNotams.forEach { item in
//            let newObj = NotamsDataList(context: self.service.container.viewContext)
//            newObj.id = UUID()
//            newObj.type = "arrNotams"
//            newObj.notam = item.notam
//            newObj.date = item.date
//            newObj.rank = item.rank
//            newObj.isChecked = false
//            self.service.container.viewContext.performAndWait {
//                do {
//                    try self.service.container.viewContext.save()
//                    print("saved notams successfully")
//                } catch {
//                    service.container.viewContext.rollback()
//                    print("Failed to Notams arrNotams save: \(error)")
//                }
//
//            }
//        }
//

    }
    
//    func initDataNotams(_ notamsData: INotamsDataResponseModel) {
//
//        for data in notamsData.depNotams {
//            if data.value.count > 0 {
//                data.value.forEach { item in
//                    let newObj = NotamsDataList(context: self.service.container.viewContext)
//                    newObj.id = UUID()
//                    newObj.type = "depNotams"
//                    newObj.notam = item.notam
//                    newObj.date = item.date
//                    newObj.rank = item.rank
//                    newObj.isChecked = false
//                    newObj.category = data.key
//                    self.service.container.viewContext.performAndWait {
//                        do {
//                            try self.service.container.viewContext.save()
//                            print("saved notams successfully")
//                        } catch {
//                            print("Failed to Notams depNotams save: \(error)")
//                        }
//
//                    }
//                }
//            }
//        }
//
//        for data in notamsData.arrNotams {
//            if data.value.count > 0 {
//                data.value.forEach { item in
//                    let newObj = NotamsDataList(context: self.service.container.viewContext)
//                    newObj.id = UUID()
//                    newObj.type = "arrNotams"
//                    newObj.notam = item.notam
//                    newObj.date = item.date
//                    newObj.rank = item.rank
//                    newObj.isChecked = false
//                    newObj.category = data.key
//                    self.service.container.viewContext.performAndWait {
//                        do {
//                            try self.service.container.viewContext.save()
//                            print("saved notams successfully")
//                        } catch {
//                            print("Failed to Notams depNotams save: \(error)")
//                        }
//
//                    }
//                }
//            }
//        }
//
//        notamsData.enrNotams.forEach { item in
//            let newObj = NotamsDataList(context: self.service.container.viewContext)
//            newObj.id = UUID()
//            newObj.type = "enrNotams"
//            newObj.notam = item.notam
//            newObj.date = item.date
//            newObj.rank = item.rank
//            newObj.isChecked = false
//            self.service.container.viewContext.performAndWait {
//                do {
//                    try self.service.container.viewContext.save()
//                    print("saved notams successfully")
//                } catch {
//                    service.container.viewContext.rollback()
//                    print("Failed to Notams enrNotams save: \(error)")
//                }
//
//            }
//        }
//        dataNotams = readDataNotamsList()
//
////        notamsData.arrNotams.forEach { item in
////            let newObj = NotamsDataList(context: self.service.container.viewContext)
////            newObj.id = UUID()
////            newObj.type = "arrNotams"
////            newObj.notam = item.notam
////            newObj.date = item.date
////            newObj.rank = item.rank
////            newObj.isChecked = false
////            self.service.container.viewContext.performAndWait {
////                do {
////                    try self.service.container.viewContext.save()
////                    print("saved notams successfully")
////                } catch {
////                    service.container.viewContext.rollback()
////                    print("Failed to Notams arrNotams save: \(error)")
////                }
////
////            }
////        }
////
//
//    }
    
    func initDepDataMetarTaf(_ metarTafData: IDepMetarTafWXChild, type: String) {
        do {
            let newObj = MetarTafDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.airport = metarTafData.airport
            newObj.std = metarTafData.std
            newObj.metar = metarTafData.metar
            newObj.taf = metarTafData.taf
            newObj.type = type
            try service.container.viewContext.save()
            existDataMetarTaf = true
            readDataMetarTafList()
            print("saved Metar Taf successfully")
        } catch {
            print("Failed to Metar Taf save: \(error)")
            existDataMetarTaf = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initArrDataMetarTaf(_ metarTafData: IArrMetarTafWXChild, type: String) {
        do {
            let newObj = MetarTafDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.airport = metarTafData.airport
            newObj.std = metarTafData.sta
            newObj.metar = metarTafData.metar
            newObj.taf = metarTafData.taf
            newObj.type = type
            try service.container.viewContext.save()
            existDataMetarTaf = true
            readDataMetarTafList()
            print("saved Metar Taf successfully")
        } catch {
            print("Failed to Metar Taf save: \(error)")
            existDataMetarTaf = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initEnrDataMetarTaf(_ metarTafData: IAltnMetarTafWXChild, type: String) {
        do {
            let newObj = MetarTafDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.airport = metarTafData.airport
            newObj.std = metarTafData.eta
            newObj.metar = metarTafData.metar
            newObj.taf = metarTafData.taf
            newObj.type = type
            try service.container.viewContext.save()
            existDataMetarTaf = true
            readDataMetarTafList()
            print("saved Metar Taf successfully")
        } catch {
            print("Failed to Metar Taf save: \(error)")
            existDataMetarTaf = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func updateDataMetarTaf(_ metarTafData: IFlightPlanWXResponseModel) {
//        do {
//            readDataMetarTafList()
//            if self.dataMetarTaf!.id != nil {
//                self.dataMetarTaf.depMetar = metarTafData.depMetar
//                self.dataMetarTaf.depTaf = metarTafData.depTaf
//                self.dataMetarTaf.arrMetar = metarTafData.arrMetar
//                self.dataMetarTaf.arrTaf = metarTafData.arrTaf
//            } else {
//                let newObj = MetarTafDataList(context: service.container.viewContext)
//                newObj.id = UUID()
//                newObj.depMetar = metarTafData.depMetar
//                newObj.depTaf = metarTafData.depTaf
//                newObj.arrMetar = metarTafData.arrMetar
//                newObj.arrTaf = metarTafData.arrTaf
//            }
//            try service.container.viewContext.save()
//            existDataMetarTaf = true
//            readDataMetarTafList()
//            print("saved Metar Taf successfully")
//        } catch {
//            print("Failed to Metar Taf save: \(error)")
//            existDataMetarTaf = false
//            // Rollback any changes in the managed object context
//            service.container.viewContext.rollback()
//        }
    }
    
    func initDataAltnTaf(_ metarTafData: IFlightPlanWXResponseModel) {
        service.container.viewContext.performAndWait {
            metarTafData.altnTaf.forEach { item in
                do {
                    let newObj1 = AltnTafDataList(context: service.container.viewContext)
                    newObj1.id = UUID()
                    newObj1.altnRwy = item.altnRwy
                    newObj1.eta = item.eta
                    newObj1.taf = item.taf
                    try service.container.viewContext.save()
                    print("saved altn taf successfully")
                } catch {
                    print("Failed to Altn Taf save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                }
            }
            existDataAltnTaf = true
            dataAltnTaf = readDataAltnTafList()
        }
    }
    
    func updateDataAltnTaf(_ metarTafData: IFlightPlanWXResponseModel) {
        let fetchRequest: NSFetchRequest<AltnTafDataList>
        fetchRequest = AltnTafDataList.fetchRequest()
        fetchRequest.includesPropertyValues = false
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                metarTafData.altnTaf.forEach { item in
                    do {
                        let newObj1 = AltnTafDataList(context: service.container.viewContext)
                        newObj1.id = UUID()
                        newObj1.altnRwy = item.altnRwy
                        newObj1.eta = item.eta
                        newObj1.taf = item.taf
                        try service.container.viewContext.save()
                        print("saved altn taf successfully")
                    } catch {
                        print("Failed to Altn Taf save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                    }
                }
                
                do {
                    // Delete the objects
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
                existDataAltnTaf = true
                dataAltnTaf = readDataAltnTafList()
            }
            
            print("Delete to Altn Taf successfully")
        } catch {
            print("Failed to Altn Taf update: \(error)")
        }
    }
    
    func syncDataEvent() async {
        if let filepath = Bundle.main.path(forResource: "example", ofType: "ics") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let parser = ICParser()
                let calendar: ICalendar? = parser.calendar(from: contents)
                
                if calendar != nil {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone.current
                    dateFormatter.locale = Locale.current
                    dateFormatter.calendar = Calendar(identifier: .gregorian)
                    
                    let fetchRequest: NSFetchRequest<EventList>
                    fetchRequest = EventList.fetchRequest()
                    fetchRequest.includesPropertyValues = false
                    
                    // Fetch old data to remove them after insert new data
                    let objects = try service.container.viewContext.fetch(fetchRequest)
                    
                    service.container.viewContext.performAndWait {
                        for item in calendar!.events {
                            let startDate = dateFormatter.string(from: item.dtStart!.date)
                            let dtEndDate = dateFormatter.string(from: item.dtEnd!.date)
                            
                            if startDate < dtEndDate {
                                let endDate = dateFormatter.string(for: Calendar.current.date(byAdding: .day, value: -1, to: item.dtEnd!.date))
                                
                                do {
                                    let event = EventList(context: service.container.viewContext)
                                    event.id = UUID()
                                    event.name = item.summary!
                                    event.status = 5
                                    event.startDate = startDate
                                    event.endDate = endDate
                                    try service.container.viewContext.save()
                                    print("saved event successfully")
                                } catch {
                                    print("Failed to event save: \(error)")
                                    // Rollback any changes in the managed object context
                                    service.container.viewContext.rollback()
                                }

                            } else {
                                
                                do {
                                    let event = EventList(context: service.container.viewContext)
                                    event.id = UUID()
                                    event.name = item.summary!
                                    event.status = 5
                                    event.startDate = startDate
                                    event.endDate = dtEndDate
                                    try service.container.viewContext.save()
                                    print("saved event successfully")
                                } catch {
                                    print("Failed to event save: \(error)")
                                    // Rollback any changes in the managed object context
                                    service.container.viewContext.rollback()
                                }
                            }
                            
                        }
                        
                        do {
                            // Delete the objects
                            for object in objects {
                                service.container.viewContext.delete(object)
                            }
                            
                            // Save the deletions to the persistent store
                            try service.container.viewContext.save()
                        } catch {
                            print("Failed to delete event : \(error)")
                        }
                        
                        self.dataEvents = readEvents()
                    }
                }
            } catch {
                // contents could not be loaded
            }
        } else {
            print("Error read file ics")
        }
    }
    
    func readScratchPad() -> [ScratchPadList] {
        // create a temp array to save fetched notes
        var data: [ScratchPadList] = []
        // initialize the fetch request
        let request: NSFetchRequest<ScratchPadList> = ScratchPadList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderNum", ascending: false)]
        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readFlightPlan() {
        // initialize the fetch request
        let request: NSFetchRequest<FlightPlanList> = FlightPlanList.fetchRequest()
        // fetch with the request
        do {
            let response: [FlightPlanList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataFlightPlan = item
                }
            } else {
                let newPlanList = FlightPlanList(context: service.container.viewContext)
                newPlanList.flightInfoPob = ""
                newPlanList.perActualZFW = 0
                newPlanList.perActualTOW = 0
                newPlanList.perActualLDW = 0
                newPlanList.fuelArrivalDelayRemark = ""
                newPlanList.fuelAdditionalTaxiRemark = ""
                newPlanList.fuelFlightLevelRemark = ""
                newPlanList.fuelTrackShorteningRemark = ""
                newPlanList.fuelEnrouteWeatherRemark = ""
                newPlanList.fuelReciprocalRemark = ""
                newPlanList.fuelZFWChangeRemark = ""
                newPlanList.fuelOtherRemark = ""
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            existDataFlightPlan = true
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func read(_ target: String = "preflight", predicateFormat: String? = "type = %@", fetchLimit: Int? = nil) -> [NoteList] {
        // create a temp array to save fetched notes
        var results: [NoteList] = []
        // initialize the fetch request
        let request: NSFetchRequest<NoteList> = NoteList.fetchRequest()

        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: "type == %@", target)
        }
        
        if fetchLimit != nil {
            request.fetchLimit = fetchLimit!
        }

        // fetch with the request
        do {
            results = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        // return results
        return results
    }
    
    func readDepartures() {
        readDepartureAtc()
        readDepartureAtis()
        readDepartureEntries()
    }
    
    func readDepartureAtc() {
        let request: NSFetchRequest<DepartureATCList> = DepartureATCList.fetchRequest()
        // fetch with the request
        do {
            let response: [DepartureATCList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataDepartureAtc = item
                }
            } else {
                initDepartureAtc()
            }
            existDataDepartureAtc = true
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initDepartureAtc() {
        let newObj = DepartureATCList(context: service.container.viewContext)
        newObj.atcDep = ""
        newObj.atcSQ = ""
        newObj.atcRte = ""
        newObj.atcFL = ""
        newObj.atcRwy = ""
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            print("saved successfully")
            readDepartureAtc()
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func readDepartureAtis() {
        let request: NSFetchRequest<DepartureATISList> = DepartureATISList.fetchRequest()
        // fetch with the request
        do {
            let response: [DepartureATISList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataDepartureAtis = item
                }
            } else {
                initDepartureAtis()
            }
            existDataDepartureAtis = true
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initDepartureAtis() {
        let newObj = DepartureATISList(context: service.container.viewContext)
        newObj.cloud = ""
        newObj.code = ""
        newObj.dp = ""
        newObj.qnh = ""
        newObj.remarks = ""
        newObj.rwy = ""
        newObj.temp = ""
        newObj.time = ""
        newObj.translvl = ""
        newObj.vis = ""
        newObj.wx = ""
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            readDepartureAtis()
            print("saved successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func readDepartureEntries() {
        let request: NSFetchRequest<DepartureEntriesList> = DepartureEntriesList.fetchRequest()
        // fetch with the request
        do {
            let response: [DepartureEntriesList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataDepartureEntries = item
                }
            } else {
                initDepartureEntries()
            }
            existDataDepartureEntries = true
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initDepartureEntries() {
        let newObj = DepartureEntriesList(context: service.container.viewContext)
        newObj.entTaxi = ""
        newObj.entTakeoff = ""
        newObj.entOff = ""
        newObj.entFuelInTanks = ""
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            readDepartureEntries()
            print("saved successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func readArrivals() {
        readArrivalAtc()
        readArrivalAtis()
        readArrivalEntries()
    }
    
    func readArrivalAtc() {
        let request: NSFetchRequest<ArrivalATCList> = ArrivalATCList.fetchRequest()
        // fetch with the request
        do {
            let response: [ArrivalATCList] = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                if let item = response.first {
                    dataArrivalAtc = item
                }
            } else {
                initDataArrivalAtc()
            }
            existDataArrivalAtc = true
        } catch {
            print("Could not fetch Arrival ATC from Core Data.")
        }
    }
    
    func initDataArrivalAtc() {
        let newObject = ArrivalATCList(context: service.container.viewContext)
        newObject.id = UUID()
        newObject.atcDest = ""
        newObject.atcArr = ""
        newObject.atcRwy = ""
        newObject.atcTransLvl = ""
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            readArrivalAtc()
            print("saved successfully")
        } catch {
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func readArrivalAtis() {
        let request: NSFetchRequest<ArrivalATISList> = ArrivalATISList.fetchRequest()
        // fetch with the request
        do {
            let response: [ArrivalATISList] = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                if let item = response.first {
                    dataArrivalAtis = item
                }
            } else {
                initDataArrivalAtis()
            }
            existDataArrivalAtis = true
        } catch {
            print("Could not fetch Arrival Atis from Core Data.")
        }
    }
    
    func initDataArrivalAtis() {
        let newObject = ArrivalATISList(context: service.container.viewContext)
        newObject.id = UUID()
        newObject.code = ""
        newObject.time = ""
        newObject.rwy = ""
        newObject.transLvl = ""
        newObject.wind = ""
        newObject.vis = ""
        newObject.wx = ""
        newObject.cloud = ""
        newObject.temp = ""
        newObject.dp = ""
        newObject.qnh = ""
        newObject.remarks = ""
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            readArrivalAtis()
            print("saved successfully")
        } catch {
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
        }
    }
    
    func readArrivalEntries() {
        let request: NSFetchRequest<ArrivalEntriesList> = ArrivalEntriesList.fetchRequest()
        // fetch with the request
        do {
            let response: [ArrivalEntriesList] = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                if let item = response.first {
                    dataArrivalEntries = item
                }
            } else {
                initDataArrivalEntries()
            }
            existDataArrivalEntries = true
        } catch {
            print("Could not fetch Arrival Entries from Core Data.")
        }
    }
    
    func initDataArrivalEntries() {
        let newObject = ArrivalEntriesList(context: service.container.viewContext)
        newObject.id = UUID()
        newObject.entLdg = ""
        newObject.entOn = ""
        newObject.entFuelOnChocks = ""
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            readArrivalEntries()
            print("saved successfully")
        } catch {
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }

    func readEnrouteList() -> [EnrouteList] {
        var data: [EnrouteList] = []
        
        let request: NSFetchRequest<EnrouteList> = EnrouteList.fetchRequest()
        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        return data
    }
    
    func readSummaryInfo() {
        let request: NSFetchRequest<SummaryInfoList> = SummaryInfoList.fetchRequest()
        do {
            let response: [SummaryInfoList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataSummaryInfo = item
                    existDataSummaryInfo = true
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func readSummaryRoute() {
        let request: NSFetchRequest<SummaryRouteList> = SummaryRouteList.fetchRequest()
        do {
            let response: [SummaryRouteList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataSummaryRoute = item
                    existDataSummaryRoute = true
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func readPerfData() {
        let request: NSFetchRequest<PerfDataList> = PerfDataList.fetchRequest()
        do {
            let response: [PerfDataList] = try service.container.viewContext.fetch(request)
            
            if(response.count > 0) {
                if let item = response.first {
                    dataPerfData = item
                    existDataPerfData = true
                }
            }
        } catch {
            print("Could not fetch perf data from Core Data.")
        }
    }
    
//    func readPerfInfo() -> [PerfInfoList] {
//        var data: [PerfInfoList] = []
//
//        let request: NSFetchRequest<PerfInfoList> = PerfInfoList.fetchRequest()
//        do {
//            let response: [PerfInfoList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                data = response
//                existDataPerfInfo = true
//
//                // Init data performance change table
//                if let item = response.first {
//                    perfChangesTable = [perfChanges(zfwChange: item.unwrappedZfwChange, lvlChange: item.unwrappedLvlChange)]
//                }
//            }
//        } catch {
//            print("Could not fetch scratch pad from Core Data.")
//        }
//
//        return data
//    }
    
    func readPerfWeight() -> [PerfWeightList] {
        var data: [PerfWeightList] = []
        
        let request: NSFetchRequest<PerfWeightList> = PerfWeightList.fetchRequest()
        do {
            let response: [PerfWeightList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
                existDataPerfWeight = true
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        return data
    }
    
    func readFuelDataList() {
        let request: NSFetchRequest<FuelDataList> = FuelDataList.fetchRequest()
        do {
            let response: [FuelDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataFuelDataList = item
                    existDataFuelDataList = true
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func readFuelTableList() -> [FuelTableList] {
        var data: [FuelTableList] = []
        
        let request: NSFetchRequest<FuelTableList> = FuelTableList.fetchRequest()
        do {
            let response: [FuelTableList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
                existDataFuelTableList = true
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        return data
    }
    
    func readFuelExtraList() -> [FuelExtraList] {
        var data: [FuelExtraList] = []
        
        let request: NSFetchRequest<FuelExtraList> = FuelExtraList.fetchRequest()
        do {
            let response: [FuelExtraList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch fuel extra from Core Data.")
        }
        
        return data
    }
    
    func readFuelExtra() {
        let request: NSFetchRequest<FuelExtraList> = FuelExtraList.fetchRequest()
        do {
            let response: [FuelExtraList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataFuelExtra = item
                    existDataFuelExtra = true
                }
            }  else {
                let newObj = FuelExtraList(context: service.container.viewContext)
                newObj.includedArrDelays = false
                newObj.includedFlightLevel = false
                newObj.includedEnrWx = false
                newObj.includedReciprocalRwy = false
                newObj.includedTaxi = false
                newObj.includedTrackShortening = false
                newObj.includedZFWchange = false
                newObj.includedOthers = false
                newObj.selectedArrDelays = 0
                newObj.selectedTaxi = 0
                newObj.selectedTrackShortening = 0
                newObj.selectedFlightLevel000 = 0
                newObj.selectedFlightLevel00 = 0
                newObj.selectedEnrWx = 0
                newObj.selectedReciprocalRwy = 0
                newObj.selectedOthers000 = 0
                newObj.selectedOthers00 = 0
                newObj.remarkArrDelays = ""
                newObj.remarkTaxi = ""
                newObj.remarkFlightLevel = ""
                newObj.remarkTrackShortening = ""
                newObj.remarkEnrWx = ""
                newObj.remarkReciprocalRwy = ""
                newObj.remarkZFWChange = ""
                newObj.remarkOthers = ""
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    
                    let response1: [FuelExtraList] = try service.container.viewContext.fetch(request)
                    if(response1.count > 0) {
                        if let item = response1.first {
                            dataFuelExtra = item
                            existDataFuelExtra = true
                        }
                    }
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
                existDataFuelExtra = false
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func readAltnList() -> [AltnDataList] {
        var data: [AltnDataList] = []
        
        let request: NSFetchRequest<AltnDataList> = AltnDataList.fetchRequest()
        do {
            let response: [AltnDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch altn from Core Data.")
        }
        
        return data
    }
    
    func readDataNotamsByType(_ target: String = "") -> [NotamsDataList] {
        var data: [NotamsDataList] = []
        
        let request: NSFetchRequest<NotamsDataList> = NotamsDataList.fetchRequest()
        
        if target != "" {
            request.predicate = NSPredicate(format: "type == %@ AND isChecked == %@", argumentArray: [target, 1])
        }
        do {
            let response: [NotamsDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
    }
    
    func readDataNotamsList() -> [NotamsDataList] {
        var data: [NotamsDataList] = []
        
        let request: NSFetchRequest<NotamsDataList> = NotamsDataList.fetchRequest()
        do {
            let response: [NotamsDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
    }
    
    func readDataNotamsRefList() -> [NotamsDataList] {
        var data: [NotamsDataList] = []
        
        let request: NSFetchRequest<NotamsDataList> = NotamsDataList.fetchRequest()
        do {
            let response: [NotamsDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                response.forEach {item in
                    if item.isChecked {
                        data.append(item)
                    }
                }
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
        
    }
    
    func readDataMetarTafByType(_ target: String = "") -> MetarTafDataList? {
        var data: MetarTafDataList?
        
        let request: NSFetchRequest<MetarTafDataList> = MetarTafDataList.fetchRequest()
        
        if target != "" {
            request.predicate = NSPredicate(format: "type == %@", argumentArray: [target, 1])
        }
        do {
            let response: [MetarTafDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
    }
    
    func readDataMetarTafList() {
        let request: NSFetchRequest<MetarTafDataList> = MetarTafDataList.fetchRequest()
        do {
            let response: [MetarTafDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataMetarTaf = item
                    existDataMetarTaf = true
                }
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
    }
    
    func readDataAltnTafList() -> [AltnTafDataList] {
        var data: [AltnTafDataList] = []
        
        let request: NSFetchRequest<AltnTafDataList> = AltnTafDataList.fetchRequest()
        do {
            let response: [AltnTafDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
                existDataAltnTaf = true
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
    }
    
    func calculatedZFWFuel() -> Int {
        if let item = self.dataPerfWeight.first(where: {$0.weight == "ZFW"}) {
            var actual = Double(item.unwrappedActual) ?? Double(0)
            var unwrappedPlanZFW: Double = 0
            var unwrappedZfwChange: Double = 0
            
            if let temp = Double(dataPerfData.unwrappedPlanZFW) {
                unwrappedPlanZFW = temp
            }
            
            if let temp = Double(dataPerfData.unwrappedZfwChange) {
                unwrappedZfwChange = temp
            }
            
            if actual == 0 {
                return 0
            } else {
                return Int(Double(actual - unwrappedPlanZFW) * Double(unwrappedZfwChange / 1000))
            }
        }
        return 0
    }
    
    func readDataWaypontMapList() -> [WaypointMapList] {
        var data: [WaypointMapList] = []
        
        let request: NSFetchRequest<WaypointMapList> = WaypointMapList.fetchRequest()
        do {
            let response: [WaypointMapList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Map List from Core Data.")
        }
        
        return data
    }
    
    func readDataAirportMapList() -> [AirportMapList] {
        var data: [AirportMapList] = []
        
        let request: NSFetchRequest<AirportMapList> = AirportMapList.fetchRequest()
        do {
            let response: [AirportMapList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Airport List from Core Data.")
        }
        
        return data
    }
    
    func readDataAirportMapColorList() -> [AirportMapColorList] {
        var data: [AirportMapColorList] = []
        
        let request: NSFetchRequest<AirportMapColorList> = AirportMapColorList.fetchRequest()
        do {
            let response: [AirportMapColorList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Airport List Color from Core Data.")
        }
        
        return data
    }
    
    func readDataTrafficMapList() -> [TrafficMapList] {
        var data: [TrafficMapList] = []
        
        let request: NSFetchRequest<TrafficMapList> = TrafficMapList.fetchRequest()
        do {
            let response: [TrafficMapList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Traffic List from Core Data.")
        }
        
        return data
    }
    
    func readDataAabbaMapList() -> [AabbaMapList] {
        var data: [AabbaMapList] = []
        
        let request: NSFetchRequest<AabbaMapList> = AabbaMapList.fetchRequest()
        do {
            let response: [AabbaMapList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Traffic List from Core Data.")
        }
        
        return data
    }
    
    func readDataNoteAabbaPostList(_ target: String = "", predicateFormat: String? = "type = %@") -> [NoteAabbaPostList] {
        var data: [NoteAabbaPostList] = []
        
        let request: NSFetchRequest<NoteAabbaPostList> = NoteAabbaPostList.fetchRequest()
        
        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: "type == %@", target)
        }
        
        do {
            let response: [NoteAabbaPostList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Note Aabba Post List from Core Data.")
        }
        
        return data
    }

    
    func readDataPostList(_ target: String = "", _ ref: String = "") -> [NotePostList] {
        var data: [NotePostList] = []
        
        let request: NSFetchRequest<NotePostList> = NotePostList.fetchRequest()
        
        // define filter and/or limit if needed
        if target != "" {
            
            if ref != "" {
                request.predicate = NSPredicate(format: "type == %@ AND fromParent == %@", argumentArray: [target, 1])
            } else {
                request.predicate = NSPredicate(format: "type == %@", target)
            }
           
        }
        
        do {
            let response: [NotePostList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Note Aabba Post List from Core Data.")
        }
        
        return data
    }

    
    func readDataLogbookEntries() -> [LogbookEntriesList] {
        var data: [LogbookEntriesList] = []
        
        let request: NSFetchRequest<LogbookEntriesList> = LogbookEntriesList.fetchRequest()
        do {
            let response: [LogbookEntriesList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Logbook Entries from Core Data.")
        }
        
        return data
    }
    
    func readDataLogbookLimitation() -> [LogbookLimitationList] {
        var data: [LogbookLimitationList] = []
        
        let request: NSFetchRequest<LogbookLimitationList> = LogbookLimitationList.fetchRequest()
        do {
            let response: [LogbookLimitationList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Logbook Limitation from Core Data.")
        }
        
        return data
    }
    
    func readDataRecency() -> [RecencyList] {
        var data: [RecencyList] = []
        
        let request: NSFetchRequest<RecencyList> = RecencyList.fetchRequest()
        do {
            let response: [RecencyList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Recency from Core Data.")
        }
        
        return data
    }
    
    func readDataRecencyExpiry() -> [RecencyExpiryList] {
        var data: [RecencyExpiryList] = []
        
        let request: NSFetchRequest<RecencyExpiryList> = RecencyExpiryList.fetchRequest()
        do {
            let response: [RecencyExpiryList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Recency Expiry from Core Data.")
        }
        
        return data
    }

    func readDataAlternate() -> [RouteAlternateList] {
        var data: [RouteAlternateList] = []
        
        let request: NSFetchRequest<RouteAlternateList> = RouteAlternateList.fetchRequest()
        do {
            let response: [RouteAlternateList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Recency Expiry from Core Data.")
        }
        
        return data
    }

    func readHistoricalDelays() {
        do {
            let request: NSFetchRequest<HistoricalDelaysList> = HistoricalDelaysList.fetchRequest()
            let response = try service.container.viewContext.fetch(request)
            
            if(response.count > 0) {
                dataHistoricalDelays = response
            }
        } catch {
            print("Could not fetch notes from Core Data.")
        }
        
    }
    
//    func readHistoricalDelaysByType(_ type: String) -> HistoricalDelaysList? {
//        do {
//            let request: NSFetchRequest<HistoricalDelaysList> = HistoricalDelaysList.fetchRequest()
//            request.predicate = NSPredicate(format: "type == %@", "months3")
//            
//            let response = try service.container.viewContext.fetch(request)
//            
//            if(response.count > 0) {
//                let weeksD = (response.first?.delays?.allObjects as! [HistorycalDelaysRefList]).sorted(by: {$0.order > $1.order})
//                
//                return response.first
//            }
//        } catch {
//            print("Could not fetch notes from Core Data.")
//        }
//        return nil
//    }
    
    
    func initHistoricalDelays(_ historicalDelays: IHistoricalDelaysModel) {
        service.container.viewContext.performAndWait {
            do {
                let newObject = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [HistorycalDelaysRefList]()
                
                var order = 1
                historicalDelays.days3.delays.forEach { item in
                    let newObjDelay = HistorycalDelaysRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.condition = item.condition
                    newObjDelay.time = item.time
                    newObjDelay.delay = item.delay
                    newObjDelay.order = Int16(order)
                    newObjDelay.type = "days3"
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjDelay)
                        order += 1
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
                
                newObject.delays = NSSet(array: arr)
                newObject.arrTimeDelay = historicalDelays.days3.arrTimeDelay
                newObject.arrTimeDelayWX = historicalDelays.days3.arrTimeDelayWX
                newObject.eta = historicalDelays.days3.eta
                newObject.ymax = historicalDelays.days3.ymax
                newObject.type = "days3"
                try service.container.viewContext.save()
            
                // For Week1
                let newObject1 = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject1.id = UUID()
                var arr1 = [HistorycalDelaysRefList]()
                var order2 = 1
                
                historicalDelays.week1.delays.forEach { item in
                    let newObjDelay = HistorycalDelaysRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.condition = item.condition
                    newObjDelay.time = item.time
                    newObjDelay.delay = item.delay
                    newObjDelay.order = Int16(order2)
                    newObjDelay.type = "week1"
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjDelay)
                        order2 += 1
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
                    
                newObject1.delays = NSSet(array: arr1)
                newObject1.arrTimeDelay = historicalDelays.week1.arrTimeDelay
                newObject1.arrTimeDelayWX = historicalDelays.week1.arrTimeDelayWX
                newObject1.eta = historicalDelays.week1.eta
                newObject1.ymax = historicalDelays.week1.ymax
                newObject1.type = "week1"
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
            
                // For Months3
                let newObject2 = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject2.id = UUID()
                var arr2 = [HistorycalDelaysRefList]()
                var order3 = 1
                historicalDelays.months3.delays.forEach { item in
                    let newObjDelay = HistorycalDelaysRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.condition = item.condition
                    newObjDelay.time = item.time
                    newObjDelay.delay = item.delay
                    newObjDelay.order = Int16(order3)
                    newObjDelay.type = "months3"
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjDelay)
                        order3 += 1
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
                
                newObject2.delays = NSSet(array: arr2)
                newObject2.arrTimeDelay = historicalDelays.months3.arrTimeDelay
                newObject2.arrTimeDelayWX = historicalDelays.months3.arrTimeDelayWX
                newObject2.eta = historicalDelays.months3.eta
                newObject2.ymax = historicalDelays.months3.ymax
                newObject2.type = "months3"
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
                
                readHistoricalDelays()
                print("saved successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save Historical Delays: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
            }
        }
    }
    
    func readProjDelays() {
        let request: NSFetchRequest<ProjDelaysList> = ProjDelaysList.fetchRequest()
        do {
            let response: [ProjDelaysList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataProjDelays = item
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initProjDelays(_ projDelays: IProjDelaysModel) {
        service.container.viewContext.performAndWait {
            do {
                let newObject = ProjDelaysList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [ProjDelaysListRef]()
                
                var order = 1
                projDelays.delays.forEach { item in
                    let newObjDelay = ProjDelaysListRef(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.time = item.time
                    newObjDelay.delay = Int(item.delay)
                    newObjDelay.mindelay = Int(item.mindelay)
                    newObjDelay.maxdelay = Int(item.maxdelay)
                    newObjDelay.order = Int16(order)
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjDelay)
                        order += 1
                        print("saved Proj Delays successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save Proj Delays: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
                
                newObject.delays = NSSet(array: arr)
                newObject.expectedDelay = Int(projDelays.expectedDelay)
                newObject.eta = projDelays.eta
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
                
                readProjDelays()
                print("saved Proj Delays successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save Proj Delays: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
        }
    }
    
    func readProjTaxi() {
        let request: NSFetchRequest<FuelTaxiList> = FuelTaxiList.fetchRequest()
        do {
            let response: [FuelTaxiList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                dataProjTaxi = response
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initProjTaxi(_ data: ITaxiModel) {
        do {
            let newObject = FuelTaxiList(context: self.service.container.viewContext)
            newObject.id = UUID()
            var arr = [FuelTaxiRefList]()
            var order = 1
            
            data.flights3.times.forEach { item in
                let newObjRef = FuelTaxiRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.taxiTime = item.taxiTime
                newObjRef.order = Int16(order)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr.append(newObjRef)
                    order += 1
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject.times = NSSet(array: arr)
            newObject.aveTime = data.flights3.aveTime
            newObject.aveDiff = data.flights3.aveDiff
            newObject.ymax = data.flights3.ymax
            newObject.type = "flights3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            // For week1
            let newObject1 = FuelTaxiList(context: self.service.container.viewContext)
            newObject1.id = UUID()
            var arr1 = [FuelTaxiRefList]()
            var order1 = 1
            
            data.week1.times.forEach { item in
                let newObjRef = FuelTaxiRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.taxiTime = item.taxiTime
                newObjRef.order = Int16(order1)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr1.append(newObjRef)
                    order1 += 1
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject1.times = NSSet(array: arr1)
            newObject1.aveTime = data.week1.aveTime
            newObject1.aveDiff = data.week1.aveDiff
            newObject1.ymax = data.week1.ymax
            newObject1.type = "week1"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            
            // For Month3
            let newObject2 = FuelTaxiList(context: self.service.container.viewContext)
            newObject2.id = UUID()
            var arr2 = [FuelTaxiRefList]()
            var order2 = 1
            
            data.months3.times.forEach { item in
                let newObjRef = FuelTaxiRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.taxiTime = item.taxiTime
                newObjRef.order = Int16(order2)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr2.append(newObjRef)
                    order2 += 1
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Taxi Month3: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject2.times = NSSet(array: arr2)
            newObject2.aveTime = data.months3.aveTime
            newObject2.aveDiff = data.months3.aveDiff
            newObject2.ymax = data.months3.ymax
            newObject2.type = "months3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            print("saved taxi successfully")
            
            readProjTaxi()
        } catch {
            // Something went wrong 😭
            print("Failed to save Taxi: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func readTrackMiles() {
        let request: NSFetchRequest<FuelTrackMilesList> = FuelTrackMilesList.fetchRequest()
        do {
            let response: [FuelTrackMilesList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                dataTrackMiles = response
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initTrackMiles(_ data: ITrackMilesModel) {
        do {
            let newObject = FuelTrackMilesList(context: self.service.container.viewContext)
            newObject.id = UUID()
            var arr = [FuelTrackMilesRefList]()
            var order = 1
            
            data.flights3.trackMiles.forEach { item in
                let newObjDelay = FuelTrackMilesRefList(context: self.service.container.viewContext)
                newObjDelay.id = UUID()
                newObjDelay.phase = item.phase
                newObjDelay.condition = item.condition
                newObjDelay.trackMilesDiff = item.trackMilesDiff
                newObjDelay.order = Int16(order)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr.append(newObjDelay)
                    order += 1
                    print("saved Track Miles Flight3 successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Track Miles Flight3: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject.trackMiles = NSSet(array: arr)
            newObject.sumNM = data.flights3.sumNM
            newObject.sumMINS = data.flights3.sumMINS
            newObject.type = "flights3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            // For week1
            let newObject1 = FuelTrackMilesList(context: self.service.container.viewContext)
            newObject1.id = UUID()
            var arr1 = [FuelTrackMilesRefList]()
            var order1 = 1
            
            data.week1.trackMiles.forEach { item in
                let newObjRef = FuelTrackMilesRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.phase = item.phase
                newObjRef.condition = item.condition
                newObjRef.trackMilesDiff = item.trackMilesDiff
                newObjRef.order = Int16(order1)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr1.append(newObjRef)
                    order1 += 1
                    print("saved successfully Track Mile Week1 Ref")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Track Mile Week1 Ref: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject1.trackMiles = NSSet(array: arr1)
            newObject1.sumNM = data.week1.sumNM
            newObject1.sumMINS = data.week1.sumMINS
            newObject1.type = "week1"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            
            // For Month3
            let newObject2 = FuelTrackMilesList(context: self.service.container.viewContext)
            newObject2.id = UUID()
            var arr2 = [FuelTrackMilesRefList]()
            var order2 = 1
            
            data.months3.trackMiles.forEach { item in
                let newObjRef = FuelTrackMilesRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.phase = item.phase
                newObjRef.condition = item.condition
                newObjRef.trackMilesDiff = item.trackMilesDiff
                newObjRef.order = Int16(order2)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr2.append(newObjRef)
                    order2 += 1
                    print("saved Track Mile Ref Month1 successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Track Mile Ref Month1: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject2.trackMiles = NSSet(array: arr2)
            newObject2.sumNM = data.months3.sumNM
            newObject2.sumMINS = data.months3.sumMINS
            newObject2.type = "months3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            print("saved Track Miles Month3 successfully")
            
            readTrackMiles()
        } catch {
            // Something went wrong 😭
            print("Failed to Track Miles: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func readEnrWX() {
        let request: NSFetchRequest<FuelEnrWXList> = FuelEnrWXList.fetchRequest()
        do {
            let response: [FuelEnrWXList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                dataEnrWX = response
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initEnrWX(_ data: IEnrWXModel) {
        do {
            let newObject = FuelEnrWXList(context: self.service.container.viewContext)
            newObject.id = UUID()
            var arr = [FuelEnrWXRefList]()
            var order = 1
            
            data.flights3.trackMiles.forEach { item in
                let newObjRef = FuelEnrWXRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.trackMilesDiff = item.trackMilesDiff
                newObjRef.order = Int16(order)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr.append(newObjRef)
                    order += 1
                    print("saved Enr WX successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Track Miles Flight3: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject.trackMiles = NSSet(array: arr)
            newObject.aveNM = data.flights3.aveNM
            newObject.aveMINS = data.flights3.aveMINS
            newObject.type = "flights3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            // For week1
            let newObject1 = FuelEnrWXList(context: self.service.container.viewContext)
            newObject1.id = UUID()
            var arr1 = [FuelEnrWXRefList]()
            var order1 = 1
            
            data.week1.trackMiles.forEach { item in
                let newObjRef = FuelEnrWXRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.trackMilesDiff = item.trackMilesDiff
                newObjRef.order = Int16(order1)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr1.append(newObjRef)
                    order1 += 1
                    print("saved successfully Enr WX Week1 Ref")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Enr WX Week1 Ref: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject1.trackMiles = NSSet(array: arr1)
            newObject1.aveNM = data.week1.aveNM
            newObject1.aveMINS = data.week1.aveMINS
            newObject1.type = "week1"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            
            // For Month3
            let newObject2 = FuelEnrWXList(context: self.service.container.viewContext)
            newObject2.id = UUID()
            var arr2 = [FuelEnrWXRefList]()
            var order2 = 1
            
            data.months3.trackMiles.forEach { item in
                let newObjRef = FuelEnrWXRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.trackMilesDiff = item.trackMilesDiff
                newObjRef.order = Int16(order2)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr2.append(newObjRef)
                    print("saved Enr WX Ref Month1 successfully")
                    order2 += 1
                } catch {
                    // Something went wrong 😭
                    print("Failed to save Enr WX Ref Month1: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject2.trackMiles = NSSet(array: arr2)
            newObject2.aveNM = data.months3.aveNM
            newObject2.aveMINS = data.months3.aveMINS
            newObject2.type = "months3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            print("saved Enr WX Month3 successfully")
            
            readEnrWX()
        } catch {
            // Something went wrong 😭
            print("Failed to Track Miles: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func readFlightLevel() {
        let request: NSFetchRequest<FuelFlightLevelList> = FuelFlightLevelList.fetchRequest()
        do {
            let response: [FuelFlightLevelList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                dataFlightLevel = response
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initFlightLevel(_ data: IFlightLevelModel) {
        do {
            let newObject = FuelFlightLevelList(context: self.service.container.viewContext)
            newObject.id = UUID()
            var arr = [FuelFlightLevelRefList]()
            var order = 1
            
            data.flights3.flightLevels.forEach { item in
                let newObjRef = FuelFlightLevelRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.waypoint = item.waypoint
                newObjRef.condition = item.condition
                newObjRef.flightLevel = item.flightLevel
                newObjRef.order = Int16(order)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr.append(newObjRef)
                    order += 1
                    print("saved Flight Level flight3 successfully")
                } catch {
                    print("Failed to save Flight Level flight3: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject.flightLevels = NSSet(array: arr)
            newObject.aveDiff = data.flights3.aveDiff
            newObject.type = "flights3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            // For week1
            let newObject1 = FuelFlightLevelList(context: self.service.container.viewContext)
            newObject1.id = UUID()
            var arr1 = [FuelFlightLevelRefList]()
            var order1 = 1
            
            data.week1.flightLevels.forEach { item in
                let newObjRef = FuelFlightLevelRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.waypoint = item.waypoint
                newObjRef.condition = item.condition
                newObjRef.flightLevel = item.flightLevel
                newObjRef.order = Int16(order1)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr1.append(newObjRef)
                    order1 += 1
                    print("saved Flight Level flight3 successfully")
                } catch {
                    print("Failed to save Flight Week1 flight3: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject1.flightLevels = NSSet(array: arr1)
            newObject1.aveDiff = data.week1.aveDiff
            newObject1.type = "week1"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            
            // For Month3
            let newObject2 = FuelFlightLevelList(context: self.service.container.viewContext)
            newObject2.id = UUID()
            var arr2 = [FuelFlightLevelRefList]()
            var order2 = 1
            
            data.months3.flightLevels.forEach { item in
                let newObjRef = FuelFlightLevelRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.waypoint = item.waypoint
                newObjRef.condition = item.condition
                newObjRef.flightLevel = item.flightLevel
                newObjRef.order = Int16(order2)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr2.append(newObjRef)
                    order2 += 1
                    print("saved Flight Level flight3 successfully")
                } catch {
                    print("Failed to save Flight Month1: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject2.flightLevels = NSSet(array: arr2)
            newObject2.aveDiff = data.months3.aveDiff
            newObject2.type = "months3"
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            print("saved Flight Level Month3 successfully")
            
            readFlightLevel()
        } catch {
            print("Failed to Flight Level: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func readReciprocalRwy() {
        let request: NSFetchRequest<FuelReciprocalRwyList> = FuelReciprocalRwyList.fetchRequest()
        do {
            let response: [FuelReciprocalRwyList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                dataReciprocalRwy = response.first!
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func initReciprocalRwy(_ data: IReciprocalRwyModel) {
        do {
            let newObject = FuelReciprocalRwyList(context: self.service.container.viewContext)
            newObject.id = UUID()
            var arr = [FuelReciprocalRwyRefList]()
            var order = 1
            
            data.trackMiles.forEach { item in
                let newObjRef = FuelReciprocalRwyRefList(context: self.service.container.viewContext)
                newObjRef.id = UUID()
                newObjRef.date = item.date
                newObjRef.condition = item.condition
                newObjRef.trackMilesDiff = item.trackMilesDiff
                newObjRef.order = Int16(order)
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    arr.append(newObjRef)
                    order += 1
                    print("saved Reciprocal Rwy Ref flight3 successfully")
                } catch {
                    print("Failed to save Reciprocal Rwy flight3: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            
            newObject.trackMiles = NSSet(array: arr)
            newObject.aveNM = data.aveNM
            newObject.aveMINS = data.aveMINS
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            
            print("saved Reciprocal Rwy successfully")
            
            readReciprocalRwy()
        } catch {
            print("Failed to Flight Level: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func updateFlightPlan() {
        Task {
            // do your job here
            
            let summaryPageData = [
                "pob": dataSummaryInfo.pob ?? "",
                "perActualZFW": dataFlightPlan?.perActualZFW ?? "",
                "perActualTOW": dataFlightPlan?.perActualTOW ?? "",
                "perActualLDW": dataFlightPlan?.perActualLDW ?? "",
                "includedArrDelays": dataFuelExtra.includedArrDelays,
                "includedFlightLevel": dataFuelExtra.includedFlightLevel,
                "includedEnrWx": dataFuelExtra.includedEnrWx,
                "includedReciprocalRwy": dataFuelExtra.includedReciprocalRwy,
                "includedTaxi": dataFuelExtra.includedTaxi,
                "includedTrackShortening": dataFuelExtra.includedTrackShortening,
                "includedZFWchange": dataFuelExtra.includedZFWchange,
                "includedOthers": dataFuelExtra.includedOthers,
                "selectedArrDelays": dataFuelExtra.selectedArrDelays,
                "selectedTaxi": dataFuelExtra.selectedTaxi,
                "selectedTrackShortening": dataFuelExtra.selectedTrackShortening,
                "selectedFlightLevel000": dataFuelExtra.selectedFlightLevel000,
                "selectedFlightLevel00": dataFuelExtra.selectedFlightLevel00,
                "selectedEnrWx": dataFuelExtra.selectedEnrWx,
                "selectedReciprocalRwy": dataFuelExtra.selectedReciprocalRwy,
                "selectedOthers000": dataFuelExtra.selectedOthers000,
                "selectedOthers00": dataFuelExtra.selectedOthers00,
                "remarkArrDelays": dataFuelExtra.remarkArrDelays ?? "",
                "remarkTaxi": dataFuelExtra.remarkTaxi ?? "",
                "remarkFlightLevel": dataFuelExtra.remarkFlightLevel ?? "",
                "remarkTrackShortening": dataFuelExtra.remarkTrackShortening,
                "remarkEnrWx": dataFuelExtra.remarkEnrWx,
                "remarkReciprocalRwy": dataFuelExtra.remarkReciprocalRwy,
                "remarkZFWChange": dataFuelExtra.remarkZFWChange,
                "remarkOthers": dataFuelExtra.remarkOthers
            ]
            
            let departurePageData = [
                "atis": [
                    "code": dataDepartureAtis.unwrappedCode,
                    "time": dataDepartureAtis.unwrappedTime,
                    "rwy": dataDepartureAtis.unwrappedRwy,
                    "translvl": dataDepartureAtis.unwrappedRranslvl,
                    "wind": dataDepartureAtis.unwrappedWind,
                    "vis": dataDepartureAtis.unwrappedVis,
                    "wx": dataDepartureAtis.unwrappedWx,
                    "cloud": dataDepartureAtis.unwrappedCloud,
                    "temp": dataDepartureAtis.unwrappedTemp,
                    "dp": dataDepartureAtis.unwrappedDp,
                    "qnh": dataDepartureAtis.unwrappedQnh,
                    "remarks": dataDepartureAtis.unwrappedRemarks
                ],
                "atc": [
                    "atcDep": dataDepartureAtc.unwrappedAtcDep,
                    "atcSQ": dataDepartureAtc.unwrappedAtcSQ,
                    "atcRte": dataDepartureAtc.unwrappedAtcRte,
                    "atcFL": dataDepartureAtc.unwrappedAtcFL,
                    "atcRwy": dataDepartureAtc.unwrappedAtcRwy
                ],
                "entries": [
                    "entOff": dataDepartureEntries.unwrappedEntOff,
                    "entFuelInTanks": dataDepartureEntries.unwrappedEntFuelInTanks,
                    "entTaxi": dataDepartureEntries.unwrappedEntTaxi,
                    "entTakeoff": dataDepartureEntries.unwrappedEntTakeoff
                ]
            ]
            
            var enroutePageData = []
            
            dataFPEnroute.forEach { item in
                enroutePageData.append([
                    "Cord": item.unwrappedCord,
                    "Diff": item.unwrappedDiff,
                    "Dis": item.unwrappedDis,
                    "Drm": item.unwrappedDrm,
                    "Gsp": item.unwrappedGsp,
                    "Imt": item.unwrappedImt,
                    "Msa": item.unwrappedMsa,
                    "Pdn": item.unwrappedPdn,
                    "Pfl": item.unwrappedPfl,
                    "Pfrm": item.unwrappedPfrm,
                    "aWind": item.unwrappedAwind,
                    "actm": item.unwrappedActm,
                    "adn": item.unwrappedAdn,
                    "afl": item.unwrappedAfl,
                    "afrm": item.unwrappedAfrm,
                    "ata": item.unwrappedAta,
                    "eta": item.unwrappedEta,
                    "fDiff": item.unwrappedFdiff,
                    "fWind": item.unwrappedFwind,
                    "oat": item.unwrappedOat,
                    "posn": item.unwrappedPosn,
                    "tas": item.unwrappedTas,
                    "vws": item.unwrappedVws,
                    "zfrq": item.unwrappedZfrq,
                    "ztm": item.unwrappedZtm
                ])
            }
            
            let arrivalPageData = [
                "atis": [
                    "code": dataArrivalAtis.unwrappedCode,
                    "time": dataArrivalAtis.unwrappedTime,
                    "rwy": dataArrivalAtis.unwrappedRwy,
                    "translvl": dataArrivalAtis.unwrappedTransLvl,
                    "wind": dataArrivalAtis.unwrappedWind,
                    "vis": dataArrivalAtis.unwrappedVis,
                    "wx": dataArrivalAtis.unwrappedWx,
                    "cloud": dataArrivalAtis.unwrappedCloud,
                    "temp": dataArrivalAtis.unwrappedTemp,
                    "dp": dataArrivalAtis.unwrappedDp,
                    "qnh": dataArrivalAtis.unwrappedQnh,
                    "remarks": dataArrivalAtis.unwrappedRemarks
                ],
                "atc": [
                    "atcDest": dataArrivalAtc.unwrappedAtcDest,
                    "atcRwy": dataArrivalAtc.unwrappedAtcRwy,
                    "atcArr": dataArrivalAtc.unwrappedAtcArr,
                    "atcTransLvl": dataArrivalAtc.unwrappedAtcTransLvl
                ],
                "entries": [
                    "entLdg": dataArrivalEntries.unwrappedEntLdg,
                    "entFuelOnChocks": dataArrivalEntries.unwrappedEntFuelOnChocks,
                    "entOn": dataArrivalEntries.unwrappedEntOn
                ]
            ]
            
            let payload = [
                "company": "Test Company",
                "fltno": dataSummaryInfo.unwrappedPlanNo,
                "flightDate": dataSummaryInfo.unwrappedFlightDate,
                "summaryPageData": summaryPageData,
                "departurePageData": departurePageData,
                "enroutePageData": enroutePageData,
                "arrivalPageData": arrivalPageData
            ]
            
            await self.remoteService.updateFuelData(payload, completion: { success in
                if(success) {
                    self.isUpdating = false
                }
            })
        }
    }
    
    
    // Update data for Flight Plan Enroute textfield
    private func updateValues(_ editedIndex: Int = 0, _ data: [EnrouteList]) {
        let dataOriginal = data
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HHmm"
        
        // define the T_O_C index
        var tocIndex: Int {
            for (index, row) in data.enumerated() {
                if row.unwrappedPosn == "T_O_C" {
                    return index
                }
            }
            return 0
        }
        
        let startIndex = editedIndex + 1
        for index in startIndex..<data.count {
            //eta
            let etaDefaultValue = dateFormatterTime.date(from: dataOriginal[index].unwrappedEta)!
            if dateFormatterTime.date(from: data[index].eta!) != nil {
                // Update the value based on the previous row's value in column
                if dateFormatterTime.date(from: data[index-1].unwrappedEta) != nil {
                    let etaPreviousRowValue = dateFormatterTime.date(from: data[index-1].unwrappedEta)!
                    let ztmString = data[index].ztm
                    let components = ztmString!.components(separatedBy: ":")
                    let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                    let NewValue = etaPreviousRowValue.addingTimeInterval(TimeInterval(ztm))
                    data[index].eta = dateFormatterTime.string(from: NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                data[index].eta = dateFormatterTime.string(from: etaDefaultValue)
            }
            
            //ata
            let ataDefaultValue = dateFormatterTime.date(from: dataOriginal[index].unwrappedAta)!
            if dateFormatterTime.date(from: data[index].unwrappedAta) != nil {
                // Update the value based on the previous row's value in column
                var ataPreviousRowValue = dateFormatterTime.date(from: "0000")
                
                if data[index-1].unwrappedAta != "" {
                    ataPreviousRowValue = dateFormatterTime.date(from: data[index-1].unwrappedAta)
                }
                
                let ztmString = data[index].unwrappedZtm
                let components = ztmString.components(separatedBy: ":")
                let ztm = (Int(components[0])! * 3600) + (Int(components[1])! * 60)
                if let NewValue = ataPreviousRowValue?.addingTimeInterval(TimeInterval(ztm)) {
                    data[index].ata = dateFormatterTime.string(from: NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                data[index].ata = dateFormatterTime.string(from: ataDefaultValue)
            }
            
            //afl
            let aflDefaultValue = dataOriginal[index].unwrappedAfl
            if index <= tocIndex {
                // Set the default value if waypoint is before TOC
                data[index].afl = aflDefaultValue
            }
            else {
                // Update the value based on the previous row's value in column
                let aflPreviousRowValue = data[index-1].unwrappedAfl
                let NewValue = aflPreviousRowValue
                data[index].afl = NewValue
            }
            
            //oat
            let oatDefaultValue = dataOriginal[index].unwrappedOat
            if index <= tocIndex {
                // Set the default value if waypoint is before TOC
                data[index].oat = oatDefaultValue
            }
            else {
                // Update the value based on the previous row's value in column
                let oatPreviousRowValue = data[index-1].unwrappedOat
                let NewValue = oatPreviousRowValue
                data[index].oat = NewValue
            }
            
            //awind
            let aWindDefaultValue = dataOriginal[index].unwrappedAwind
            if index <= tocIndex {
                // Set the default value if waypoint is before TOC
                data[index].awind = aWindDefaultValue
            }
            else {
                // Update the value based on the previous row's value in column
                let aWindPreviousRowValue = data[index-1].unwrappedAwind
                let NewValue = aWindPreviousRowValue
                data[index].awind = NewValue
            }
            
            //afrm
            let afrmDefaultValue = Double(dataOriginal[index].unwrappedAfrm)
            if Double(data[index].unwrappedAfrm) != nil {
                // Update the value based on the previous row's value in column
                let afrmPreviousRowValue = Double(data[index-1].unwrappedAfrm)
                let zfrq = Double(data[index].unwrappedZfrq) ?? 0
                var NewValue = zfrq
                
                if afrmPreviousRowValue != nil {
                    NewValue = afrmPreviousRowValue! - zfrq
                }
                data[index].afrm = formatFuelNumberDouble(NewValue)
            }
            else {
                // Set the default value if it exists and currentValue is nil
                data[index].afrm = formatFuelNumberDouble(afrmDefaultValue ?? 0)
            }
        }
        
        for index in editedIndex..<data.count {
            //diff
            let diffDefaultValue = dataOriginal[index].unwrappedDiff
            if dateFormatterTime.date(from: data[index].unwrappedEta) != nil &&  dateFormatterTime.date(from: data[index].unwrappedEta) != nil {
                var eta = 0
                if data[index].unwrappedEta != "" {
                    let etaMins = data[index].unwrappedEta.suffix(2)
                    let etaHrs = data[index].unwrappedEta.prefix(2)
                    eta = Int(etaHrs)! * 60 + Int(etaMins)!
                }
                // Update the value based on the eta and ata
                let ataMins = data[index].unwrappedAta.suffix(2)
                let ataHrs = data[index].unwrappedAta.prefix(2)
                var ata = ataMins != "" ? Int(ataMins)! : 0
                
                if ataHrs != "" {
                    ata = Int(ataHrs)! * 60 + ata
                }
                
                var NewValue = ata - eta
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    let NewValueString = formatTime(NewValue)
                    data[index].diff = "-"+NewValueString
                } else {
                    let NewValueString = formatTime(NewValue)
                    data[index].diff = "+"+NewValueString
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                data[index].diff = diffDefaultValue
            }
            
            //fDiff
            let fDiffDefaultValue = Double(dataOriginal[index].unwrappedFdiff)
            if Double(data[index].unwrappedFdiff) != nil {
                // Update the value based on the previous row's value in column
                let afrm = Double(data[index].unwrappedAfrm) ?? 0
                let pfrm = Double(data[index].unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    data[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    data[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                data[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
        }
        
        for index in editedIndex..<data.count {
            //fDiff
            let fDiffDefaultValue = Double(dataOriginal[index].unwrappedFdiff)
            if Double(data[index].unwrappedFdiff) != nil {
                // Update the value based on the previous row's value in column
                let afrm = Double(data[index].unwrappedAfrm) ?? 0
                let pfrm = Double(data[index].unwrappedPfrm) ?? 0
                var NewValue = afrm - pfrm
                if NewValue < 0 {
                    NewValue = NewValue * -1
                    data[index].fdiff = "-"+formatFuelNumberDouble(NewValue)
                } else {
                    data[index].fdiff = "+"+formatFuelNumberDouble(NewValue)
                }
            }
            else {
                // Set the default value if it exists and currentValue is nil
                data[index].fdiff = formatFuelNumberDouble(fDiffDefaultValue ?? 0)
            }
        }
        do {
            // sync up with coreData, update data enroute
            try service.container.viewContext.save()
            dataFPEnroute = readEnrouteList()
        } catch {
            print("Error Update Enroute value")
        }
    }
    
    func formatFuelNumberDouble(_ number: Double) -> String {
        let formattedString = String(format: "%05.1f", number)
        return formattedString
    }
    func formatTime(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let date = Calendar.current.date(bySettingHour: hours, minute: mins, second: 0, of: Date()) ?? Date()
        
        return formatter.string(from: date)
    }
    
    func readAISearch(target: Bool = false) -> [AISearchList] {
        var data: [AISearchList] = []
        
        let request: NSFetchRequest<AISearchList> = AISearchList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        if target {
            request.predicate = NSPredicate(format: "isFavorite == 1")
        }
        
        do {
            let response: [AISearchList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch AISearch from Core Data.")
        }
        
        return data
    }
    
    func readEvents() -> [EventList] {
        var data: [EventList] = []
        
        let request: NSFetchRequest<EventList> = EventList.fetchRequest()
        
        do {
            let response: [EventList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Event from Core Data.")
        }
        
        return data
    }
    
    func readEventsByStatus(status: String = "1") -> [EventList] {
        var data: [EventList] = []
        
        let request: NSFetchRequest<EventList> = EventList.fetchRequest()
        
        do {
            request.predicate = NSPredicate(format: "status == %@", status)
            let response: [EventList] = try service.container.viewContext.fetch(request)
            
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Event from Core Data.")
        }
        
        return data
    }
    
    func loadImage(for urlString: String) {
        self.imageLoading = true
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                self.imageLoading = false
            }
        }
        task.resume()
    }
    
    func findOneAabba(name: String = "") -> AabbaMapList? {
        var data: AabbaMapList?
        
        let request: NSFetchRequest<AabbaMapList> = AabbaMapList.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let response: [AabbaMapList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch AISearch from Core Data.")
        }
        
        return data
    }
    
    func prepareDataPostPreflight(_ data: [NoteAabbaPostList]) -> (postList: [NotePostList], postListRef :[NotePostList]) {
        var postList = [NotePostList]()
        var postListRef = [NotePostList]()
        
        if data.count > 0, let firstItem = data.first {
            if let posts = firstItem.posts?.allObjects as? [NotePostList] {
                for item in posts {
                    if item.type == "preflight" {
                        postList.append(item)
                    }
                    
                    if item.type == "preflightref" {
                        postListRef.append(item)
                    }
                }
            }
        }
        
        return (postList: postList, postListRef: postListRef)
    }
    
    func deleteAllTrafficMap() async {
        let fetchRequest: NSFetchRequest<TrafficMapList>
        fetchRequest = TrafficMapList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Traffic Map update: \(error)")
        }
    }
    
    func deleteAllAabbaCommentList() async {
        let fetchRequest: NSFetchRequest<AabbaCommentList>
        fetchRequest = AabbaCommentList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Traffic Map update: \(error)")
        }
    }
    
    func deleteAllAabbaPostList() async {
        let fetchRequest: NSFetchRequest<AabbaPostList>
        fetchRequest = AabbaPostList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Traffic Map update: \(error)")
        }
    }
    
    func deleteAllAabbMapList() async {
        let fetchRequest: NSFetchRequest<AabbaMapList>
        fetchRequest = AabbaMapList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Traffic Map update: \(error)")
        }
    }
    
    func deleteAllWaypointList() async {
        let fetchRequest: NSFetchRequest<WaypointMapList>
        fetchRequest = WaypointMapList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Traffic Map update: \(error)")
        }
    }
    
    func deleteAllAirportList() async {
        let fetchRequest: NSFetchRequest<AirportMapList>
        fetchRequest = AirportMapList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Altn Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Traffic Map update: \(error)")
        }
    }
    
    func deleteAllMetaTaf() async {
        let fetchRequest: NSFetchRequest<MetarTafDataList>
        fetchRequest = MetarTafDataList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Metar Taf : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Metar Taf update: \(error)")
        }
    }
    
    func deleteAllNotam() async {
        let fetchRequest: NSFetchRequest<NotamsDataList>
        fetchRequest = NotamsDataList.fetchRequest()
        do {
            // Perform the fetch request
            let objects = try service.container.viewContext.fetch(fetchRequest)
            
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Notam : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Notam update: \(error)")
        }
    }
    
    func extractExpiringDocuments(expiryData: [RecencyExpiryList], monthsAhead: Int) -> [DocumentExpiry] {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Get the current date
        let currentDate = Date()
        
        // Calculate the date 6 months from now
        if let sixMonthsFromNow = Calendar.current.date(byAdding: .month, value: monthsAhead, to: currentDate) {
            // Create an array to store expiring documents
            var expiringDocuments: [DocumentExpiry] = []
            // Iterate through each document in the expiry data
            for row in expiryData {
                if let expiryDate = dateFormatter.date(from: row.expiredDate!) {
                    // Check if the expiry date is within the next 6 months
                    if expiryDate <= sixMonthsFromNow {
                        let documentExpiry = DocumentExpiry(id: UUID().uuidString,
                                                            type: row.unwrappedName,
                                                            expiryDate: dateFormatter.string(from: expiryDate))
                        expiringDocuments.append(documentExpiry)
                    }
                }
            }
            
            return expiringDocuments
        }
        
        return []
    }
}
