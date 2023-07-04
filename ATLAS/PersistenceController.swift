//
//  PersistenceController.swift
//  ATLAS
//
//  Created by phuong phan on 21/06/2023.
//

import CoreData

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

class CoreDataModelState: ObservableObject {
    @Published var tagList: [TagList] = []
    @Published var aircraftArray: [NoteList] = []
    @Published var departureArray: [NoteList] = []
    @Published var enrouteArray: [NoteList] = []
    @Published var arrivalArray: [NoteList] = []
    @Published var aircraftRefArray: [NoteList] = []
    @Published var departureRefArray: [NoteList] = []
    @Published var enrouteRefArray: [NoteList] = []
    @Published var arrivalRefArray: [NoteList] = []
    @Published var dataFlightPlan: FlightPlanList = FlightPlanList()
    
    // For summary info
    @Published var dataSummaryInfo: SummaryInfoList = SummaryInfoList()
    @Published var existDataSummaryInfo: Bool = false
    
    // For summary route
    @Published var dataSummaryRoute: SummaryRouteList = SummaryRouteList()
    @Published var existDataSummaryRoute: Bool = false
    
    @Published var existDataFlightPlan: Bool = false
    @Published var dataDepartureAtc: DepartureATCList = DepartureATCList()
    @Published var existDataDepartureAtc: Bool = false
    @Published var dataDepartureAts: DepartureATISList = DepartureATISList()
    @Published var existDataDepartureAts: Bool = false
    @Published var dataDepartureEntries: DepartureEntriesList = DepartureEntriesList()
    @Published var existDataDepartureEntries: Bool = false
    @Published var dataFPEnroute: [EnrouteList] = []
    
    @Published var scratchPadArray: [ScratchPadList] = []
    
    let service = PersistenceController.shared
    
    init() {
        initFetchData()
    }
    
    func initFetchData() {
        tagList = readTag()
        aircraftArray = read("aircraft")
        departureArray = read("departure")
        enrouteArray = read("enroute")
        arrivalArray = read("arrival")
        aircraftRefArray = read("aircraftref")
        departureRefArray = read("departureref")
        enrouteRefArray = read("enrouteref")
        arrivalRefArray = read("arrivalref")
        scratchPadArray = readScratchPad()
        dataFlightPlan = readFlightPlan()
        dataSummaryInfo = readSummaryInfo()
        dataSummaryRoute = readSummaryRoute()
    }
    
