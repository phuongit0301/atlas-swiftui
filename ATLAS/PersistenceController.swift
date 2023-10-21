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
    @AppStorage("isBoardingCompleted") var isBoardingCompleted: String = ""
    @AppStorage("uid") var userID: String = ""
    
    @Published var loading: Bool = true
    @Published var loadingInit: Bool = false
    @Published var loadingInitFuel: Bool = false
    @Published var tagList: [TagList] = []
    @Published var tagListCabinDefects: [CabinDefectModel] = []
    @Published var tagListWeather: [CabinDefectModel] = []
    @Published var dataNoteList: [NoteList] = []
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
    
    @Published var dataNoteAabba: [NoteAabbaPostList] = []
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
    
    @Published var dataFlightOverview: FlightOverviewList?
    @Published var dataFlightOverviewList: [FlightOverviewList] = []
    @Published var dataEvents: [EventList] = []
    @Published var dataEventDateRange: [EventDateRangeList] = []
    
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
    @Published var enrAirportNotam: [String: String] = [:]
    @Published var destAirportNotam: [String: String] = [:]
    @Published var depAirportNotam: [String: String] = [:]
    @Published var arrAirportNotam: [String: String] = [:]
    
    @Published var enrNotamClipboard = [String: [NotamsDataList]]()
    @Published var destNotamClipboard = [String: [NotamsDataList]]()
    @Published var depNotamClipboard = [String: [NotamsDataList]]()
    @Published var arrNotamClipboard = [String: [NotamsDataList]]()
    
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
    
    @Published var dataMetarTaf: [MetarTafDataList] = []
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
    
    @Published var dataSectionDateUpdate: SectionDateUpdateList?
    
    // For Fuel Chart
    @Published var dataProjDelays: ProjDelaysList?
    @Published var dataHistoricalDelays: [HistoricalDelaysList] = []
    @Published var dataProjTaxi: [FuelTaxiList] = []
    @Published var dataTrackFlown: [FuelTrackFlownList] = []
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
    @Published var dataRouteMap = [MapRouteList]()
    
    // For Logbook
    @Published var dataLogbookLimitation = [LogbookLimitationList]()
    @Published var dataLogbookEntries = [LogbookEntriesList]()
    
    // For Recency
    let monthsAhead = 6
    @Published var dataExpiringSoon = [DocumentExpiry]()
    @Published var dataRecency = [RecencyList]()
    @Published var dataRecencyExpiry = [RecencyExpiryList]()
    @Published var dataRecencyDocument = [RecencyDocumentList]()
    @Published var dataRecencyExperience = [RecencyExperienceList]()
    
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
    
    @Published var isCalendarLoading = false
    @Published var isLogbookEntriesLoading = false
    @Published var isLogbookLimitationLoading = false
    @Published var isRecencyLoading = false
    @Published var isRecencyExpiryLoading = false
    
    
    // For Signature
    @Published var dataSignature: SignatureList?
    
    // For event
    @Published var selectedEvent: EventList?
    @Published var isEventActive = false
    
    @Published var selectedSidebar: EventList?
    
    // For User Profile
    @Published var dataUser: UserProfileList?
    
    @Published var isLoginLoading = false
    @Published var isTrafficLoading = false
    @Published var isMapAabbaLoading = false
    @Published var isMapWaypointLoading = false
    @Published var isMapAirportLoading = false
    @Published var isAabbaNoteLoading = false
    @Published var isNotamLoading = false
    
    
    // For autocomplete
    @Published var listRoutes = [String]()
    
    let dateFormatter = DateFormatter()
    
    init() {
        
    }
    
    @MainActor
    func checkAndSyncData() async {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dataEvents = readEvents()
        
        self.loadingInit = true
        Task {
//            async let calendarService = remoteService.getCalendarData()
//            async let flightPlanService = remoteService.getFlightPlanDataV3()
            async let logbookService = remoteService.getLogbookData()
            async let limitationService = remoteService.getLimitationData()
            async let recencyService = remoteService.getRecencyData()
            
            //array handle call API parallel
            let (responseLogbook, responseLimitation, responseRecency) = await (logbookService, limitationService, recencyService)
            
            
            print("sync after signup")
            DispatchQueue.main.async {
                // Init Logbook
                if let logbookEntry = responseLogbook?.logbook_data {
                    self.initDataLogbookEntries(logbookEntry)
                }
                
                if let limitationData = responseLimitation?.limitation_data {
                    self.initDataLogbookLimitation(limitationData)
                }
                
                if let responseRecency = responseRecency {
                    // Init data recency
                    self.initDataRecency(responseRecency.recency_data)
                    
                    self.initDataRecencyExpiry(responseRecency.expiry_data)
                }
                
                self.isBoardingCompleted = ""
                
                self.loadingInit = false
                print("Fetch data")
            }
        }
    }
    
    @MainActor
    func checkAndSyncOrPostData() async {
        await withTaskGroup(of: Void.self) { group in
            self.dataExpiringSoon = self.extractExpiringDocuments(expiryData: self.dataRecencyDocument, monthsAhead: self.monthsAhead)
            self.dataEvents = self.readEvents()
            self.dataEventDateRange = self.readEventDateRange()
            self.dataLogbookEntries = readDataLogbookEntries()
            self.dataLogbookLimitation = readDataLogbookLimitation()
            self.dataRecency = readDataRecency()
            self.dataRecencyExpiry = readDataRecencyExpiry()
            self.dataRecencyDocument = readDataRecencyDocument()
            // For Flight Overview
            // NoteList
            self.dataNoteList = self.readNoteList()
            
            self.dataAirportColorMap = readDataAirportMapColorList()
            
            self.dataRouteMap = readDataRouteMapList()
            
            self.dataNotams = readDataNotamsList()
            
            self.dataMetarTaf = readDataMetarTafList()
            
            self.dataNoteAabba = readDataNoteAabbaPostList("")
            self.dataNoteAabbaPreflight = readDataNoteAabbaPostList("preflight")
            self.dataNoteAabbaDeparture = readDataNoteAabbaPostList("departure")
            self.dataNoteAabbaEnroute = readDataNoteAabbaPostList("enroute")
            self.dataNoteAabbaArrival = readDataNoteAabbaPostList("arrival")
            self.dataFlightOverviewList = readFlightOverviewList()
            
            group.addTask {
                await self.getOrPostEvent()
            }
            
            group.addTask {
                await self.getOrPostFlightPlan()
            }
            
            group.addTask {
                await self.getOrPostLogbookEntries()
            }
            group.addTask {
                await self.getOrPostLogbookLimitation()
            }
            group.addTask {
                await self.getOrPostRecency()
            }
            
    //        async let eventService = getOrPostEvent()
    //        async let logbookService = getOrPostLogbookEntries()
    //        async let limitationService = getOrPostLogbookLimitation()
    //        async let recencyService = getOrPostRecency()
    //        async let flightPlanService = getOrPostFlightPlan()
    //
    //        return await [eventService, logbookService, limitationService, recencyService, flightPlanService]
        }
    }
    
    func syncDataMetarTaf() async {
//        let response = await remoteService.getFlightPlanWX()
        
//        if let metarTafData = response {
//            self.updateDataMetarTaf(metarTafData)
//            self.updateDataAltnTaf(metarTafData)
//        }
    }
    
    @MainActor
    func initFetchData() async {
        DispatchQueue.main.async {
            self.tagList = self.readTag()
            self.scratchPadArray = self.readScratchPad()
            self.dataFPEnroute = self.readEnrouteList()
            
            self.readSummaryInfo()
            self.dataWaypointMap = self.readDataWaypontMapList()
            self.dataAirportMap = self.readDataAirportMapList()
            self.dataAirportColorMap = self.readDataAirportMapColorList()
            self.dataTrafficMap = self.readDataTrafficMapList()
            self.dataAabbaMap = self.readDataAabbaMapList()
            self.dataRouteMap = self.readDataRouteMapList()
            
            self.dataLogbookEntries = self.readDataLogbookEntries()
            self.dataLogbookLimitation = self.readDataLogbookLimitation()
            
            // For Recency
            self.dataRecency = self.readDataRecency()
            self.dataRecencyExpiry = self.readDataRecencyExpiry()
            self.dataRecencyDocument = self.readDataRecencyDocument()
            self.dataRecencyExperience = self.readDataRecencyExperience()
            self.dataExpiringSoon = self.extractExpiringDocuments(expiryData: self.dataRecencyDocument, monthsAhead: self.monthsAhead)
            
            self.dataAlternate = self.readDataAlternate()
            self.dataUser = self.readUser()
//            self.loadImage(for: "https://tilecache.rainviewer.com/v2/radar/nowcast_fcaf3d9e4766/8000/2/0_1.png")
//            self.loadImage(for: "https://tile.openweathermap.org/map/precipitation_new/0/0/0.png?appid=3c03dc234f4d074c7954855f4aa8e8e9")
//            self.prepareDataForWaypointMap()
//            self.prepareDataForAirportMap()
//            self.dataNoteAabbaPreflight = self.readDataNoteAabbaPostList("preflight")
            
//            self.dataPostPreflight = self.readDataPostList("preflight", "")
//            self.dataPostPreflightRef = self.readDataPostList("preflight", "ref")
//
//            self.dataPostDeparture = self.readDataPostList("departure", "")
//            self.dataPostDepartureRef = self.readDataPostList("departure", "ref")
//
//            self.dataPostEnroute = self.readDataPostList("enroute", "")
//            self.dataPostEnrouteRef = self.readDataPostList("enroute", "ref")
//
//            self.dataPostArrival = self.readDataPostList("arrival", "")
//            self.dataPostArrivalRef = self.readDataPostList("arrival", "ref")
            
//            self.dataNoteAabbaDeparture = self.readDataNoteAabbaPostList("departure")
//            self.dataNoteAabbaEnroute = self.readDataNoteAabbaPostList("enroute")
//            self.dataNoteAabbaArrival = self.readDataNoteAabbaPostList("arrival")
//            self.dataNoteAabbaPreflightRef = self.readDataNoteAabbaPostList("preflightref")
//            self.dataNoteAabbaDepartureRef = self.readDataNoteAabbaPostList("departureref")
//            self.dataNoteAabbaEnrouteRef = self.readDataNoteAabbaPostList("enrouteref")
//            self.dataNoteAabbaArrivalRef = self.readDataNoteAabbaPostList("arrivalref")
            
            self.readSummaryRoute()
            self.readPerfData()
//            self.dataPerfInfo = self.readPerfInfo()
            self.dataPerfWeight = self.readPerfWeight()
            self.readFuelDataList()
            self.dataFuelTableList = self.readFuelTableList()
            self.readFuelExtra()
            self.dataAltnList = self.readAltnList()
//            self.readDepartureAtc()
            self.readDepartureAtis()
            self.readDepartureEntries()
            self.readArrivalAtc()
            self.readArrivalAtis()
            self.readArrivalEntries()
//            self.dataNotams = self.readDataNotamsList()
//            self.dataNotamsRef = self.readDataNotamsRefList()
//            self.dataDepartureNotamsRef = self.readDataNotamsByType("depNotams")
//            self.dataEnrouteNotamsRef = self.readDataNotamsByType("enrNotams")
//            self.dataArrivalNotamsRef = self.readDataNotamsByType("arrNotams")
//            self.dataDestinationNotamsRef = self.readDataNotamsByType("destNotams")
            
//            self.dataDepartureMetarTaf = self.readDataMetarTafByType("depMetarTaf")
//            self.dataEnrouteMetarTaf = self.readDataMetarTafByType("enrMetarTaf")
//            self.dataArrivalMetarTaf = self.readDataMetarTafByType("arrMetarTaf")
//            self.dataDestinationMetarTaf = self.readDataMetarTafByType("altnMetarTaf")
            
//            self.dataMetarTaf = self.readDataMetarTafList()
//            self.dataAltnTaf = self.readDataAltnTafList()
            // For Fuel
            
            self.readProjTaxi()
            self.readFlightLevel()
            self.dataTrackFlown = self.readTrackFlown()
            self.readProjDelays()
            self.readHistoricalDelays()
            
            // For AISearch
            self.dataAISearch = self.readAISearch()
            self.dataAISearchFavorite = self.readAISearch(target: true)
            
            // For Calendar
            self.dataEvents = self.readEvents()
            self.dataEventCompleted = self.readEventsByStatus(status: "2")
            self.dataEventUpcoming = self.readEventsByStatus(status: "5")
            
            // For Overview
            self.dataFlightOverview = self.readFlightOverview()
            
            // For signature
            self.dataSignature = self.readSignature()
            
            self.dataSectionDateUpdate = self.readSectionDateUpdate()
        }
    }
    
    // For V3.0
    
    func postEvent(_ payload: [EventList]) async -> Bool {
        var payloadEvent: [Any] = []
        var payloadEventDateRange: [Any] = []
        
        for item in dataEvents {
            payloadEvent.append([
                "UUID": UUID().uuidString,
                "status": "\(item.status)",
                "startDate": item.unwrappedStartDate,
                "endDate": item.unwrappedEndDate,
                "name": item.unwrappedName,
                "location": item.unwrappedLocation,
                "type": item.unwrappedType,
                "dep": item.unwrappedDep,
                "dest": item.unwrappedDest
            ] as [String : Any])
        }
        
        for item in dataEventDateRange {
            payloadEventDateRange.append([
                "startDate": item.unwrappedStartDate,
                "endDate": item.unwrappedEndDate,
            ])
        }
                
        let payload: [String: Any] = [
            "user_id": userID,
            "events": payloadEvent,
            "COP_date_ranges": payloadEventDateRange
        ]
        
        return await remoteService.postCalendarData(payload)
    }
    
    func getOrPostEvent() async -> Bool {
        if dataEvents.count > 0 {
            return await postEvent(dataEvents)
        } else {
            // Get event data
            let calendarService = await remoteService.getCalendarData()
                    
            print("calendarService======\(calendarService)")
            if let dateRange = calendarService?.COP_date_ranges, dateRange.count > 0 {
                self.initDataEventDateRange(dateRange)
            }
    
            if let events = calendarService?.events, events.count > 0 {
                self.initDataEvent(events)
            }
            print("=======get event=====")
            return true
        }
    }
    
    func postLogbookEntries(_ payload: [LogbookEntriesList]) async -> Bool {
        var payloadLogbook: [Any] = []
        
        for item in payload {
            payloadLogbook.append([
                "log_id": item.unwrappedLogId,
                "date": item.unwrappedDate,
                "aircraft_category": item.unwrappedAircraftCategory,
                "aircraft_type": item.unwrappedAircraftType,
                "aircraft": item.unwrappedAircraft,
                "departure": item.unwrappedDeparture,
                "destination": item.unwrappedDeparture,
                "pic_day": item.unwrappedPicDay,
                "pic_u_us_day": item.unwrappedPicUUsDay,
                "p1_day": item.unwrappedP1Day,
                "p2_day": item.unwrappedP2Day,
                "pic_night": item.unwrappedPicNight,
                "pic_u_us_night": item.unwrappedPicUUsNight,
                "p1_night": item.unwrappedP1Night,
                "p2_night": item.unwrappedP2Night,
                "instr": item.unwrappedInstr,
                "exam": item.unwrappedAircraft,
                "comments": item.unwrappedComments,
                "licence_number": dataSignature?.licenseNumber,
                "signature_base64dataurl": dataSignature?.imageString
            ])
        }
        
        let payload: [String: Any] = [
            "user_id": userID,
            "logbook_data": payloadLogbook,
        ]
        
        print("=======post logbook=====")
        return await remoteService.postLogbookData(payload)
    }
    
    func getOrPostLogbookEntries() async -> Bool {
        if dataLogbookEntries.count > 0 {
            return await postLogbookEntries(dataLogbookEntries)
        } else {
            let logbookService = await remoteService.getLogbookData()
            
            if let logbookEntry = logbookService?.logbook_data, logbookEntry.count > 0 {
                self.initDataLogbookEntries(logbookEntry)
            }
            
            if let experience = logbookService?.experience, experience.count > 0 {
                for item in experience {
                    let newObject = RecencyExperienceList(context: service.container.viewContext)
                    newObject.id = UUID()
                    newObject.model = item.model
                    newObject.picDay = item.picDay
                    newObject.picNight = item.picNight
                    newObject.picUsDay = item.picUsDay
                    newObject.picUsNight = item.picUsNight
                    newObject.p1Day = item.p1Day
                    newObject.p1Night = item.p1Night
                    newObject.p2Day = item.p2Day
                    newObject.p2Night = item.p2Night
                    newObject.totalTime = item.totalTime
                    
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
                
                self.dataRecencyExperience = self.readDataRecencyExperience()
            }
            
            print("=======get logbook=====")
            return true
        }
    }
    
    func getOrPostLogbookLimitation() async -> Bool {
        if dataLogbookLimitation.count > 0 {
            var payloadLimitation = [Any]()
            
            for item in dataLogbookLimitation {
                payloadLimitation.append([
                    "id": "\(item.id ?? UUID())",
                    "limitation_type": item.unwrappedType,
                    "limitation_requirement": item.unwrappedRequirement,
                    "limitation_limit": item.unwrappedLimit,
                    "limitation_start": item.unwrappedStart,
                    "limitation_end": item.unwrappedEnd,
                ] as [String : Any])
            }
            
            let payload: [String: Any] = [
                "user_id": userID,
                "limitation_data": payloadLimitation,
            ]
            
            print("=======post limitation=====")
            return await remoteService.postLimitationData(payload)
            
        } else {
            let limitationService = await remoteService.getLimitationData()
            
            if let limitationEntry = limitationService?.limitation_data, limitationEntry.count > 0 {
                self.initDataLogbookLimitation(limitationEntry)
            }
            print("=======get limitation=====")
            
            return true
        }
    }
    
    func getOrPostRecency() async -> Bool {
        if dataRecency.count > 0 {
            var payloadRecency: [Any] = []
            var payloadExpiry: [Any] = []
            var payloadVisa: [Any] = []
            
            for item in dataRecency {
                payloadRecency.append([
                    "recency_type": item.unwrappedType,
                    "recency_requirement": item.unwrappedRequirement,
                    "recency_limit": item.unwrappedLimit
                ] as [String : Any])
            }
            
            for item in dataRecencyDocument {
                var temp = [String: Any]()
                let key = item.unwrappedType.lowercased().replacingOccurrences(of: " ", with:
                "_")
                
                temp[key] = item.unwrappedExpiredDate
                
                payloadExpiry.append(temp)
            }
            
            for item in dataRecencyExpiry {
                payloadVisa.append([
                    "visa": item.unwrappedType,
                    "expiry": item.unwrappedExpiredDate,
                ])
            }
            
            let payload: [String: Any] = [
                "user_id": userID,
                "recency_data": payloadRecency,
                "expiry_data": payloadExpiry,
                "visa_data": payloadVisa
            ]
            
            print("=======post recency ===== \(payload)")
            
            return await remoteService.postRecencyData(payload)
        } else {
            let recencyService = await remoteService.getRecencyData()
            
            if let recencyData = recencyService?.recency_data, recencyData.count > 0 {
                self.initDataRecency(recencyData)
            }
            
            if let expiryData = recencyService?.expiry_data, expiryData.count > 0 {
                self.initDataRecencyExpiry(expiryData)
            }
            print("=======get recency=====")
            
            return true
        }
    }
    
    func postFlightPlan() async -> Bool {
        if dataEvents.count > 0 {
            var arrPayload = [Any]()
            
            for dataEvent in dataEvents {
                let dataSelected = (dataEvent.flightOverviewList?.allObjects as? [FlightOverviewList])?.first
                
                let payloadOverview: [String: String] = [
                    "callsign": dataSelected?.callsign ?? "",
                    "model": dataSelected?.model ?? "",
                    "aircraft": dataSelected?.aircraft ?? "",
                    "dep": dataSelected?.dep ?? "",
                    "dest": dataSelected?.dest ?? "",
                    "pob": dataSelected?.pob ?? "",
                    "std": dataSelected?.std ?? "",
                    "sta": dataSelected?.sta ?? "",
                    "time_diff_dep": dataSelected?.timeDiffDep ?? "",
                    "time_diff_arr": dataSelected?.timeDiffArr ?? "",
                    "blockTime": dataSelected?.blockTime ?? "",
                    "flightTime": dataSelected?.flightTime ?? "",
                    "blockTime_FlightTime": dataSelected?.blockTimeFlightTime ?? "",
                    "chockOff": dataSelected?.chockOff ?? "",
                    "ETA": dataSelected?.eta ?? "",
                    "chockOn": dataSelected?.chockOn ?? "",
                    "day": dataSelected?.day ?? "",
                    "night": dataSelected?.night ?? "",
                    "totalTime": dataSelected?.totalTime ?? "",
                    "password": dataSelected?.password ?? "",
                    "CAName": dataSelected?.caName ?? "",
                    "CAPicker": dataSelected?.caPicker ?? "",
                    "FOName": dataSelected?.f0Name ?? "",
                    "FOPicker": dataSelected?.f0Picker ?? "",
                    "status": selectedEvent?.flightStatus ?? FlightStatusEnum.UPCOMING.rawValue,
                ]
                
                print("payloadOverview==========\(payloadOverview)")
                print("dataSelected==========\(dataSelected)")
                
                var payloadRoute: [Any] = []
                
                if dataRouteMap.count > 0 {
                    for item in dataRouteMap {
                        payloadRoute.append([
                            "lat": item.latitude,
                            "long": item.longitude,
                            "name": item.name
                        ])
                    }
                }
                
                var payloadColorMap: [Any] = []
                if dataAirportColorMap.count > 0 {
                    for item in dataAirportColorMap {
                        payloadColorMap.append([
                            "airportID": item.unwrappedAirportId,
                            "colour": item.unwrappedColour,
                            "lat": item.unwrappedLatitude,
                            "long": item.unwrappedLongitude,
                            "metar": item.unwrappedMetar,
                            "notams": item.unwrappedNotams,
                            "selection": item.unwrappedSelection,
                            "taf": item.unwrappedTaf
                        ])
                    }
                }
                
                var payloadNotams: [String: [Any]] = [:]
                if dataNotams.count > 0 {
                    for item in dataNotams {
                        var type = "preflight"
                        
                        if item.unwrappedType == "arrNotams" {
                            type = "arrival"
                        } else if item.unwrappedType == "depNotams" {
                            type = "departure"
                        } else if item.unwrappedType == "enrNotams" {
                            type = "enroute"
                        }
                        
                        if let itemAirport = item.airport {
                            payloadNotams[itemAirport]?.append([
                                "date": item.unwrappedDate,
                                "id": item.id,
                                "isChecked": item.isChecked,
                                "notam": item.unwrappedNotam,
                                "rank": item.unwrappedRank,
                                "type": type,
                                "category": item.unwrappedCategory
                            ] as [String : Any])
                        }
                    }
                }
                
                var payloadMetarTaf: [String: [Any]] = [:]
                if self.dataMetarTaf.count > 0 {
                    for item in dataMetarTaf {
                        var type = "departure"
                        
                        if item.unwrappedType == "arrMetarTaf" {
                            type = "arrival"
                        } else if item.unwrappedType == "enrMetarTaf" {
                            type = "enroute_alternates"
                        } else if item.unwrappedType == "altnMetarTaf" {
                            type = "destination_alternates"
                        }
                        
                        payloadMetarTaf[type]?.append([
                            "airportText": item.unwrappedAirport,
                            "metar": item.unwrappedMetar,
                            "taf": item.unwrappedTaf
                        ])
                    }
                }
                
                var payloadNoteList: [Any] = []
                if dataNoteList.count > 0 {
                    for item in dataNoteList {
                        var payloadTagList = [String]()

                        if let tags = item.tags?.allObjects as? [TagList] {
                            for tag in tags {
                                payloadTagList.append(tag.name)
                            }
                        }

                        payloadNoteList.append([
                            "isDefault": item.isDefault,
                            "name": item.unwrappedName,
                            "createdAt": item.unwrappedCreatedAt,
                            "type": item.unwrappedType,
                            "includeCrew": item.includeCrew,
                            "canDelete": item.canDelete,
                            "fromParent": item.fromParent,
                            "parentId": item.parentId ?? UUID().uuidString,
                            "tags": payloadTagList,
                            "favourite": item.isDefault
                        ] as [String : Any])
                    }
                }
                
                var payloadAabbaNoteList = [String: [Any]]()
                if dataNoteAabba.count > 0 {
                    for item in dataNoteAabba {
                        var payloadAabbaPostList: [Any] = []

                        if let posts = item.posts?.allObjects as? [NotePostList], posts.count > 0 {
                            for post in posts {
                                var payloadAabbaCommentList: [Any] = []

                                if let comments = post.comments?.allObjects as? [NoteCommentList], comments.count > 0 {
                                    for comment in comments {
                                        payloadAabbaCommentList.append([
                                            "comment_id": comment.unwrappedCommentId,
                                            "post_id": comment.unwrappedPostId,
                                            "user_id": comment.unwrappedUserId,
                                            "comment_date": comment.unwrappedCommentDate,
                                            "comment_text": comment.unwrappedCommentText,
                                            "username": comment.unwrappedUserName
                                        ])
                                    }
                                }

                                payloadAabbaPostList.append([
                                    "post_id": post.postId ?? "",
                                    "user_id": post.userId ?? "",
                                    "post_date": post.unwrappedPostDate,
                                    "post_title": post.unwrappedPostTitle,
                                    "post_text": post.unwrappedPostText,
                                    "upvote_count": post.unwrappedUpvoteCount,
                                    "comment_count": post.unwrappedCommentCount,
                                    "category": post.unwrappedCategory,
                                    "comments": payloadAabbaCommentList,
                                    "username": post.unwrappedUserName,
                                    "favourite": post.favourite,
                                    "blue": post.blue,
                                    "voted": post.voted
                                ] as [String : Any])
                            }
                        }

                        payloadAabbaNoteList[item.unwrappedType]?.append([
                            "name": item.unwrappedName,
                            "lat": item.unwrappedLatitude,
                            "long": item.unwrappedLongitude,
                            "post_count": item.unwrappedPostCount,
                            "posts": payloadAabbaPostList
                        ] as [String : Any])

                    }
                }
                
                var payloadMapList: [Any] = []
                if dataAabbaMap.count > 0 {
                    for item in dataAabbaMap {
                        var payloadMapPostList: [Any] = []
                        
                        if let posts = item.posts?.allObjects as? [AabbaPostList], posts.count > 0 {
                            for post in posts {
                                var payloadMapCommentList: [Any] = []
                                
                                if let comments = post.comments?.allObjects as? [AabbaCommentList], comments.count > 0 {
                                    for comment in comments {
                                        payloadMapCommentList.append([
                                            "comment_id": comment.unwrappedCommentId,
                                            "post_id": comment.unwrappedPostId,
                                            "user_id": comment.unwrappedUserId,
                                            "comment_date": comment.unwrappedCommentDate,
                                            "comment_text": comment.unwrappedCommentText,
                                            "username": comment.unwrappedUserName
                                        ])
                                    }
                                }
                                
                                payloadMapPostList.append([
                                    "post_id": post.postId ?? "",
                                    "user_id": post.userId ?? "",
                                    "post_date": post.postDate ?? "",
                                    "post_title": post.postTitle ?? "",
                                    "post_text": post.postText ?? "",
                                    "upvote_count": post.upvoteCount,
                                    "comment_count": post.commentCount ?? "0",
                                    "category": post.category ?? "",
                                    "comments": payloadMapCommentList,
                                    "username": post.userName ?? "",
                                    "voted": post.voted
                                ] as [String : Any])
                            }
                        }
                            
                        payloadMapList.append([
                            "name": item.unwrappedName,
                            "lat": item.unwrappedLatitude,
                            "long": item.unwrappedLongitude,
                            "post_count": item.unwrappedPostCount,
                            "posts": payloadMapPostList
                        ] as [String : Any])
                    }
                }
                
                let payload: [String: Any] = [
                    "user_id": userID,
                    "flight_number": dataSelected?.callsign ?? "",
                    "status": selectedEvent?.flightStatus ?? FlightStatusEnum.UPCOMING.rawValue,
                    "flight_overview": payloadOverview,
                    "route": payloadRoute,
                    "colour_airport": payloadColorMap,
                    "notam": payloadNotams,
                    "metar_taf": payloadMetarTaf,
                    "notes": payloadNoteList,
                    "aabba_notes": payloadAabbaNoteList,
                    "aabba_map": payloadMapList
                ]
                
                arrPayload.append(payload)
            }
                    print("=======post flight plan payload===== \(arrPayload)")
            return await remoteService.postFlightPlanDataV3(arrPayload)
        }
        return true
    }
    
    func postFlightPlanObject() async -> Bool {
        let dataSelected = (selectedEvent?.flightOverviewList?.allObjects as? [FlightOverviewList])?.first
        
        let payloadOverview: [String: String] = [
            "callsign": dataSelected?.callsign ?? "",
            "model": dataSelected?.model ?? "",
            "aircraft": dataSelected?.aircraft ?? "",
            "dep": dataSelected?.dep ?? "",
            "dest": dataSelected?.dest ?? "",
            "pob": dataSelected?.pob ?? "",
            "std": dataSelected?.std ?? "",
            "sta": dataSelected?.sta ?? "",
            "time_diff_dep": dataSelected?.timeDiffDep ?? "",
            "time_diff_arr": dataSelected?.timeDiffArr ?? "",
            "blockTime": dataSelected?.blockTime ?? "",
            "flightTime": dataSelected?.flightTime ?? "",
            "blockTime_FlightTime": dataSelected?.blockTimeFlightTime ?? "",
            "chockOff": dataSelected?.chockOff ?? "",
            "ETA": dataSelected?.eta ?? "",
            "chockOn": dataSelected?.chockOn ?? "",
            "day": dataSelected?.day ?? "",
            "night": dataSelected?.night ?? "",
            "totalTime": dataSelected?.totalTime ?? "",
            "password": dataSelected?.password ?? "",
            "CAName": dataSelected?.caName ?? "",
            "CAPicker": dataSelected?.caPicker ?? "",
            "FOName": dataSelected?.f0Name ?? "",
            "FOPicker": dataSelected?.f0Picker ?? "",
            "status": selectedEvent?.flightStatus ?? FlightStatusEnum.UPCOMING.rawValue,
        ]
        
        print("payloadOverview==========\(payloadOverview)")
        print("dataSelected==========\(dataSelected)")
        
        var payloadRoute: [Any] = []
        
        if dataRouteMap.count > 0 {
            for item in dataRouteMap {
                payloadRoute.append([
                    "lat": item.latitude,
                    "long": item.longitude,
                    "name": item.name
                ])
            }
        }
        
        var payloadColorMap: [Any] = []
        if dataAirportColorMap.count > 0 {
            for item in dataAirportColorMap {
                payloadColorMap.append([
                    "airportID": item.unwrappedAirportId,
                    "colour": item.unwrappedColour,
                    "lat": item.unwrappedLatitude,
                    "long": item.unwrappedLongitude,
                    "metar": item.unwrappedMetar,
                    "notams": item.unwrappedNotams,
                    "selection": item.unwrappedSelection,
                    "taf": item.unwrappedTaf
                ])
            }
        }
        
        var payloadNotams: [String: [Any]] = [:]
        if dataNotams.count > 0 {
            for item in dataNotams {
                var type = "preflight"
                
                if item.unwrappedType == "arrNotams" {
                    type = "arrival"
                } else if item.unwrappedType == "depNotams" {
                    type = "departure"
                } else if item.unwrappedType == "enrNotams" {
                    type = "enroute"
                }
                
                if let itemAirport = item.airport {
                    payloadNotams[itemAirport]?.append([
                        "date": item.unwrappedDate,
                        "id": item.id,
                        "isChecked": item.isChecked,
                        "notam": item.unwrappedNotam,
                        "rank": item.unwrappedRank,
                        "type": type,
                        "category": item.unwrappedCategory
                    ] as [String : Any])
                }
            }
        }
        
        var payloadMetarTaf: [String: [Any]] = [:]
        if self.dataMetarTaf.count > 0 {
            for item in dataMetarTaf {
                var type = "departure"
                
                if item.unwrappedType == "arrMetarTaf" {
                    type = "arrival"
                } else if item.unwrappedType == "enrMetarTaf" {
                    type = "enroute_alternates"
                } else if item.unwrappedType == "altnMetarTaf" {
                    type = "destination_alternates"
                }
                
                payloadMetarTaf[type]?.append([
                    "airportText": item.unwrappedAirport,
                    "metar": item.unwrappedMetar,
                    "taf": item.unwrappedTaf
                ])
            }
        }
        
        var payloadNoteList: [Any] = []
        if dataNoteList.count > 0 {
            for item in dataNoteList {
                var payloadTagList = [String]()

                if let tags = item.tags?.allObjects as? [TagList] {
                    for tag in tags {
                        payloadTagList.append(tag.name)
                    }
                }

                payloadNoteList.append([
                    "isDefault": item.isDefault,
                    "name": item.unwrappedName,
                    "createdAt": item.unwrappedCreatedAt,
                    "type": item.unwrappedType,
                    "includeCrew": item.includeCrew,
                    "canDelete": item.canDelete,
                    "fromParent": item.fromParent,
                    "parentId": item.parentId ?? UUID().uuidString,
                    "tags": payloadTagList,
                    "favourite": item.isDefault
                ] as [String : Any])
            }
        }
        
        var payloadAabbaNoteList = [String: [Any]]()
        if dataNoteAabba.count > 0 {
            for item in dataNoteAabba {
                var payloadAabbaPostList: [Any] = []

                if let posts = item.posts?.allObjects as? [NotePostList], posts.count > 0 {
                    for post in posts {
                        var payloadAabbaCommentList: [Any] = []

                        if let comments = post.comments?.allObjects as? [NoteCommentList], comments.count > 0 {
                            for comment in comments {
                                payloadAabbaCommentList.append([
                                    "comment_id": comment.unwrappedCommentId,
                                    "post_id": comment.unwrappedPostId,
                                    "user_id": comment.unwrappedUserId,
                                    "comment_date": comment.unwrappedCommentDate,
                                    "comment_text": comment.unwrappedCommentText,
                                    "username": comment.unwrappedUserName
                                ])
                            }
                        }

                        payloadAabbaPostList.append([
                            "post_id": post.postId ?? "",
                            "user_id": post.userId ?? "",
                            "post_date": post.unwrappedPostDate,
                            "post_title": post.unwrappedPostTitle,
                            "post_text": post.unwrappedPostText,
                            "upvote_count": post.unwrappedUpvoteCount,
                            "comment_count": post.unwrappedCommentCount,
                            "category": post.unwrappedCategory,
                            "comments": payloadAabbaCommentList,
                            "username": post.unwrappedUserName,
                            "favourite": post.favourite,
                            "blue": post.blue,
                            "voted": post.voted
                        ] as [String : Any])
                    }
                }

                payloadAabbaNoteList[item.unwrappedType]?.append([
                    "name": item.unwrappedName,
                    "lat": item.unwrappedLatitude,
                    "long": item.unwrappedLongitude,
                    "post_count": item.unwrappedPostCount,
                    "posts": payloadAabbaPostList
                ] as [String : Any])

            }
        }
        
        var payloadMapList: [Any] = []
        if dataAabbaMap.count > 0 {
            for item in dataAabbaMap {
                var payloadMapPostList: [Any] = []
                
                if let posts = item.posts?.allObjects as? [AabbaPostList], posts.count > 0 {
                    for post in posts {
                        var payloadMapCommentList: [Any] = []
                        
                        if let comments = post.comments?.allObjects as? [AabbaCommentList], comments.count > 0 {
                            for comment in comments {
                                payloadMapCommentList.append([
                                    "comment_id": comment.unwrappedCommentId,
                                    "post_id": comment.unwrappedPostId,
                                    "user_id": comment.unwrappedUserId,
                                    "comment_date": comment.unwrappedCommentDate,
                                    "comment_text": comment.unwrappedCommentText,
                                    "username": comment.unwrappedUserName
                                ])
                            }
                        }
                        
                        payloadMapPostList.append([
                            "post_id": post.postId ?? "",
                            "user_id": post.userId ?? "",
                            "post_date": post.postDate ?? "",
                            "post_title": post.postTitle ?? "",
                            "post_text": post.postText ?? "",
                            "upvote_count": post.upvoteCount,
                            "comment_count": post.commentCount ?? "0",
                            "category": post.category ?? "",
                            "comments": payloadMapCommentList,
                            "username": post.userName ?? "",
                            "voted": post.voted
                        ] as [String : Any])
                    }
                }
                    
                payloadMapList.append([
                    "name": item.unwrappedName,
                    "lat": item.unwrappedLatitude,
                    "long": item.unwrappedLongitude,
                    "post_count": item.unwrappedPostCount,
                    "posts": payloadMapPostList
                ] as [String : Any])
            }
        }
        
        let payload: [String: Any] = [
            "user_id": userID,
            "flight_number": dataSelected?.callsign ?? "",
            "status": selectedEvent?.flightStatus ?? FlightStatusEnum.UPCOMING.rawValue,
            "flight_overview": payloadOverview,
            "route": payloadRoute,
            "colour_airport": payloadColorMap,
            "notam": payloadNotams,
            "metar_taf": payloadMetarTaf,
            "notes": payloadNoteList,
            "aabba_notes": payloadAabbaNoteList,
            "aabba_map": payloadMapList
        ]
        
//        print("=======post flight plan payload===== \(payload)")
        
        return await remoteService.postFlightPlanDataV3([payload])
    }
    
    func getOrPostFlightPlan() async -> Bool {
        if dataFlightOverviewList.count > 0 {
            return await postFlightPlan()
        } else {
            let responseFlightPlan = await remoteService.getFlightPlanDataV3()
            print("responseFlightPlan======\(responseFlightPlan)")
            if responseFlightPlan.count > 0 {
                await withTaskGroup(of: Void.self) { group in
                    for item in responseFlightPlan {
                        //Check event exists or not to create relationship
                        if let event = readEventsByName(flight: item.flight_overview.callsign) {
                            print("inside event=======\(event)")
                            
                            event.flightStatus = item.status
                            
                            if let itemNotes = item.notes, itemNotes.count > 0 {
                                group.addTask {
                                    self.initDataNoteList(itemNotes, event)
                                }
                            }
                            
                            if let itemColourAirport = item.colour_airport, itemColourAirport.count > 0 {
                                group.addTask {
                                    self.initDataAirportColor(itemColourAirport, event)
                                }
                            }
                            
                            if let itemRoute = item.route, itemRoute.count > 0 {
                                group.addTask {
                                    self.initDataRouteMap(itemRoute, event)
                                }
                            }
                            
                            if let itemNotam = item.notam, itemNotam.count > 0 {
                                group.addTask {
                                    self.initDataFlightNotams(itemNotam, event)
                                }
                            }
                            
                            if let itemMetarTaf = item.metar_taf, itemMetarTaf.count > 0 {
                                group.addTask {
                                    self.initDataFlightMetarTaf(itemMetarTaf, event)
                                }
                            }
                            
                            if let itemAabbaNote = item.aabba_notes, itemAabbaNote.count > 0 {
                                group.addTask {
                                    self.initDataMapAabbaNotes(itemAabbaNote, event)
                                }
                            }
                            
                            group.addTask {
                                self.initDataFlightOverview(item.flight_overview, event)
                            }
                        }
                    }
                   
                }
            }
            
            
            print("=======get flight plan=====")
            return true
        }
    }
    
    func checkAndSyncDataNote() async {
        let response = readTag()
        
        if response.count == 0 {
            initData()
        }
    }
    
    func initData() {
        let newTags1 = TagList(context: service.container.viewContext)
        newTags1.id = UUID()
        newTags1.name = "Aircraft Status"
        
        let newTags2 = TagList(context: service.container.viewContext)
        newTags2.id = UUID()
        newTags2.name = "ATC"
        
        let newTags3 = TagList(context: service.container.viewContext)
        newTags3.id = UUID()
        newTags3.name = "Terrain"
        
        let newTags4 = TagList(context: service.container.viewContext)
        newTags4.id = UUID()
        newTags4.name = "Weather"
        
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
    
    func initDataNoteList(_ notes: [NotesV30Json], _ event: EventList) {
        if notes.count > 0 {
            var noteList = [NoteList]()
            
            for item in notes {
                var tags = [TagList]()
                
                if item.tags.count > 0 {
                    for tag in item.tags {
                        let tagList = TagList(context: service.container.viewContext)
                        tagList.id = UUID()
                        tagList.name = tag
                        tags.append(tagList)
                    }
                }
                
                
                let note = NoteList(context: service.container.viewContext)
                note.id = UUID()
                note.name = item.name
                note.isDefault = item.isDefault
                note.canDelete = item.canDelete
                note.fromParent = item.fromParent
                note.type = item.type
                note.tags = NSSet(array: tags)
                
                noteList.append(note)
                
                service.container.viewContext.performAndWait {
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        print("saved notes successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save notes: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            }
            
            do {
                // Persist the data in this managed object context to the underlying store
                event.noteList = NSSet(array: noteList)
                try service.container.viewContext.save()
                print("saved event notes successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save event notes: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
            
            self.readNoteListIncludeCrew()
            self.preflightArray = self.read("preflight")
            self.departureArray = self.read("departure")
            self.enrouteArray = self.read("enroute")
            self.arrivalArray = self.read("arrival")
            self.preflightRefArray = self.readClipBoard("preflight")
            self.departureRefArray = self.readClipBoard("departure")
            self.enrouteRefArray = self.readClipBoard("enroute")
            self.arrivalRefArray = self.readClipBoard("arrival")
        }
        
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
    
    func readSectionDateUpdate() -> SectionDateUpdateList? {
        // create a temp array to save fetched notes
        var data: SectionDateUpdateList?
        // initialize the fetch request
        let request: NSFetchRequest<SectionDateUpdateList> = SectionDateUpdateList.fetchRequest()
        
        // fetch with the request
        do {
            let response = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                data = response.first
            }
        } catch {
            print("Could not fetch tag from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readTagByName(_ target: String = "") -> [CabinDefectModel] {
        var temp = [CabinDefectModel]()
        if let data = self.selectedEvent?.noteList?.allObjects as? [NoteList], data.count > 0 {
            for post in data {
                if post.includeCrew {
                    if let tags = post.tags?.allObjects as? [TagList], tags.count > 0 {
                        for tag in tags {
                            if tag.name == target {
                                temp.append(CabinDefectModel(postId: post.id ?? UUID(), postName: post.unwrappedName, postDate: post.unwrappedCreatedAt, tagName: tag.name, postIsDefault: post.includeCrew))
                            }
                        }
                    }
                }
            }
        }
        return temp
    }
    
    func readNoteListIncludeCrew() -> [NoteList] {
        var temp = [NoteList]()
        
        if let data = self.selectedEvent?.noteList?.allObjects as? [NoteList], data.count > 0 {
            for post in data {
                if post.includeCrew {
                    temp.append(post)
                }
            }
        }
        return temp
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
    
    func initDataWaypoint(_ data: [IWaypointData]) {
        if let eventList = self.selectedEvent {
            if data.count > 0 {
                var temp = [WaypointMapList]()
                
                data.forEach { item in
                    let newObj = WaypointMapList(context: service.container.viewContext)
                    
                    newObj.id = UUID()
                    newObj.name = item.waypoint_id
                    newObj.latitude = item.lat
                    newObj.longitude = item.long
                    
                    service.container.viewContext.performAndWait {
                        do {
                            temp.append(newObj)
                            try service.container.viewContext.save()
                            print("saved waypoint data successfully")
                        } catch {
                            print("Failed to waypoint data save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
                    }
                }
                
                eventList.waypointMapList = NSSet(array: temp)
                self.dataWaypointMap = readDataWaypontMapList()
            }
        }
    }
    
    func initDataAirport(_ data: [IAirportData]) {
        if let eventList = self.selectedEvent {
            if data.count > 0 {
                var temp = [AirportMapList]()
                
                data.forEach { item in
                    let newObj = AirportMapList(context: service.container.viewContext)
                    
                    newObj.id = UUID()
                    newObj.name = item.airport_id
                    newObj.latitude = item.lat
                    newObj.longitude = item.long
                    
                    service.container.viewContext.performAndWait {
                        do {
                            temp.append(newObj)
                            try service.container.viewContext.save()
                            print("saved data airport successfully")
                        } catch {
                            print("Failed to data airport save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
                    }
                }
                
                eventList.airportMapList = NSSet(array: temp)
                self.dataAirportMap = readDataAirportMapList()
            }
        }
    }
    
    func initDataAirportMapColor(_ data: [IAirportColor], _ payload: [String: Any]) {
        if let eventList = self.selectedEvent {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

            if data.count > 0 {
                var temp = [AirportMapColorList]()
                
                data.forEach { item in
                    
                    let newObj = AirportMapColorList(context: service.container.viewContext)
                    
                    newObj.id = UUID()
                    newObj.airportId = item.airportID
                    newObj.latitude = item.lat
                    newObj.longitude = item.long
                    newObj.selection = item.selection
                    newObj.colour = item.colour
                    newObj.notams = item.notams
                    newObj.metar = item.metar
                    newObj.taf = item.taf
                    newObj.arrDelay = item.arr_delay
                    newObj.depDelay = item.dep_delay
                    newObj.arrDelayColour = item.arr_delay_colour
                    newObj.depDelayColour = item.dep_delay_colour
                    newObj.updatedAt = dateFormatter.string(from: Date())
                    
                    
                    service.container.viewContext.performAndWait {
                        do {
                            temp.append(newObj)
                            try service.container.viewContext.save()
                            print("saved data airport color successfully")
                        } catch {
                            print("could not unarchive array: \(error)")
                        }
                    }
                }
                
                eventList.airportMapColorList = NSSet(array: temp)
                
                self.dataAirportColorMap = readDataAirportMapColorList()
            }
        }
    }
    
    func initDataRouteMap(_ data: [RouteV30Json], _ event: EventList) {
        if data.count > 0 {
            var payloadMapRoute = [MapRouteList]()
            
            data.forEach { item in
                do {
                    let newObj = MapRouteList(context: service.container.viewContext)
                    
                    newObj.id = UUID()
                    newObj.name = item.name
                    newObj.latitude = item.lat
                    newObj.longitude = item.long
                    
                    payloadMapRoute.append(newObj)
                    
                    service.container.viewContext.performAndWait {
                        do {
                            try service.container.viewContext.save()
                            print("saved data route map successfully")
                        } catch {
                            print("Failed to data route map save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
                    }
                } catch {
                    print("could not unarchive array: \(error)")
                }
                
            }
            
            do {
                event.mapRouteList = NSSet(array: payloadMapRoute)
                try service.container.viewContext.save()
                print("saved data route map successfully")
            } catch {
                print("Failed to data route map save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
            
            self.dataRouteMap = readDataRouteMapList()
        }
    }
    
    func initDataAirportColor(_ data: [IAirportColor], _ event: EventList) {
//        let depAirport = "VTBS"
//        let arrAirport = "WSSS"
//        let enrAirports = ["WMKK", "WMKP"]
//        let altnAirports = ["WMKJ", "WIDD"]
//
//        let airportInformation: [IAirportColor] = extractAirportInformation(allAirportsData: data, depAirport: depAirport, arrAirport: arrAirport, enrAirports: enrAirports, altnAirports: altnAirports)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if data.count > 0 {
            var payloadMapColor = [AirportMapColorList]()
            
            data.forEach { item in
                do {
                    let newObj = AirportMapColorList(context: service.container.viewContext)
                    
                    newObj.id = UUID()
                    newObj.airportId = item.airportID
                    newObj.latitude = item.lat
                    newObj.longitude = item.long
                    newObj.selection = item.selection
                    newObj.colour = item.colour
                    newObj.notams = item.notams
                    newObj.metar = item.metar
                    newObj.taf = item.taf
                    newObj.arrDelay = item.arr_delay
                    newObj.depDelay = item.dep_delay
                    newObj.arrDelayColour = item.arr_delay_colour
                    newObj.depDelayColour = item.dep_delay_colour
                    newObj.updatedAt = dateFormatter.string(from: Date())
                    
                    payloadMapColor.append(newObj)
                    
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
                } catch {
                    print("could not unarchive array: \(error)")
                }
                
            }
            
            do {
                event.airportMapColorList = NSSet(array: payloadMapColor)
                try service.container.viewContext.save()
                print("saved data event airport color successfully")
            } catch {
                print("Failed to data event airport color save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
            
            self.dataAirportColorMap = readDataAirportMapColorList()
        }
    }
    
//    func extractAirportInformation(allAirportsData: [IAirportData], depAirport: String, arrAirport: String, enrAirports: [String], altnAirports: [String]) -> [IAirportColor] {
//        var airportInfo: [IAirportColor] = []
//
//        for airportData in allAirportsData {
//            if airportData.airport_id == depAirport {
//                airportInfo.append(
//
//                    IAirportColor(airportID: airportData.airport_id, lat: airportData.lat, long: airportData.long, selection: "Departure", colour: "blue", notams: "", metar: "", taf: "")
//                )
//            } else if airportData.airport_id == arrAirport {
//                airportInfo.append(
//                    IAirportColor(airportID: airportData.airport_id, lat: airportData.lat, long: airportData.long, selection: "Arrival", colour: "blue", notams: "", metar: "", taf: "")
//                )
//            } else if enrAirports.contains(airportData.airport_id) || altnAirports.contains(airportData.airport_id) {
//                airportInfo.append(
//                    IAirportColor(airportID: airportData.airport_id, lat: airportData.lat, long: airportData.long, selection: "ALTN", colour: "green", notams: "", metar: "", taf: "")
//                )
//            }
//        }
//
//        return airportInfo
//    }
    
    func initDataTraffic(_ data: [ITrafficData]) {
        if let eventList = self.selectedEvent {
            if data.count > 0 {
                var temp = [TrafficMapList]()
                
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
                            temp.append(newObj)
                            try service.container.viewContext.save()
                            print("saved data traffic successfully")
                        } catch {
                            print("Failed to data traffic save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
                    }
                }
                
                eventList.trafficMapList = NSSet(array: temp)
                self.dataTrafficMap = readDataTrafficMapList()
            }
        }
    }
    
    func initDataFlightOverview(_ data: FlightOverviewV30Json, _ event: EventList) {
        let newObj = FlightOverviewList(context: self.service.container.viewContext)
        newObj.id = UUID()
        newObj.caName = data.CAName
        newObj.caPicker = data.CAPicker
        newObj.eta = data.ETA
        newObj.f0Name = data.FOName
        newObj.f0Picker = data.FOPicker
        newObj.aircraft = data.aircraft
        newObj.blockTime = data.blockTime
        newObj.blockTimeFlightTime = data.blockTime_FlightTime
        newObj.callsign = data.callsign
        newObj.chockOff = data.chockOff
        newObj.chockOn = data.chockOn
        newObj.day = data.day
        newObj.dep = data.dep
        newObj.dest = data.dest
        newObj.flightTime = data.flightTime
        newObj.model = data.model
        newObj.night = data.night
        newObj.password = data.password
        newObj.pob = data.pob
        newObj.sta = data.sta
        newObj.std = data.std
        newObj.timeDiffArr = data.time_diff_arr
        newObj.timeDiffDep = data.time_diff_dep
        newObj.totalTime = data.totalTime
        
        event.flightOverviewList = NSSet(array: [newObj])
        
        self.service.container.viewContext.performAndWait {
            do {
                try self.service.container.viewContext.save()
                print("saved flight overview successfully")
            } catch {
                print("Failed to init flight overview: \(error)")
            }

        }
        
        self.dataFlightOverview = self.readFlightOverview()
    }
    
    func initDataAabba(_ data: [IAabbaData]) {
        if let eventList = self.selectedEvent {
            if data.count > 0 {
                var temp = [AabbaMapList]()
                
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
                            newPost.upvoteCount = Int32(post.upvote_count) ?? 0
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
                    temp.append(newObj)
                    
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
                
                eventList.aabbaMapList = NSSet(array: temp)
                self.dataAabbaMap = readDataAabbaMapList()
            }
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
                newObj.signFileName = item.sign_file_name
                newObj.signFileUrl = item.sign_file_url
                newObj.licenseNumber = item.licence_number
                
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
                newObj.status = item.limitation_status
                newObj.colour = item.limitation_colour
                newObj.periodText = item.limitation_period_text
                newObj.statusText = item.limitation_status_text

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
                newObj.model = item.recency_aircraft_model
                newObj.requirement = item.recency_requirement
                newObj.limit = item.recency_limit
                newObj.periodStart = item.recency_period_start
                newObj.status = item.recency_status
                newObj.text = item.recency_text
                newObj.percentage = item.recency_percentage
                newObj.blueText = item.recency_blue_text
                newObj.remoteId = item.id
                
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
                let newObj = RecencyDocumentList(context: service.container.viewContext)
                newObj.id = UUID()
                newObj.type = key
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
        
        self.dataRecencyDocument = readDataRecencyDocument()
    }
    
    func initDataMapAabbaNotes(_ data: [String: [INoteResponse]], _ event: EventList) {
        for row in data {
            if row.value.count > 0 {
                if row.key == "preflight" {
                    self.initDataNoteAabbaPreflight(row.value, event)
                } else if row.key == "departure" {
                    self.initDataNoteAabbaDepature(row.value, event)
                } else if row.key == "enroute" {
                    self.initDataNoteAabbaEnroute(row.value, event)
                } else if row.key == "arrival" {
                    self.initDataNoteAabbaArrival(row.value, event)
                }
            }
        }
    }
    
    func initDataNoteAabbaPreflight(_ data: [INoteResponse], _ event: EventList) {
        if data.count > 0 {
            var payloadNoteAabba = [NoteAabbaPostList]()
            
            for item in data {
                var posts = [NotePostList]()
                
                if (item.post_count as NSString).integerValue > 0 {
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
                        newPost.voted = post.voted
                        newPost.type = "preflight"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = item.post_count
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "preflight"
                newObj.posts = NSSet(array: posts)
                
                payloadNoteAabba.append(newObj)
                
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
            
            do {
                event.noteAabbaPostList = NSSet(array: payloadNoteAabba + (event.noteAabbaPostList ?? []))
                try service.container.viewContext.save()
                print("saved data event aabba successfully")
            } catch {
                print("Failed to data event aabba save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()

            }
            
            self.dataNoteAabbaPreflight = readDataNoteAabbaPostList("preflight")
        }
    }
    
    func initDataNoteAabbaDepature(_ data: [INoteResponse], _ event: EventList) {
        if data.count > 0 {
            var payloadNoteAabba = [NoteAabbaPostList]()
            
            for item in data {
                var posts = [NotePostList]()
                
                if (item.post_count as NSString).integerValue > 0 {
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
                        newPost.voted = post.voted
                        newPost.type = "departure"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = item.post_count
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "departure"
                newObj.posts = NSSet(array: posts)
                
                payloadNoteAabba.append(newObj)
                
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
            
            do {
                event.noteAabbaPostList = NSSet(array: payloadNoteAabba + (event.noteAabbaPostList ?? []))
                try service.container.viewContext.save()
                print("saved data event aabba successfully")
            } catch {
                print("Failed to data event aabba save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()

            }

            self.dataNoteAabbaDeparture = readDataNoteAabbaPostList("departure")
        }
    }
    
    func initDataNoteAabbaEnroute(_ data: [INoteResponse], _ event: EventList) {
        if data.count > 0 {
            var payloadNoteAabba = [NoteAabbaPostList]()
            
            for item in data {
                var posts = [NotePostList]()
                
                if (item.post_count as NSString).integerValue > 0 {
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
                        newPost.voted = post.voted
                        newPost.type = "enroute"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = item.post_count
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "enroute"
                newObj.posts = NSSet(array: posts)
                
                payloadNoteAabba.append(newObj)
                
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
            
            do {
                event.noteAabbaPostList = NSSet(array: payloadNoteAabba + (event.noteAabbaPostList ?? []))
                try service.container.viewContext.save()
                print("saved data event aabba successfully")
            } catch {
                print("Failed to data event aabba save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()

            }

            self.dataNoteAabbaEnroute = readDataNoteAabbaPostList("enroute")
        }
    }
    
    func initDataNoteAabbaArrival(_ data: [INoteResponse], _ event: EventList) {
        if data.count > 0 {
            var payloadNoteAabba = [NoteAabbaPostList]()
            
            for item in data {
                var posts = [NotePostList]()
                
                if (item.post_count as NSString).integerValue > 0 {
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
                        newPost.voted = post.voted
                        newPost.type = "arrival"
                        newPost.comments = NSSet(array: comments)
                        posts.append(newPost)
                    }
                }
                
                let newObj = NoteAabbaPostList(context: service.container.viewContext)

                newObj.id = UUID()
                newObj.postCount = item.post_count
                newObj.latitude = item.lat
                newObj.longitude = item.long
                newObj.name = item.name
                newObj.type = "arrival"
                newObj.posts = NSSet(array: posts)
                
                payloadNoteAabba.append(newObj)
                
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
            
            do {
                event.noteAabbaPostList = NSSet(array: payloadNoteAabba + (event.noteAabbaPostList ?? []))
                try service.container.viewContext.save()
                print("saved data event aabba successfully")
            } catch {
                print("Failed to data event aabba save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()

            }

            self.dataNoteAabbaArrival = readDataNoteAabbaPostList("arrival")
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
    
    func initDataEventDateRange(_ events: [IDateRangeResponse]) {
        for item in events {
            var dateRange: ClosedRange<Date> {
                let startDate = self.dateFormatter.date(from: item.startDate) ?? Date()
                let endDate = self.dateFormatter.date(from: item.endDate) ?? Date()
                return startDate...endDate
            }
            
            self.dateRange.append(dateRange)
            
            let event = EventDateRangeList(context: service.container.viewContext)
            event.id = UUID()
            event.startDate = item.startDate
            event.endDate = item.endDate
            
            service.container.viewContext.performAndWait {
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved event date range successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save event date range: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
    }
    
    func insertDataNotams(airport: String, type: String, category: String, item: INotamWXChildJson) {
        if let eventList = self.selectedEvent {
            let newObj = NotamsDataList(context: self.service.container.viewContext)
            newObj.id = UUID()
            newObj.airport = airport
            newObj.type = type
            newObj.notam = item.notam
            newObj.date = item.date
            newObj.rank = item.rank
            newObj.isChecked = false
            newObj.category = category
            
            eventList.notamsDataList = NSSet(array: (eventList.notamsDataList ?? []) + [newObj])
            
            self.service.container.viewContext.performAndWait {
                do {
                    try self.service.container.viewContext.save()
                    print("saved notams successfully")
                } catch {
                    print("Failed to Notams depNotams save: \(error)")
                }
                
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
    
    func initDataFlightNotams(_ data: [String: [NotamV30Json]], _ event: EventList) {
        if data.count > 0 {
            var payloadNotamsData = [NotamsDataList]()
            
            for row in data {
                if row.value.count > 0 {
                    row.value.forEach { item in
                        let newObj = NotamsDataList(context: self.service.container.viewContext)
                        newObj.id = UUID()
                        
                        if item.type == "departure" {
                            newObj.type = "depNotams"
                        } else if item.type == "arrival" {
                            newObj.type = "arrNotams"
                        } else if item.type == "enroute" {
                            newObj.type = "enrNotams"
                        } else {
                            newObj.type = "altnNotams"
                        }
                        
                        newObj.airport = row.key
                        newObj.notam = item.notam
                        newObj.date = item.date
                        newObj.rank = item.rank
                        newObj.isChecked = item.isChecked
                        newObj.category = item.category
                        
                        payloadNotamsData.append(newObj)
                        
                        self.service.container.viewContext.performAndWait {
                            do {
                                try self.service.container.viewContext.save()
                                print("saved notams successfully")
                            } catch {
                                print("Failed to Notams depNotams save: \(error)")
                            }
                            
                        }
                    }
                }
            }
            
            do {
                event.notamsDataList = NSSet(array: payloadNotamsData)
                try self.service.container.viewContext.save()
                print("saved notams successfully")
            } catch {
                print("Failed to Notams depNotams save: \(error)")
            }
            
            self.dataDepartureNotamsRef = self.readDataNotamsByType("depNotams")
            self.dataEnrouteNotamsRef = self.readDataNotamsByType("enrNotams")
            self.dataArrivalNotamsRef = self.readDataNotamsByType("arrNotams")
            self.dataDestinationNotamsRef = self.readDataNotamsByType("destNotams")
        }
    }
    
    func initDataFlightMetarTaf(_ data: [String: [MetarTafV30Json]],_ event: EventList) {
        if data.count > 0 {
            var payloadMetarTaf = [MetarTafDataList]()
            
            for row in data {
                if row.value.count > 0 {
                    row.value.forEach { item in
                        let newObj = MetarTafDataList(context: self.service.container.viewContext)
                        newObj.id = UUID()

                        if row.key == "departure" {
                            newObj.type = "depMetarTaf"
                        } else if row.key == "arrival" {
                            newObj.type = "arrMetarTaf"
                        } else if row.key == "enroute_alternates" {
                            newObj.type = "enrMetarTaf"
                        } else {
                            newObj.type = "altnMetarTaf"
                        }

                        newObj.airport = item.airportText
                        newObj.std = ""
                        newObj.metar = item.metar
                        newObj.taf = item.taf
                        
                        payloadMetarTaf.append(newObj)
                        
                        self.service.container.viewContext.performAndWait {
                            do {
                                try self.service.container.viewContext.save()
                                print("saved notams successfully")
                            } catch {
                                print("Failed to Notams depNotams save: \(error)")
                            }

                        }
                    }
                }
            }
            
            do {
                event.metarTafList = NSSet(array: payloadMetarTaf)
                try self.service.container.viewContext.save()
                print("saved notams successfully")
            } catch {
                print("Failed to Notams depNotams save: \(error)")
            }
            
//            self.dataDepartureMetarTaf = self.readDataMetarTafByType("depMetarTaf")
//            self.dataEnrouteMetarTaf = self.readDataMetarTafByType("enrMetarTaf")
//            self.dataArrivalMetarTaf = self.readDataMetarTafByType("arrMetarTaf")
//            self.dataDestinationMetarTaf = self.readDataMetarTafByType("altnMetarTaf")
        }
    }
    
    func initDepDataMetarTaf(_ metarTafData: IDepMetarTafWXChild, type: String) {
        do {
            if let eventList = self.selectedEvent {
                let newObj = MetarTafDataList(context: service.container.viewContext)
                newObj.id = UUID()
                newObj.airport = metarTafData.airport
                newObj.std = metarTafData.std
                newObj.metar = metarTafData.metar
                newObj.taf = metarTafData.taf
                newObj.type = type
                
                eventList.metarTafList = NSSet(array: (eventList.metarTafList ?? []) + [newObj])
                
                try service.container.viewContext.save()
                print("saved Metar Taf successfully")
            }
        } catch {
            print("Failed to Metar Taf save: \(error)")
            existDataMetarTaf = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initArrDataMetarTaf(_ metarTafData: IArrMetarTafWXChild, type: String) {
        do {
            if let eventList = self.selectedEvent {
                let newObj = MetarTafDataList(context: service.container.viewContext)
                newObj.id = UUID()
                newObj.airport = metarTafData.airport
                newObj.std = metarTafData.sta
                newObj.metar = metarTafData.metar
                newObj.taf = metarTafData.taf
                newObj.type = type
                
                eventList.metarTafList = NSSet(array: (eventList.metarTafList ?? []) + [newObj])
                
                try service.container.viewContext.save()
                print("saved Metar Taf successfully")
            }
        } catch {
            print("Failed to Metar Taf save: \(error)")
            existDataMetarTaf = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initEnrDataMetarTaf(_ metarTafData: [IAltnMetarTafWXChild], type: String) {
        do {
            if let eventList = self.selectedEvent {
                var temp = [MetarTafDataList]()
                
                for item in metarTafData  {
                    let newObj = MetarTafDataList(context: service.container.viewContext)
                    newObj.id = UUID()
                    newObj.airport = item.airport
                    newObj.std = item.eta
                    newObj.metar = item.metar
                    newObj.taf = item.taf
                    newObj.type = type
                    
                    temp.append(newObj)
                    service.container.viewContext.performAndWait {
                        do {
                            try service.container.viewContext.save()
                            print("saved Metar Taf successfully")
                        } catch {
                            print("Failed to Metar Taf save: \(error)")
                            existDataMetarTaf = false
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
                    }
                }
                
                eventList.metarTafList = NSSet(array: (eventList.metarTafList ?? []) + temp)
                try service.container.viewContext.save()
                print("saved Metar Taf Enr/Altn successfully")
            }
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
    
    func readFlightOverview() -> FlightOverviewList? {
        // create a temp array to save fetched notes
        var data: FlightOverviewList?
        // initialize the fetch request
        let request: NSFetchRequest<FlightOverviewList> = FlightOverviewList.fetchRequest()
        // fetch with the request
        do {
            let response = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                data = response.first
            }
        } catch {
            print("Could not fetch flight overview from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readFlightOverviewList() -> [FlightOverviewList] {
        // create a temp array to save fetched notes
        var data: [FlightOverviewList] = []
        // initialize the fetch request
        let request: NSFetchRequest<FlightOverviewList> = FlightOverviewList.fetchRequest()
        // fetch with the request
        do {
            let response = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                data = response
            }
        } catch {
            print("Could not fetch flight overview from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readFlightOverviewById(_ id: UUID) -> FlightOverviewList? {
        // create a temp array to save fetched notes
        var data: FlightOverviewList?
        // initialize the fetch request
        let request: NSFetchRequest<FlightOverviewList> = FlightOverviewList.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        // fetch with the request
        do {
            let response = try service.container.viewContext.fetch(request)
            if response.count > 0 {
                data = response.first
            }
        } catch {
            print("Could not fetch flight overview from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readDataRouteMapList() -> [MapRouteList] {
        // create a temp array to save fetched notes
        var data: [MapRouteList] = []
        // initialize the fetch request
        let request: NSFetchRequest<MapRouteList> = MapRouteList.fetchRequest()
        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch Map Route from Core Data.")
        }
        
        // return results
        return data
    }
    
    func readNoteList() -> [NoteList] {
        return self.selectedEvent?.noteList?.allObjects as? [NoteList] ?? []
    }
    
    
    func read(_ target: String = "preflight", predicateFormat: String? = "type = %@", fetchLimit: Int? = nil) -> [NoteList] {
        var temp: [NoteList] = []
        
        if let data = self.selectedEvent?.noteList?.allObjects as? [NoteList] {
            if(data.count > 0) {
                for item in data {
                    if item.type == target {
                        temp.append(item)
                    }
                }
            }
        }
        return temp
    }
    
    func readClipBoard(_ target: String = "preflight", predicateFormat: String? = "type = %@", fetchLimit: Int? = nil) -> [NoteList] {
        var temp: [NoteList] = []
        
        if let data = self.selectedEvent?.noteList?.allObjects as? [NoteList] {
            if(data.count > 0) {
                for item in data {
                    if item.type == target && item.isDefault {
                        temp.append(item)
                    }
                }
            }
        }
        return temp
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
        var temp = [NotamsDataList]()
        
        if let data = self.selectedEvent?.notamsDataList?.allObjects as? [NotamsDataList], data.count > 0 {
            for item in data {
                if item.type == target && item.isChecked {
                    temp.append(item)
                }
            }
        }
        
        return temp
    }
    
    func readDataNotamsList() -> [NotamsDataList] {
//        var data: [NotamsDataList] = []
//
//        let request: NSFetchRequest<NotamsDataList> = NotamsDataList.fetchRequest()
//        do {
//            let response: [NotamsDataList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                data = response
//            }
//        } catch {
//            print("Could not fetch notams from Core Data.")
//        }
//
//        return data
        return self.selectedEvent?.notamsDataList?.allObjects as? [NotamsDataList] ?? []
    }
    
    func readDataNotamsRefList() -> [NotamsDataList] {
//        var data: [NotamsDataList] = []
//
//        let request: NSFetchRequest<NotamsDataList> = NotamsDataList.fetchRequest()
//        do {
//            let response: [NotamsDataList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                response.forEach {item in
//                    if item.isChecked {
//                        data.append(item)
//                    }
//                }
//            }
//        } catch {
//            print("Could not fetch notams from Core Data.")
//        }
//
//        return data
        var temp: [NotamsDataList] = []
        
        if let data = self.selectedEvent?.notamsDataList?.allObjects as? [NotamsDataList] {
            if(data.count > 0) {
                data.forEach {item in
                    if item.isChecked {
                        temp.append(item)
                    }
                }
            }
        }
        return temp
    }
    
    func readDataMetarTafByType(_ target: String = "") -> MetarTafDataList? {
        var temp: MetarTafDataList?
        
        if let data = self.selectedEvent?.metarTafList?.allObjects as? [MetarTafDataList], data.count > 0 {
            for item in data {
                if item.type == target {
                    temp = item
                }
            }
        }
        
        return temp
        
//        var data: MetarTafDataList?
//
//        let request: NSFetchRequest<MetarTafDataList> = MetarTafDataList.fetchRequest()
//
//        if target != "" {
//            request.predicate = NSPredicate(format: "type == %@", argumentArray: [target, 1])
//        }
//        do {
//            let response: [MetarTafDataList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                data = response.first
//            }
//        } catch {
//            print("Could not fetch notams from Core Data.")
//        }
//
//        return data
    }
    
    func readDataMetarTafList() -> [MetarTafDataList] {
        var data: [MetarTafDataList] = []
        
        let request: NSFetchRequest<MetarTafDataList> = MetarTafDataList.fetchRequest()
        do {
            let response: [MetarTafDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
                existDataMetarTaf = true
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
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
    
    func readUser() -> UserProfileList? {
        var data: UserProfileList?
        
        let request: NSFetchRequest<UserProfileList> = UserProfileList.fetchRequest()
        do {
            let response: [UserProfileList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
        
        return data
    }
    
    func readUserProfileById(_ id: String) -> UserProfileList? {
        var data: UserProfileList?
        
        let request: NSFetchRequest<UserProfileList> = UserProfileList.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", id)
        do {
            let response: [UserProfileList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
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
        return self.selectedEvent?.waypointMapList?.allObjects  as? [WaypointMapList] ?? []
    }
    
    func readDataAirportMapList() -> [AirportMapList] {
        return self.selectedEvent?.airportMapList?.allObjects  as? [AirportMapList] ?? []
    }
    
    func readDataAirportMapColorList() -> [AirportMapColorList] {
        return self.selectedEvent?.airportMapColorList?.allObjects as? [AirportMapColorList] ?? []
//        var data: [AirportMapColorList] = []
//
//        let request: NSFetchRequest<AirportMapColorList> = AirportMapColorList.fetchRequest()
//        do {
//            let response: [AirportMapColorList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                data = response
//            }
//        } catch {
//            print("Could not fetch Airport List Color from Core Data.")
//        }
//
//        return data
    }
    
    func readDataTrafficMapList() -> [TrafficMapList] {
        return self.selectedEvent?.trafficMapList?.allObjects as? [TrafficMapList] ?? []
//        var data: [TrafficMapList] = []
//
//        let request: NSFetchRequest<TrafficMapList> = TrafficMapList.fetchRequest()
//        do {
//            let response: [TrafficMapList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                data = response
//            }
//        } catch {
//            print("Could not fetch Traffic List from Core Data.")
//        }
//
//        return data
    }
    
    func readDataAabbaMapList() -> [AabbaMapList] {
        print("self.selectedEvent?.aabbaMapList--------\(self.selectedEvent?.aabbaMapList)")
        return self.selectedEvent?.aabbaMapList?.allObjects as? [AabbaMapList] ?? []
    }
    
    func readDataNoteAabbaPostList(_ target: String = "", predicateFormat: String? = "type = %@") -> [NoteAabbaPostList] {
        var temp = [NoteAabbaPostList]()
        
        if let data = self.selectedEvent?.noteAabbaPostList?.allObjects as? [NoteAabbaPostList], data.count > 0 {
            if target == "" {
                return data
            }
            
            for item in data {
                if item.type == target {
                    temp = [item]
                }
            }
        }
        return temp
    }

    
    func readDataPostList(_ target: String = "", _ ref: String = "") -> [NotePostList] {
        var temp: [NotePostList] = []
        
        if let noteAabbaPostList = self.selectedEvent?.noteAabbaPostList?.allObjects as? [NoteAabbaPostList], noteAabbaPostList.count > 0 {
            
            let data = noteAabbaPostList.first(where: { $0.type == target })
            
            if let posts = data?.posts?.allObjects as? [NotePostList] {
                for item in posts {
                    if ref != "" {
                        if item.type == target && item.fromParent {
                            temp.append(item)
                        }
                    } else {
                        if item.type == target {
                            temp.append(item)
                        }
                    }
                }
            }
        }
        return temp
//        var data: [NotePostList] = []
//
//        let request: NSFetchRequest<NotePostList> = NotePostList.fetchRequest()
//
//        // define filter and/or limit if needed
//        if target != "" {
//
//            if ref != "" {
//                request.predicate = NSPredicate(format: "type == %@ AND fromParent == %@", argumentArray: [target, 1])
//            } else {
//                request.predicate = NSPredicate(format: "type == %@", target)
//            }
//
//        }
//
//        do {
//            let response: [NotePostList] = try service.container.viewContext.fetch(request)
//            if(response.count > 0) {
//                data = response
//            }
//        } catch {
//            print("Could not fetch Note Aabba Post List from Core Data.")
//        }
//
//        return data
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
    
    func readDataRecencyDocument() -> [RecencyDocumentList] {
        var data: [RecencyDocumentList] = []
        
        let request: NSFetchRequest<RecencyDocumentList> = RecencyDocumentList.fetchRequest()
        do {
            let response: [RecencyDocumentList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Recency Document from Core Data.")
        }
        
        return data
    }
    
    func readDataRecencyExperience() -> [RecencyExperienceList] {
        var data: [RecencyExperienceList] = []
        
        let request: NSFetchRequest<RecencyExperienceList> = RecencyExperienceList.fetchRequest()
        do {
            let response: [RecencyExperienceList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Recency Document from Core Data.")
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
    
    func readDataAlternateById(_ id: UUID) -> RouteAlternateList? {
        var data: RouteAlternateList?
        
        let request: NSFetchRequest<RouteAlternateList> = RouteAlternateList.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let response: [RouteAlternateList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch Recency Expiry from Core Data.")
        }
        
        return data
    }
    
    func readDataRecencyDocumentById(_ id: UUID) -> RecencyDocumentList? {
        var data: RecencyDocumentList?
        
        let request: NSFetchRequest<RecencyDocumentList> = RecencyDocumentList.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let response: [RecencyDocumentList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch Recency Document from Core Data.")
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
    
    func deleteAllHistoricalDelays() async {
        let fetchRequest: NSFetchRequest<HistoricalDelaysList>
        fetchRequest = HistoricalDelaysList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
    
    func deleteAllHistoricalDelaysRef() async {
        let fetchRequest: NSFetchRequest<HistorycalDelaysRefList>
        fetchRequest = HistorycalDelaysRefList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
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
    
    func deleteAllProjDelays() async {
        let fetchRequest: NSFetchRequest<ProjDelaysList>
        fetchRequest = ProjDelaysList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
    
    func deleteAllProjDelaysRef() async {
        let fetchRequest: NSFetchRequest<ProjDelaysListRef>
        fetchRequest = ProjDelaysListRef.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
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
                    
                    service.container.viewContext.performAndWait {
                        do {
                            // Persist the data in this managed object context to the underlying store
                            try service.container.viewContext.save()
                            arr.append(newObjRef)
                            order += 1
                            print("saved successfully")
                        } catch {
                            // Something went wrong 😭
                            print("Failed to data route save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
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
                    
                    service.container.viewContext.performAndWait {
                        do {
                            // Persist the data in this managed object context to the underlying store
                            try service.container.viewContext.save()
                            arr1.append(newObjRef)
                            order1 += 1
                            print("saved successfully")
                        } catch {
                            // Something went wrong 😭
                            print("Failed to data route save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
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
                    
                    service.container.viewContext.performAndWait {
                        do {
                            // Persist the data in this managed object context to the underlying store
                            try service.container.viewContext.save()
                            arr2.append(newObjRef)
                            order2 += 1
                            print("saved successfully")
                        } catch {
                            // Something went wrong 😭
                            print("Failed to data route save: \(error)")
                            // Rollback any changes in the managed object context
                            service.container.viewContext.rollback()
                            
                        }
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
    
    func deleteAllProjTaxi() async {
        let fetchRequest: NSFetchRequest<FuelTaxiList>
        fetchRequest = FuelTaxiList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
    
    func deleteAllProjTaxiRef() async {
        let fetchRequest: NSFetchRequest<FuelTaxiRefList>
        fetchRequest = FuelTaxiRefList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
    
    func readTrackFlown() -> [FuelTrackFlownList] {
        var data = [FuelTrackFlownList]()
        
        let request: NSFetchRequest<FuelTrackFlownList> = FuelTrackFlownList.fetchRequest()
        do {
            let response: [FuelTrackFlownList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        return data
    }
    
    func initTrackFlown(_ data: [String: [ITrackFlownFlightModel]]) {
        for row in data {
            if row.value.count > 0 {
                for item in row.value {
                    let newObject = FuelTrackFlownList(context: self.service.container.viewContext)
                    newObject.id = UUID()
                    newObject.name = item.name
                    newObject.latitude = item.lat
                    newObject.longitude = item.long
                    newObject.type = row.key
                    
                    self.service.container.viewContext.performAndWait {
                        do {
                            try self.service.container.viewContext.save()
                            print("Saved Track Flown successfully")
                        } catch {
                            print("Failed to save Track Flown: \(error)")
                        }

                    }
                }
            }
        }
            
    }
    
    func deleteAllTrackFlown() async {
        let fetchRequest: NSFetchRequest<FuelTrackFlownList>
        fetchRequest = FuelTrackFlownList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
    
    func deleteAllRecencyList() async {
        let fetchRequest: NSFetchRequest<RecencyList>
        fetchRequest = RecencyList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
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
    
    func readSignature() -> SignatureList? {
        let request: NSFetchRequest<SignatureList> = SignatureList.fetchRequest()
        do {
            let response: [SignatureList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                return response.first
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        return nil
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
                
                service.container.viewContext.performAndWait {
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjRef)
                        order += 1
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to data route save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
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
                
                service.container.viewContext.performAndWait {
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjRef)
                        order1 += 1
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to data route save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
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
                
                service.container.viewContext.performAndWait {
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjRef)
                        order2 += 1
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to data route save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
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
    
    func deleteAllFlightLevel() async {
        let fetchRequest: NSFetchRequest<FuelFlightLevelList>
        fetchRequest = FuelFlightLevelList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
    
    func deleteAllFlightLevelRef() async {
        let fetchRequest: NSFetchRequest<FuelFlightLevelRefList>
        fetchRequest = FuelFlightLevelRefList.fetchRequest()
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
                    print("Failed to delete Proj Taxi : \(error)")
                }
            }
        } catch {
            print("Failed to Delete Proj Taxi: \(error)")
        }
    }
//    func updateFlightPlan() {
//        Task {
//            // do your job here
//
//            let summaryPageData = [
//                "pob": dataSummaryInfo.pob ?? "",
//                "perActualZFW": dataFlightPlan?.perActualZFW ?? "",
//                "perActualTOW": dataFlightPlan?.perActualTOW ?? "",
//                "perActualLDW": dataFlightPlan?.perActualLDW ?? "",
//                "includedArrDelays": dataFuelExtra.includedArrDelays,
//                "includedFlightLevel": dataFuelExtra.includedFlightLevel,
//                "includedEnrWx": dataFuelExtra.includedEnrWx,
//                "includedReciprocalRwy": dataFuelExtra.includedReciprocalRwy,
//                "includedTaxi": dataFuelExtra.includedTaxi,
//                "includedTrackShortening": dataFuelExtra.includedTrackShortening,
//                "includedZFWchange": dataFuelExtra.includedZFWchange,
//                "includedOthers": dataFuelExtra.includedOthers,
//                "selectedArrDelays": dataFuelExtra.selectedArrDelays,
//                "selectedTaxi": dataFuelExtra.selectedTaxi,
//                "selectedTrackShortening": dataFuelExtra.selectedTrackShortening,
//                "selectedFlightLevel000": dataFuelExtra.selectedFlightLevel000,
//                "selectedFlightLevel00": dataFuelExtra.selectedFlightLevel00,
//                "selectedEnrWx": dataFuelExtra.selectedEnrWx,
//                "selectedReciprocalRwy": dataFuelExtra.selectedReciprocalRwy,
//                "selectedOthers000": dataFuelExtra.selectedOthers000,
//                "selectedOthers00": dataFuelExtra.selectedOthers00,
//                "remarkArrDelays": dataFuelExtra.remarkArrDelays ?? "",
//                "remarkTaxi": dataFuelExtra.remarkTaxi ?? "",
//                "remarkFlightLevel": dataFuelExtra.remarkFlightLevel ?? "",
//                "remarkTrackShortening": dataFuelExtra.remarkTrackShortening,
//                "remarkEnrWx": dataFuelExtra.remarkEnrWx,
//                "remarkReciprocalRwy": dataFuelExtra.remarkReciprocalRwy,
//                "remarkZFWChange": dataFuelExtra.remarkZFWChange,
//                "remarkOthers": dataFuelExtra.remarkOthers
//            ]
//
//            let departurePageData = [
//                "atis": [
//                    "code": dataDepartureAtis.unwrappedCode,
//                    "time": dataDepartureAtis.unwrappedTime,
//                    "rwy": dataDepartureAtis.unwrappedRwy,
//                    "translvl": dataDepartureAtis.unwrappedRranslvl,
//                    "wind": dataDepartureAtis.unwrappedWind,
//                    "vis": dataDepartureAtis.unwrappedVis,
//                    "wx": dataDepartureAtis.unwrappedWx,
//                    "cloud": dataDepartureAtis.unwrappedCloud,
//                    "temp": dataDepartureAtis.unwrappedTemp,
//                    "dp": dataDepartureAtis.unwrappedDp,
//                    "qnh": dataDepartureAtis.unwrappedQnh,
//                    "remarks": dataDepartureAtis.unwrappedRemarks
//                ],
//                "atc": [
//                    "atcDep": dataDepartureAtc.unwrappedAtcDep,
//                    "atcSQ": dataDepartureAtc.unwrappedAtcSQ,
//                    "atcRte": dataDepartureAtc.unwrappedAtcRte,
//                    "atcFL": dataDepartureAtc.unwrappedAtcFL,
//                    "atcRwy": dataDepartureAtc.unwrappedAtcRwy
//                ],
//                "entries": [
//                    "entOff": dataDepartureEntries.unwrappedEntOff,
//                    "entFuelInTanks": dataDepartureEntries.unwrappedEntFuelInTanks,
//                    "entTaxi": dataDepartureEntries.unwrappedEntTaxi,
//                    "entTakeoff": dataDepartureEntries.unwrappedEntTakeoff
//                ]
//            ]
//
//            var enroutePageData = []
//
//            dataFPEnroute.forEach { item in
//                enroutePageData.append([
//                    "Cord": item.unwrappedCord,
//                    "Diff": item.unwrappedDiff,
//                    "Dis": item.unwrappedDis,
//                    "Drm": item.unwrappedDrm,
//                    "Gsp": item.unwrappedGsp,
//                    "Imt": item.unwrappedImt,
//                    "Msa": item.unwrappedMsa,
//                    "Pdn": item.unwrappedPdn,
//                    "Pfl": item.unwrappedPfl,
//                    "Pfrm": item.unwrappedPfrm,
//                    "aWind": item.unwrappedAwind,
//                    "actm": item.unwrappedActm,
//                    "adn": item.unwrappedAdn,
//                    "afl": item.unwrappedAfl,
//                    "afrm": item.unwrappedAfrm,
//                    "ata": item.unwrappedAta,
//                    "eta": item.unwrappedEta,
//                    "fDiff": item.unwrappedFdiff,
//                    "fWind": item.unwrappedFwind,
//                    "oat": item.unwrappedOat,
//                    "posn": item.unwrappedPosn,
//                    "tas": item.unwrappedTas,
//                    "vws": item.unwrappedVws,
//                    "zfrq": item.unwrappedZfrq,
//                    "ztm": item.unwrappedZtm
//                ])
//            }
//
//            let arrivalPageData = [
//                "atis": [
//                    "code": dataArrivalAtis.unwrappedCode,
//                    "time": dataArrivalAtis.unwrappedTime,
//                    "rwy": dataArrivalAtis.unwrappedRwy,
//                    "translvl": dataArrivalAtis.unwrappedTransLvl,
//                    "wind": dataArrivalAtis.unwrappedWind,
//                    "vis": dataArrivalAtis.unwrappedVis,
//                    "wx": dataArrivalAtis.unwrappedWx,
//                    "cloud": dataArrivalAtis.unwrappedCloud,
//                    "temp": dataArrivalAtis.unwrappedTemp,
//                    "dp": dataArrivalAtis.unwrappedDp,
//                    "qnh": dataArrivalAtis.unwrappedQnh,
//                    "remarks": dataArrivalAtis.unwrappedRemarks
//                ],
//                "atc": [
//                    "atcDest": dataArrivalAtc.unwrappedAtcDest,
//                    "atcRwy": dataArrivalAtc.unwrappedAtcRwy,
//                    "atcArr": dataArrivalAtc.unwrappedAtcArr,
//                    "atcTransLvl": dataArrivalAtc.unwrappedAtcTransLvl
//                ],
//                "entries": [
//                    "entLdg": dataArrivalEntries.unwrappedEntLdg,
//                    "entFuelOnChocks": dataArrivalEntries.unwrappedEntFuelOnChocks,
//                    "entOn": dataArrivalEntries.unwrappedEntOn
//                ]
//            ]
//
//            let payload = [
//                "company": "Test Company",
//                "fltno": dataSummaryInfo.unwrappedPlanNo,
//                "flightDate": dataSummaryInfo.unwrappedFlightDate,
//                "summaryPageData": summaryPageData,
//                "departurePageData": departurePageData,
//                "enroutePageData": enroutePageData,
//                "arrivalPageData": arrivalPageData
//            ]
//
//            await self.remoteService.updateFuelData(payload, completion: { success in
//                if(success) {
//                    self.isUpdating = false
//                }
//            })
//        }
//    }
    
    
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
    
    func readEventDateRange() -> [EventDateRangeList] {
        var data: [EventDateRangeList] = []
        
        let request: NSFetchRequest<EventDateRangeList> = EventDateRangeList.fetchRequest()
        
        do {
            let response: [EventDateRangeList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
            }
        } catch {
            print("Could not fetch Event Date Range from Core Data.")
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
    
    func readEventsById(_ id: UUID) -> EventList? {
        var data: EventList?
        
        let request: NSFetchRequest<EventList> = EventList.fetchRequest()
        
        do {
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            let response: [EventList] = try service.container.viewContext.fetch(request)
            
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch Event from Core Data.")
        }
        
        return data
    }
    
    // Parameter is flight number
    func readEventsByName(flight: String = "") -> EventList? {
        var data: EventList?
        
        let request: NSFetchRequest<EventList> = EventList.fetchRequest()
        
        do {
            request.predicate = NSPredicate(format: "name == %@", flight)
            let response: [EventList] = try service.container.viewContext.fetch(request)
            
            if(response.count > 0) {
                data = response.first
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
    
    func getSignature(_ flightNumber: String = "") -> SignatureList? {
        var data: SignatureList?
        
        let request: NSFetchRequest<SignatureList> = SignatureList.fetchRequest()
        request.predicate = NSPredicate(format: "flightNumber == %@", flightNumber)
        
        do {
            let response: [SignatureList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response.first
            }
        } catch {
            print("Could not fetch AISearch from Core Data.")
        }
        
        return data
    }
    
    func deleteAllTrafficMap() async {
        if let objects = self.selectedEvent?.trafficMapList?.allObjects as? [TrafficMapList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Traffic Map List: \(error)")
                }
            }
        }
    }
    
    func deleteAllMapAabbaCommentList() async {
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
    
    func deleteAllMapAabbaPostList() async {
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
    
    func deleteAllMapAabbMapList() async {
        if let objects = self.selectedEvent?.aabbaMapList?.allObjects as? [AabbaMapList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        if let posts = object.posts?.allObjects as? [AabbaPostList], posts.count > 0 {
                            for post in posts {
                                if let comments = post.comments?.allObjects as? [AabbaCommentList], comments.count > 0 {
                                    
                                    for comment in comments {
                                        service.container.viewContext.delete(comment)
                                    }
                                }
                                service.container.viewContext.delete(post)
                            }
                            
                        }
                        service.container.viewContext.delete(object)
                    }
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Airport Map Color List: \(error)")
                }
            }
        }
    }
    
    // For Aabba Note
    func deleteAllAabbaNoteCommentList() async {
        let fetchRequest: NSFetchRequest<NoteCommentList>
        fetchRequest = NoteCommentList.fetchRequest()
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
                    print("Failed to delete Aabba Note Comment: \(error)")
                }
            }
        } catch {
            print("Failed to Delete Aabba Note Comment: \(error)")
        }
    }
    
    func deleteAllAabbaNotePostList() async {
        let fetchRequest: NSFetchRequest<NoteAabbaPostList>
        fetchRequest = NoteAabbaPostList.fetchRequest()
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
                    print("Failed to delete Note Aabba Post List: \(error)")
                }
            }
        } catch {
            print("Failed to Delete Note Aabba Post List: \(error)")
        }
    }
    
    func deleteAllAabbaNoteList(_ event: EventList) async {
        do {
            if let objects = event.noteAabbaPostList?.allObjects as? [NoteAabbaPostList] {
                service.container.viewContext.performAndWait {
                    do {
                        for object in objects {
                            service.container.viewContext.delete(object)
                            
                            if let posts = object.posts?.allObjects as? [NotePostList] {
                                for post in posts {
                                    service.container.viewContext.delete(post)
////                                    service.container.viewContext.delete(post.comments as? NSManagedObject ?? [)
//
//                                    if let comments = post.comments?.allObjects as? [NoteCommentList] {
//                                        for comment in comments {
//                                            service.container.viewContext.delete(comment)
//                                        }
//                                    }
                                }
                            }
                            
//                            service.container.viewContext.delete(object.posts)
                        }
                        
                        // Save the deletions to the persistent store
                        try service.container.viewContext.save()
                    } catch {
                        print("Failed to delete Note Post List : \(error)")
                    }
                }
            }
        } catch {
            print("Failed to Delete Note Post List: \(error)")
        }
    }
    
    func deleteAllWaypointList() async {
        if let objects = self.selectedEvent?.waypointMapList?.allObjects as? [WaypointMapList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Waypoint List: \(error)")
                }
            }
        }
    }
    
    func deleteAllAirportList() async {
        if let objects = self.selectedEvent?.airportMapList?.allObjects as? [AirportMapList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Airport Map List: \(error)")
                }
            }
        }
    }
    
    func deleteAllAirportColorList() async {
        if let objects = self.selectedEvent?.airportMapColorList?.allObjects as? [AirportMapColorList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Airport Map Color List: \(error)")
                }
            }
        }
    }
    
    func deleteAllMetarTaf() async {
        if let objects = self.selectedEvent?.metarTafList?.allObjects as? [MetarTafDataList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        service.container.viewContext.delete(object)
                    }
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Metar Taf List: \(error)")
                }
            }
        }
        
//        let fetchRequest: NSFetchRequest<MetarTafDataList>
//        fetchRequest = MetarTafDataList.fetchRequest()
//        do {
//            // Perform the fetch request
//            let objects = try service.container.viewContext.fetch(fetchRequest)
//
//            service.container.viewContext.performAndWait {
//                do {
//                    for object in objects {
//                        service.container.viewContext.delete(object)
//                    }
//
//                    // Save the deletions to the persistent store
//                    try service.container.viewContext.save()
//                } catch {
//                    print("Failed to delete Metar Taf : \(error)")
//                }
//            }
//        } catch {
//            print("Failed to Delete Metar Taf update: \(error)")
//        }
    }
    
    func deleteAllNotam() async {
        if let objects = self.selectedEvent?.notamsDataList?.allObjects as? [NotamsDataList] {
            service.container.viewContext.performAndWait {
                do {
                    for object in objects {
                        print("object======\(object)")
                        do {
                            try service.container.viewContext.delete(object)
                        } catch {
                            print("Failed to delete Notam : \(error)")
                        }
                    }
                    // Save the deletions to the persistent store
                    try service.container.viewContext.save()
                } catch {
                    print("Failed to delete Notam : \(error)")
                }
            }
        }
//        let fetchRequest: NSFetchRequest<NotamsDataList>
//        fetchRequest = NotamsDataList.fetchRequest()
//        do {
//            // Perform the fetch request
//            let objects = try service.container.viewContext.fetch(fetchRequest)
//
//            service.container.viewContext.performAndWait {
//                do {
//                    for object in objects {
//                        service.container.viewContext.delete(object)
//                    }
//
//                    // Save the deletions to the persistent store
//                    try service.container.viewContext.save()
//                } catch {
//                    print("Failed to delete Notam : \(error)")
//                }
//            }
//        } catch {
//            print("Failed to Delete Notam update: \(error)")
//        }
    }
    
    func extractExpiringDocuments(expiryData: [RecencyDocumentList], monthsAhead: Int) -> [DocumentExpiry] {
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
                                                            type: row.unwrappedType,
                                                            expiryDate: dateFormatter.string(from: expiryDate))
                        expiringDocuments.append(documentExpiry)
                    }
                }
            }
            
            return expiringDocuments
        }
        
        return []
    }
    
    @MainActor
    func syncDataFlightStats(_ parameters: Any, callback: @escaping (_ response: Bool) -> Void) async {
        
        let dataResponse = await remoteService.getFlightStatsData(parameters)
        
        await self.deleteAllProjTaxi()
        await self.deleteAllProjTaxiRef()
        await self.deleteAllFlightLevel()
        await self.deleteAllFlightLevelRef()
        await self.deleteAllTrackFlown()
        await self.deleteAllHistoricalDelays()
        await self.deleteAllHistoricalDelaysRef()
        await self.deleteAllProjDelays()
        await self.deleteAllProjDelaysRef()
//        let async serviceProjTaxi = self.deleteAllProjTaxi()
//        let async serviceProjTaxiRef = self.deleteAllProjTaxiRef()
//        let async serviceFlightLevel = self.deleteAllFlightLevel()
//        let async serviceFlightLevelRef = self.deleteAllFlightLevelRef()
//        let async serviceTrackFlown = self.deleteAllTrackFlown()
//        let async serviceHistoricalDelays = self.deleteAllHistoricalDelays()
//        let async serviceHistoricalDelaysRef = self.deleteAllHistoricalDelaysRef()
//        let async serviceProjDelays = self.deleteAllProjDelays()
//        let async serviceProjDelaysRef = self.deleteAllProjDelaysRef()
//
//        await [serviceProjTaxi, serviceProjTaxiRef, serviceFlightLevel, serviceFlightLevelRef, serviceTrackFlown, serviceHistoricalDelays, serviceHistoricalDelaysRef, serviceProjDelays, serviceProjDelaysRef]
        
        if let taxi = dataResponse?.taxi {
            initProjTaxi(taxi)
        }
        
        if let flightLevel = dataResponse?.flightLevel {
            initFlightLevel(flightLevel)
        }
        
        if let trackFlown = dataResponse?.trackFlown {
            initTrackFlown(trackFlown)
        }
        
        if let historicalDelays = dataResponse?.historicalDelays {
            initHistoricalDelays(historicalDelays)
        }
        
        if let projDelays = dataResponse?.projDelays {
            initProjDelays(projDelays)
        }
        
        callback(true)
        
    }
    
    func prepareRouteAlternate() {
        let data = readDataAlternate()
        var enrAirport: [String: String] = [:]
        var destAirport: [String: String] = [:]
        var depAirport: [String: String] = [:]
        var arrAirport: [String: String] = [:]
        
        for item in data {
            if item.type == "enroute" {
                enrAirport[item.unwrappedAltn] = item.unwrappedEta
            } else {
                destAirport[item.unwrappedAltn] = item.unwrappedEta
            }
        }
        
        depAirport["date"] = dataFlightOverview?.unwrappedStd
        arrAirport["date"] = dataFlightOverview?.unwrappedSta
        
        self.enrAirportNotam = enrAirport
        self.destAirportNotam = destAirport
        self.depAirportNotam = depAirport
        self.arrAirportNotam = arrAirport
    }
    
    func prepareRouteAlternateByType() -> (enrouteAlternates: [RouteAlternateList], destinationAlternates: [RouteAlternateList]) {
        var enrouteAlternates = [RouteAlternateList]()
        var destinationAlternates = [RouteAlternateList]()
        
        if let dataAlternate = self.selectedEvent?.routeAlternate?.allObjects as? [RouteAlternateList], dataAlternate.count > 0 {
            for item in dataAlternate {
                if item.type == "enroute" {
                    enrouteAlternates.append(item)
                } else {
                    destinationAlternates.append(item)
                }
                
            }
        }
        
        return (enrouteAlternates: enrouteAlternates, destinationAlternates: destinationAlternates)
    }
}