    func checkAndSyncData() async {
        let response = read()
        dataFPEnroute = readEnrouteList()
        readSummaryInfo()
        readSummaryRoute()
        
        if response.count == 0 {
            //            initDataTag()
            initData()
        }
        
        if dataFPEnroute.count == 0 {
            initDataEnroute()
        }
        
        if !existDataSummaryInfo {
            initDataSummaryInfo()
        }
        
        if !existDataSummaryRoute {
            initDataSummaryRoute()
        }
        //        do {
        //            let request: NSFetchRequest<NSFetchRequestResult> = NoteList.fetchRequest()
        //            let result = try container.viewContext.fetch(request)
        //            if result.isEmpty {
        //                initData()
        //            }
        //        } catch {
        //            fatalError("Unable to fetch data: \(error.localizedDescription)")
        //        }
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
        
        let newDep1 = NoteList(context: service.container.viewContext)
        newDep1.id = UUID()
        newDep1.name = "All crew to be simulator-qualified for RNP approach"
        newDep1.isDefault = false
        newDep1.canDelete = false
        newDep1.fromParent = false
        newDep1.target = "departure"
        newDep1.tags = NSSet(array: [newTags1])
        
        let newDep2 = NoteList(context: service.container.viewContext)
        newDep2.id = UUID()
        newDep2.name = "Note digital clearance requirements 10mins before pushback"
        newDep2.isDefault = false
        newDep2.canDelete = false
        newDep2.fromParent = false
        newDep2.target = "departure"
        newDep2.tags = NSSet(array: [newTags5])
        
        let newDep3 = NoteList(context: service.container.viewContext)
        newDep3.id = UUID()
        newDep3.name = "Reduce ZFW by 1 ton for preliminary fuel"
        newDep3.isDefault = false
        newDep3.canDelete = false
        newDep3.fromParent = false
        newDep3.target = "departure"
        newDep3.tags = NSSet(array: [newTags1])
        
        let newDep4 = NoteList(context: service.container.viewContext)
        newDep4.id = UUID()
        newDep4.name = "Expected POB: 315"
        newDep4.isDefault = false
        newDep4.canDelete = false
        newDep4.fromParent = false
        newDep4.target = "departure"
        newDep4.tags = NSSet(array: [newTags1])
        
        let newDep5 = NoteList(context: service.container.viewContext)
        newDep5.id = UUID()
        newDep5.name = "Hills to the north of aerodrome"
        newDep5.isDefault = false
        newDep5.canDelete = false
        newDep5.fromParent = false
        newDep5.target = "departure"
        newDep5.tags = NSSet(array: [newTags2])
        
        let newEnroute1 = NoteList(context: service.container.viewContext)
        newEnroute1.id = UUID()
        newEnroute1.name = "Non-standard levels when large scale weather deviation in progress"
        newEnroute1.isDefault = false
        newEnroute1.canDelete = false
        newEnroute1.fromParent = false
        newEnroute1.target = "enroute"
        newEnroute1.tags = NSSet(array: [newTags6])
        
        let newArrival1 = NoteList(context: service.container.viewContext)
        newArrival1.id = UUID()
        newArrival1.name = "Birds in vicinity"
        newArrival1.isDefault = false
        newArrival1.canDelete = false
        newArrival1.fromParent = false
        newArrival1.target = "arrival"
        newArrival1.tags = NSSet(array: [newTags8])
        
        let newArrival2 = NoteList(context: service.container.viewContext)
        newArrival2.id = UUID()
        newArrival2.name = "Any +TS expected to last 15mins"
        newArrival2.isDefault = false
        newArrival2.canDelete = false
        newArrival2.fromParent = false
        newArrival2.target = "arrival"
        newArrival2.tags = NSSet(array: [newTags3])
        
        service.container.viewContext.performAndWait {
            do {
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
                initFetchData()
                print("saved successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
        }
    }
    
    func initDataEnroute() {
        let newObject1 = EnrouteList(context: service.container.viewContext)
        
        newObject1.id = UUID()
        newObject1.posn = "A"
        newObject1.actm = "somestring"
        newObject1.ztm = "00:05"
        newObject1.eta = "0130"
        newObject1.ata =  "0135"
        newObject1.afl = "220"
        newObject1.oat = "M59"
        newObject1.adn = "somestring"
        newObject1.awind =  "25015"
        newObject1.tas = "somestring"
        newObject1.vws = "somestring"
        newObject1.zfrq = "0.3"
        newObject1.afrm = "086.9"
        newObject1.cord = "somestring"
        newObject1.msa = "somestring"
        newObject1.dis = "somestring"
        newObject1.diff = "somestring"
        newObject1.pfl = "somestring"
        newObject1.imt = "somestring"
        newObject1.pdn = "somestring"
        newObject1.fwind = "somestring"
        newObject1.gsp = "somestring"
        newObject1.drm = "somestring"
        newObject1.pfrm = "086.9"
        newObject1.fdiff = "somestring"
        
        let newObject2 = EnrouteList(context: service.container.viewContext)
        newObject2.posn = "B"
        newObject2.actm = "somestring"
        newObject2.ztm = "00:02"
        newObject2.eta = "0135"
        newObject2.ata =  "0140"
        newObject2.afl = "230"
        newObject2.oat = "M60"
        newObject2.adn = "somestring"
        newObject2.awind =  "26527"
        newObject2.tas = "somestring"
        newObject2.vws = "7"
        newObject2.zfrq = "0.2"
        newObject2.afrm = "086.6"
        newObject2.cord = "somestring"
        newObject2.msa = "100*"
        newObject2.dis = "somestring"
        newObject2.diff = "somestring"
        newObject2.pfl = "somestring"
        newObject2.imt = "somestring"
        newObject2.pdn = "somestring"
        newObject2.fwind = "somestring"
        newObject2.gsp = "somestring"
        newObject2.drm = "somestring"
        newObject2.pfrm = "086.6"
        newObject2.fdiff = "somestring"
        
        let newObject3 = EnrouteList(context: service.container.viewContext)
        newObject3.posn = "C"
        newObject3.actm = "somestring"
        newObject3.ztm = "00:03"
        newObject3.eta = "0140"
        newObject3.ata =  "0145"
        newObject3.afl = "240"
        newObject3.oat = "M61"
        newObject3.adn = "somestring"
        newObject3.awind =  "27018"
        newObject3.tas = "somestring"
        newObject3.vws = "somestring"
        newObject3.zfrq = "0.4"
        newObject3.afrm = "086.3"
        newObject3.cord = "somestring"
        newObject3.msa = "70"
        newObject3.dis = "somestring"
        newObject3.diff = "somestring"
        newObject3.pfl = "somestring"
        newObject3.imt = "somestring"
        newObject3.pdn = "somestring"
        newObject3.fwind = "somestring"
        newObject3.gsp = "somestring"
        newObject3.drm = "somestring"
        newObject3.pfrm = "086.3"
        newObject3.fdiff = "somestring"
        
        let newObject4 = EnrouteList(context: service.container.viewContext)
        newObject4.posn = "D"
        newObject4.actm = "somestring"
        newObject4.ztm = "00:01"
        newObject4.eta = "0145"
        newObject4.ata =  "0150"
        newObject4.afl = "250"
        newObject4.oat = "M62"
        newObject4.adn = "somestring"
        newObject4.awind =  "28019"
        newObject4.tas = "somestring"
        newObject4.vws = "3"
        newObject4.zfrq = "0.5"
        newObject4.afrm = "086.2"
        newObject4.cord = "somestring"
        newObject4.msa = "somestring"
        newObject4.dis = "somestring"
        newObject4.diff = "somestring"
        newObject4.pfl = "somestring"
        newObject4.imt = "somestring"
        newObject4.pdn = "somestring"
        newObject4.fwind = "somestring"
        newObject4.gsp = "somestring"
        newObject4.drm = "somestring"
        newObject4.pfrm = "086.2"
        newObject4.fdiff = "somestring"
        
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
    
    func initDataSummaryInfo() {
        let newObj = SummaryInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.planNo = "20"
        newObj.fltNo = "SQ123"
        newObj.tailNo = "9VSHM"
        newObj.dep = "SIN"
        newObj.dest = "BER"
        newObj.depICAO = "WSSS"
        newObj.destICAO = "EDDB"
        newObj.flightDate = "040723"
        newObj.stdUTC = "04 08:00"
        newObj.staUTC = "04 17:00"
        newObj.stdLocal = "04 10:00"
        newObj.staLocal = "04 21:00"
        newObj.blkTime = "09:00"
        newObj.fltTime = "08:45"
        
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
    
    func initDataSummaryRoute() {
        let newObj = SummaryRouteList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.routeNo = "SINBER91"
        newObj.route = "WSSS/20L AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK G582 PUGER P574 UDULO P574 TOTOX L555 TOLDA M628 PEKEM M628 MIGMA M550 MEVDO  Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA UG33 KOROS UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI T204 NUKRO DCT EDDB/25L"
        newObj.depRwy = "WSSS/20L"
        newObj.arrRwy = "EDDB/25L"
        newObj.levels = "SIN/360/UDULO/380/PEKEM/390/MIGMA/400/KEA/410/KOROS/430/TEXTI/380"
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            print("saved summary route successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
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
    
    func readScratchPad() -> [ScratchPadList] {
        // create a temp array to save fetched notes
        var data: [ScratchPadList] = []
        // initialize the fetch request
        let request: NSFetchRequest<ScratchPadList> = ScratchPadList.fetchRequest()

        // fetch with the request
        do {
            data = try service.container.viewContext.fetch(request)
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }

        // return results
        return data
    }
    
    func readFlightPlan() -> FlightPlanList {
        // create a temp array to save fetched notes
        var data: FlightPlanList = FlightPlanList()
        // initialize the fetch request
        let request: NSFetchRequest<FlightPlanList> = FlightPlanList.fetchRequest()
        // fetch with the request
        do {
            let response: [FlightPlanList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    data = item
                    existDataFlightPlan = true
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
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }

        // return results
        return data
    }
    
    func read(_ target: String = "departure", predicateFormat: String? = "target = %@", fetchLimit: Int? = nil) -> [NoteList] {
        // create a temp array to save fetched notes
        var results: [NoteList] = []
        // initialize the fetch request
        let request: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        
        // define filter and/or limit if needed
        if predicateFormat != nil {
            request.predicate = NSPredicate(format: "target == %@", target)
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
                    existDataDepartureAtc = true
                } else {
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
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                    existDataDepartureAtc = false
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
    }
    
    func readDepartureAtis() {
        let request: NSFetchRequest<DepartureATISList> = DepartureATISList.fetchRequest()
        // fetch with the request
        do {
            let response: [DepartureATISList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataDepartureAts = item
                    existDataDepartureAts = true
                } else {
                    let newObj = DepartureATISList(context: service.container.viewContext)
                    newObj.code = ""
                    newObj.time = ""
                    newObj.rwy = ""
                    newObj.translvl = ""
                    newObj.wind = ""
                    newObj.vis = ""
                    newObj.wx = ""
                    newObj.cloud = ""
                    newObj.temp = ""
                    newObj.dp = ""
                    newObj.qnh = ""
                    newObj.remarks = ""
                    
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
                    existDataDepartureAts = false
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
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
                    existDataDepartureEntries = true
                } else {
                    let newObj = DepartureEntriesList(context: service.container.viewContext)
                    newObj.entOff = ""
                    newObj.entFuelInTanks = ""
                    newObj.entTaxi = ""
                    newObj.entTakeoff = ""
                    
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
                    existDataDepartureEntries = false
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
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
    
    func readSummaryInfo() -> SummaryInfoList {
        var data: SummaryInfoList = SummaryInfoList()
        
        let request: NSFetchRequest<SummaryInfoList> = SummaryInfoList.fetchRequest()
        do {
            let response: [SummaryInfoList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    data = item
                    existDataSummaryInfo = true
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        return data
    }
    
    func readSummaryRoute() -> SummaryRouteList {
        var data: SummaryRouteList = SummaryRouteList()
        
        let request: NSFetchRequest<SummaryRouteList> = SummaryRouteList.fetchRequest()
        do {
            let response: [SummaryRouteList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    data = item
                    existDataSummaryRoute = true
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        return data
    }
    
    func calculatedZFWFuel(_ perfData: PerfData) -> Double {
        return Double(Double(self.dataFlightPlan.perActualZFW) - Double(perfData.planZFW)!) * Double(Double(perfData.zfwChange)! / 1000)
    }
}
