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


let perfData = PerfData(fltRules: "RVSM", gndMiles: "6385", airMiles: "7004", crzComp: "M42", apd: "1.4", ci: "100", zfwChange: "557", lvlChange: "500", planZFW: "143416", maxZFW: "161025", limZFW: "Structural", planTOW: "227883", maxTOW: "227930", limTOW: "Perf - Obstacle", planLDW: "151726", maxLDW: "172365", limLDW: "Structural")

class CoreDataModelState: ObservableObject {
    var remoteService = RemoteService.shared
    let service = PersistenceController.shared
    
    @Published var loading: Bool = false
    @Published var tagList: [TagList] = []
    @Published var aircraftArray: [NoteList] = []
    @Published var departureArray: [NoteList] = []
    @Published var enrouteArray: [NoteList] = []
    @Published var arrivalArray: [NoteList] = []
    @Published var aircraftRefArray: [NoteList] = []
    @Published var departureRefArray: [NoteList] = []
    @Published var enrouteRefArray: [NoteList] = []
    @Published var arrivalRefArray: [NoteList] = []
    @Published var dataFlightPlan: FlightPlanList?
    
    // For summary info
    @Published var dataSummaryInfo: SummaryInfoList!
    @Published var existDataSummaryInfo: Bool = false
    
    // For summary route
    @Published var dataSummaryRoute: SummaryRouteList!
    @Published var existDataSummaryRoute: Bool = false
    
    // For Perf Info
    @Published var dataPerfInfo: [PerfInfoList] = []
    @Published var existDataPerfInfo: Bool = false
    
    @Published var perfChangesTable: [perfChanges] = []
    
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
    @Published var dataNotams: NotamsDataList!
    @Published var existDataNotams: Bool = false
    
    // For Metar Taf
    @Published var dataMetarTaf: MetarTafDataList!
    @Published var existDataMetarTaf: Bool = false
    
    // For Metar Taf
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
    
    init() {
        Task {
            await remoteService.getFlightPlanWX(completion: { data in
                DispatchQueue.main.async {
                    if let waypointsData = data?.waypointsData {
                        self.dataFPEnroute = self.readEnrouteList()
                        if self.dataFPEnroute.count == 0 {
                            self.initDataEnroute(waypointsData)
                        }
                    }
                    //
                    if let infoData = data?.infoData {
                        if !self.existDataSummaryInfo {
                            self.initDataSummaryInfo(infoData)
                        }
                    }
                    
                    if let routeData = data?.routeData {
                        if !self.existDataSummaryRoute {
                            self.initDataSummaryRoute(routeData)
                        }
                    }
                    
                    if let perfData = data?.perfData {
                        if !self.existDataPerfData {
                            self.initDataPerfData(perfData)
                        }
                        
                        if !self.existDataPerfInfo {
                            self.initDataPerfInfo(perfData)
                        }
                        
                        self.dataPerfWeight = self.readPerfWeight()
                        
                        if self.dataPerfWeight.count == 0 {
                            self.initDataPerfWeight(perfData)
                        }
                    }
                    
                    if let fuelData = data?.fuelData {
                        if !self.existDataFuelDataList {
                            self.initDataFuelList(fuelData)
                        }
                    }
                    
                    if let altnData = data?.altnData {
                        self.dataAltnList = self.readAltnList()
                        if self.dataAltnList.count == 0 {
                            self.initDataAltn(altnData)
                        }
                    }
                    
                    if let notamsData = data?.notamsData {
                        if !self.existDataNotams {
                            self.initDataNotams(notamsData)
                        }
                    }
                    
                    if let metarTafData = data?.metarTafData {
                        if !self.existDataMetarTaf {
                            self.initDataTaf(metarTafData)
                        }
                        
                        self.dataAltnTaf = self.readDataAltnTafList()
                        if self.dataAltnTaf.count == 0 {
                            self.initDataAltnTaf(metarTafData)
                        }
                    }
                    
                    print("Fetch data")
                }
            })
            
//            DispatchQueue.main.async {
//                self.initFetchData()
//            }
        }
    }
    
    func initFetchData() async {
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
        dataFPEnroute = readEnrouteList()
//        readFlightPlan()
        readSummaryInfo()
        readSummaryRoute()
        readPerfData()
        dataPerfInfo = readPerfInfo()
        dataPerfWeight = readPerfWeight()
        readFuelDataList()
        dataFuelTableList = readFuelTableList()
        readFuelExtra()
        dataAltnList = readAltnList()
        readDepartureAtc()
        readDepartureAtis()
        readDepartureEntries()
        readArrivalAtc()
        readArrivalAtis()
        readArrivalEntries()
        readDataNotamsList()
        readDataMetarTafList()
        dataAltnTaf = readDataAltnTafList()
    }
    
    func checkAndSyncData() async {
        let response = read()
//        dataFPEnroute = readEnrouteList()
//        dataSummaryInfo = readSummaryInfo()
//        dataSummaryRoute = readSummaryRoute()
//        dataPerfData = readPerfData()
//        dataPerfInfo = readPerfInfo()
//        dataPerfWeight = readPerfWeight()
//        dataFuelTableList = readFuelTableList()
//        dataFuelExtra = readFuelExtra()
//        dataAltnList = readAltnList()
//        dataNotams = readDataNotamsList()
//        dataMetarTaf = readDataMetarTafList()
//        dataAltnTaf = readDataAltnTafList()
        
        if response.count == 0 {
            //            initDataTag()
            initData()
        }
        
//        if dataFPEnroute.count == 0 {
//            initDataEnrouteLocal()
//            dataFPEnroute = readEnrouteList()
//        }
//
//        if !existDataSummaryInfo {
//            initDataSummaryInfoLocal()
//            dataSummaryInfo = readSummaryInfo()
//        }
//
//        if !existDataSummaryRoute {
//            initDataSummaryRouteLocal()
//            dataSummaryRoute = readSummaryRoute()
//        }
//
//        if !existDataPerfData {
//            initDataPerfDataLocal()
//            dataPerfData = readPerfData()
//        }
//
//        if !existDataPerfInfo {
//            initDataPerfInfoLocal()
//            dataPerfInfo = readPerfInfo()
//        }
//
//        if !existDataPerfWeight {
//            initDataPerfWeightLocal()
//            dataPerfWeight = readPerfWeight()
//        }
//
//        if dataFuelTableList.count == 0 {
//            initDataFuelListLocal()
//            dataFuelTableList = readFuelTableList()
//        }
//
//        if dataAltnList.count == 0 {
//            initDataAltnLocal()
//            dataAltnList = readAltnList()
//        }
//
//        if !existDataNotams {
//            initDataNotamsLocal()
//            dataNotams = readDataNotamsList()
//        }
//
//        if !existDataMetarTaf || dataAltnTaf.count == 0 {
//            initDataTafLocal()
//            readDataMetarTafList()
//            readDataAltnTafList()
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
                print("saved successfully")
            } catch {
                // Something went wrong 😭
                print("Failed to save: \(error)")
                // Rollback any changes in the managed object context
                service.container.viewContext.rollback()
                
            }
        }
    }
    
    func initDataEnrouteLocal() {
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
    
    func initDataSummaryInfoLocal() {
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
    
    func initDataSummaryRouteLocal() {
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
    
    func initDataPerfDataLocal() {
        let newObj = PerfDataList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.fltRules = perfData.fltRules
        newObj.gndMiles = perfData.gndMiles
        newObj.airMiles = perfData.airMiles
        newObj.crzComp = perfData.crzComp
        newObj.apd = perfData.apd
        newObj.ci = perfData.ci
        newObj.zfwChange = perfData.zfwChange
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
            print("saved perf info successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataPerfInfoLocal() {
        let newObj = PerfInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.fltRules = perfData.fltRules
        newObj.gndMiles = perfData.gndMiles
        newObj.airMiles = perfData.airMiles
        newObj.crzComp = perfData.crzComp
        newObj.apd = perfData.apd
        newObj.ci = perfData.ci
        newObj.zfwChange = "M1000KG BURN LESS \(perfData.zfwChange)KG"
        newObj.lvlChange = "P2000FT BURN LESS \(perfData.lvlChange)KG"
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            print("saved perf info successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataPerfWeightLocal() {
        let perfWeightsTable = [
            perfWeights(weight: "ZFW", plan: perfData.planZFW, actual: "", max: perfData.maxZFW, limitation: perfData.limZFW),
            perfWeights(weight: "TOW", plan: perfData.planTOW, actual: "", max: perfData.maxTOW, limitation: perfData.limTOW),
            perfWeights(weight: "LDW", plan: perfData.planLDW, actual: "", max: perfData.maxLDW, limitation: perfData.limLDW),
        ]
        
        perfWeightsTable.forEach { item in
            let newObj = PerfWeightList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.weight = item.weight
            newObj.plan = item.plan
            newObj.actual = ""
            newObj.max = item.max
            newObj.limitation = item.limitation
            
            service.container.viewContext.performAndWait {
                do {
                    try service.container.viewContext.save()
                    print("saved perf weight successfully")
                } catch {
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
    }
    
    func initDataFuelListLocal() {
        let fuelData = FuelData(burnoff: ["time": "14:21", "fuel": "076157", "unit": "100"], cont: ["time": "00:34", "fuel": "003000", "policy": "5%"], altn: ["time": "00:42", "fuel": "003279", "unit": "100"], hold: ["time": "00:30", "fuel": "002031", "unit": "100"], topup60: ["time": "00:00", "fuel": "000000"], taxi: ["time": "N.A", "fuel": "000500", "policy": "7mins std taxi time", "unit": "100"], planReq: ["time": "16:07", "fuel": "084967"], dispAdd: ["time": "00:10", "fuel": "000600", "policy": "PER COMPANY POLICY FOR SINBER FLIGHTS"])
        
        let fuelTable = [
            fuel(firstColumn: "(A) Burnoff", time: fuelData.burnoff["time"]!, fuel: fuelData.burnoff["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(B) Contingency Fuel", time: fuelData.cont["time"]!, fuel: fuelData.cont["fuel"]!, policy_reason: fuelData.cont["policy"]!),
            fuel(firstColumn: "(C) Altn Fuel", time: fuelData.altn["time"]!, fuel: fuelData.altn["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(D) Altn Hold", time: fuelData.hold["time"]!, fuel: fuelData.hold["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(E) 60min Topup Fuel", time: fuelData.topup60["time"]!, fuel: fuelData.topup60["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(F) Taxi Fuel", time: fuelData.taxi["time"]!, fuel: fuelData.taxi["fuel"]!, policy_reason: fuelData.taxi["policy"]!),
            fuel(firstColumn: "(G) Flight Plan Requirement (A + B + C + D + E + F)", time: fuelData.planReq["time"]!, fuel: fuelData.planReq["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(H) Dispatch Additional Fuel", time: fuelData.dispAdd["time"]!, fuel: fuelData.dispAdd["fuel"]!, policy_reason: fuelData.dispAdd["policy"]!)
        ]
        
        do {
            let newFuelData = FuelDataList(context: service.container.viewContext)
            newFuelData.burnoff = try NSKeyedArchiver.archivedData(withRootObject: fuelData.burnoff, requiringSecureCoding: true)
            
            newFuelData.cont = try NSKeyedArchiver.archivedData(withRootObject: fuelData.cont, requiringSecureCoding: true)
            
            newFuelData.altn = try NSKeyedArchiver.archivedData(withRootObject: fuelData.altn, requiringSecureCoding: true)
            
            newFuelData.hold = try NSKeyedArchiver.archivedData(withRootObject: fuelData.hold, requiringSecureCoding: true)
            
            newFuelData.topup60 = try NSKeyedArchiver.archivedData(withRootObject: fuelData.topup60, requiringSecureCoding: true)
            
            newFuelData.taxi = try NSKeyedArchiver.archivedData(withRootObject: fuelData.taxi, requiringSecureCoding: true)
            
            newFuelData.planReq = try NSKeyedArchiver.archivedData(withRootObject: fuelData.planReq, requiringSecureCoding: true)
            
            newFuelData.dispAdd = try NSKeyedArchiver.archivedData(withRootObject: fuelData.dispAdd, requiringSecureCoding: true)
        } catch {
            print("failed to archive array with error: \(error)")
        }
        
        fuelTable.forEach { item in
            let newObj = FuelTableList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.firstColumn = item.firstColumn
            newObj.time = item.time
            newObj.fuel = item.fuel
            newObj.policyReason = item.policy_reason
            
            service.container.viewContext.performAndWait {
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved perf weight successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
        
        dataFuelTableList = readFuelTableList()
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
    
    func initDataAltnLocal() {
        let altnData = [
            AltnData(altnRwy: "EDDH/15", rte: "EDDB SOGMA1N SOGMA M748 RARUP T909 HAM DCT", vis: "1600", minima: "670", dist: "0190", fl: "220", comp: "M015", time: "0042", fuel: "03279"),
            AltnData(altnRwy: "EDDK/32R", rte: "EDDB ODLUN1N ODLUN DCT ORTAG DCT ERSIL Y221 EBANA T841 ERNEP ERNEP1C", vis: "1600", minima: "800", dist: "0270", fl: "280", comp: "M017", time: "0055", fuel: "04269"),
            AltnData(altnRwy: "EDDL/05L", rte: "EDDB POVEL1N POVEL DCT EXOBA DCT HMM T851 HALME HALME1X", vis: "1600", minima: "550", dist: "0301", fl: "320", comp: "M018", time: "0057", fuel: "04512"),
            AltnData(altnRwy: "EDDF/25L", rte: "EDDB ODLUN1N ODLUN DCT ORTAG DCT ERSIL Y222 FUL T152 KERAX KERAX3A", vis: "1600", minima: "940", dist: "0246", fl: "280", comp: "M014", time: "0049", fuel: "03914")
        ]
        
        altnData.forEach { item in
            let newObj = AltnDataList(context: service.container.viewContext)
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
        }
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            print("saved perf weight successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataNotamsLocal() {
        let notamsData = NotamsData(depNotams: ["""
            A1333/23 NOTAMN
            Q) WSJC/QMXLC/IV/BO/A/000/999/0122N10359E005
            A) WSSS B) 2306161700 C) 2306292100
            D) JUN 16 17 20 22 23 24 27 29 1700-2100
            E) FLW TWY CLSD DUE TO WIP:
            1) TWY J BTN TWY T AND TWY J12, INCLUDING JUNCTION OF TWY J/TWY J12
            AND JUNCTION OF TWY J/TWY B
            2) TWY K BTN TWY T AND TWY J12, INCLUDING JUNCTION OF TWY K/TWY J12
            AND JUNCTION OF TWY K/TWY B
            3) TWY K1, TWY K2 AND TWY K3
            """], enrNotams: ["""
            B0157/23
            Q) EDXX/QAFXX/IV/NBO/E/000/999/5123N01019E262
            A) EDWW  A) EDGG  A) EDMM  B) FROM: 23/02/28 14:29  TO: 23/05/25 23:59 EST
            E) MILITARY INVASION OF UKRAINE BY RUSSIAN FEDERATION:
            
            NOTE 1: ALL AIRCRAFT OWNED, CHARTERED OR OPERATED BY CITIZENS OF THE
            RUSSIAN FEDERATION OR OTHERWISE CONTROLLED BY NATURAL OR LEGAL
            PERSONS OR ENTITY FROM THE RUSSIAN FEDERATION AND OPERATORS HOLDING
            AIR OPERATOR CERTIFICATE (AOC) ISSUED BY THE RUSSIAN FEDERATION
            AUTHORITIES ARE PROHIBITED TO ENTER, EXIT OR OVERFLY GERMAN AIRSPACE
            EXCEPT HUMANITARIAN FLIGHTS WITH THE PERMISSION OF THE GERMAN
            MINISTRY FOR DIGITAL AND TRANSPORT AND IN CASE OF EMERGENCY LANDING
            OR EMERGENCY OVERFLIGHT. REQUESTS FOR HUMANITARIAN FLIGHTS SHALL BE
            SENT TO HUM-FLIGHTS(AT)DFS.DE WITH DATE, EOBT, ADEP AND ADES.
            END PART 1 OF 2
            """], arrNotams: ["""
            A2143/23
            Q) EDWW/QNVAS/IV/BO/AE/000/999/5225N01408E025
            A) EDDB  B) FROM: 23/05/09 10:21  TO: 23/05/11 15:00 EST
            E) FUERSTENWALDE VOR/DME FWE 113.30MHZ/CH80X, VOR PART OUT OF
            SERVICE
            """])
        
        do {
            let newObj = NotamsDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.depNotams = try NSKeyedArchiver.archivedData(withRootObject: notamsData.depNotams, requiringSecureCoding: true)
            newObj.enrNotams = try NSKeyedArchiver.archivedData(withRootObject: notamsData.enrNotams, requiringSecureCoding: true)
            newObj.arrNotams = try NSKeyedArchiver.archivedData(withRootObject: notamsData.arrNotams, requiringSecureCoding: true)
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            print("saved notams successfully")
        } catch {
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataTafLocal() {
        let metarTafData = MetarTafData(depMetar: "METAR WSSS 161320Z AUTO 30011KT 9999 3100 -SHRA SCT026 BKN040 FEW///CB 17/13 Q1015 RESHRA TEMPO SHRA", depTaf: "TAF WSSS 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015", arrMetar: "METAR EDDB 161320Z AUTO 30011KT 9999 3100 -SHRA SCT026 BKN040 FEW///CB 17/13 Q1015 RESHRA TEMPO SHRA", arrTaf: "TAF EDDB 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015", altnTaf: [
            AltnTafData(altnRwy: "EDDH/15", eta: "1742", taf: "TAF EDDH 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015"),
            AltnTafData(altnRwy: "EDDK/32R", eta: "1755", taf: "TAF EDDK 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015"),
            AltnTafData(altnRwy: "EDDL/05L", eta: "1757", taf: "TAF EDDL 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015"),
            AltnTafData(altnRwy: "EDDF/25L", eta: "1749", taf: "TAF EDDF 161100Z 1612/1712 31009KT 9999 SCT020 BKN030 PROB40 TEMPO 1612/1620 31015G25KT 3000 TSRA BKN025CB BECMG 1617/1619 28004KT TEMPO 1620/1624 BKN012 BECMG 1700/1702 BKN010 PROB30 TEMPO 1701/1706 4000 BR BKN005 BECMG 1706/1709 BKN015")
        ])
        
        do {
            let newObj = MetarTafDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.depMetar = metarTafData.depMetar
            newObj.depTaf = metarTafData.depTaf
            newObj.arrMetar = metarTafData.arrMetar
            newObj.arrTaf = metarTafData.arrTaf
            try service.container.viewContext.save()
            
            print("saved Metar Taf successfully")
        } catch {
            print("Failed to save: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
        
        
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
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
    }
    
    func initDataEnroute(_ initDataEnroute: [IEnrouteDataResponseModel]) {
        initDataEnroute.forEach { item in
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
            newObject.awind = item.awind
            newObject.tas = item.tas
            newObject.vws = item.vws
            newObject.zfrq = item.zfrq
            newObject.afrm = item.afrm
            newObject.cord = item.cord
            newObject.msa = item.msa
            newObject.dis = item.dis
            newObject.diff = item.diff
            newObject.pfl = item.pfl
            newObject.imt = item.imt
            newObject.pdn = item.pdn
            newObject.fwind = item.fwind
            newObject.gsp = item.gsp
            newObject.drm = item.drm
            newObject.pfrm = item.pfrm
            newObject.fdiff = item.fdiff
            
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
    }
    
    func initDataSummaryInfo(_ infoData: IInfoDataResponseModel) {
        let newObj = SummaryInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.planNo = infoData.planNo
        newObj.fltNo = infoData.fltNo
        newObj.tailNo = infoData.tailNo
        newObj.dep = infoData.dep
        newObj.dest = infoData.dest
        newObj.depICAO = infoData.depICAO
        newObj.destICAO = infoData.destICAO
        newObj.flightDate = infoData.flightDate
        newObj.stdUTC = infoData.stdUTC
        newObj.staUTC = infoData.staUTC
        newObj.stdLocal = infoData.stdLocal
        newObj.staLocal = infoData.staLocal
        newObj.blkTime = infoData.blkTime
        newObj.fltTime = infoData.fltTime
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataSummaryInfo = true
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
            print("saved summary route successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to summary route save: \(error)")
            existDataSummaryRoute = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
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
        newObj.zfwChange = perfData.zfwChange
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
            print("saved perf info successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to perf data save: \(error)")
            existDataPerfData = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataPerfInfo(_ perfData: IPerfDataResponseModel) {
        let newObj = PerfInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.fltRules = perfData.fltRules
        newObj.gndMiles = perfData.gndMiles
        newObj.airMiles = perfData.airMiles
        newObj.crzComp = perfData.crzComp
        newObj.apd = perfData.apd
        newObj.ci = perfData.ci
        newObj.zfwChange = "M1000KG BURN LESS \(perfData.zfwChange)KG"
        newObj.lvlChange = "P2000FT BURN LESS \(perfData.lvlChange)KG"
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataPerfInfo = true
            print("saved perf info successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to perf info save: \(error)")
            existDataPerfInfo = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataPerfWeight(_ perfData: IPerfDataResponseModel) {
        let perfWeightsTable = [
            perfWeights(weight: "ZFW", plan: "\(perfData.planZFW)", actual: "", max: perfData.maxZFW ?? "", limitation: perfData.limZFW ?? ""),
            perfWeights(weight: "TOW", plan: "\(perfData.planTOW)", actual: "", max: "\(perfData.maxTOW)", limitation: perfData.limTOW ?? ""),
            perfWeights(weight: "LDW", plan: "\(perfData.planLDW)", actual: "", max: "\(perfData.maxLDW)", limitation: perfData.limLDW ?? ""),
        ]
        
        perfWeightsTable.forEach { item in
            let newObj = PerfWeightList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.weight = item.weight
            newObj.plan = item.plan
            newObj.actual = ""
            newObj.max = item.max
            newObj.limitation = item.limitation
            
            service.container.viewContext.performAndWait {
                do {
                    try service.container.viewContext.save()
                    print("saved perf weight successfully")
                } catch {
                    print("Failed to perf weight save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
        existDataPerfWeight = true
    }
    
    func initDataFuelList(_ fuelData: IFuelDataResponseModel) {
        let fuelTable = [
            fuel(firstColumn: "(A) Burnoff", time: fuelData.burnoff["time"] ?? "", fuel: fuelData.burnoff["fuel"] ?? "", policy_reason: ""),
            fuel(firstColumn: "(B) Contingency Fuel", time: fuelData.cont["time"] ?? "", fuel: fuelData.cont["fuel"] ?? "", policy_reason: fuelData.cont["policy"]!),
            fuel(firstColumn: "(C) Altn Fuel", time: fuelData.altn["time"] ?? "", fuel: fuelData.altn["fuel"] ?? "", policy_reason: ""),
            fuel(firstColumn: "(D) Altn Hold", time: fuelData.hold["time"] ?? "", fuel: fuelData.hold["fuel"] ?? "", policy_reason: ""),
            fuel(firstColumn: "(E) 60min Topup Fuel", time: fuelData.topup60["time"] ?? "", fuel: fuelData.topup60["fuel"] ?? "", policy_reason: ""),
            fuel(firstColumn: "(F) Taxi Fuel", time: fuelData.taxi["time"] ?? "", fuel: fuelData.taxi["fuel"] ?? "", policy_reason: fuelData.taxi["policy"]!),
            fuel(firstColumn: "(G) Flight Plan Requirement (A + B + C + D + E + F)", time: fuelData.planReq["time"] ?? "", fuel: fuelData.planReq["fuel"] ?? "", policy_reason: ""),
            fuel(firstColumn: "(H) Dispatch Additional Fuel", time: fuelData.dispAdd["time"] ?? "", fuel: fuelData.dispAdd["fuel"] ?? "", policy_reason: fuelData.dispAdd["policy"]!)
        ]
        
        do {
            let newFuelData = FuelDataList(context: service.container.viewContext)
            newFuelData.id = UUID()
            newFuelData.burnoff = try NSKeyedArchiver.archivedData(withRootObject: fuelData.burnoff, requiringSecureCoding: true)
            
            newFuelData.cont = try NSKeyedArchiver.archivedData(withRootObject: fuelData.cont, requiringSecureCoding: true)
            
            newFuelData.altn = try NSKeyedArchiver.archivedData(withRootObject: fuelData.altn, requiringSecureCoding: true)
            
            newFuelData.hold = try NSKeyedArchiver.archivedData(withRootObject: fuelData.hold, requiringSecureCoding: true)
            
            newFuelData.topup60 = try NSKeyedArchiver.archivedData(withRootObject: fuelData.topup60, requiringSecureCoding: true)
            
            newFuelData.taxi = try NSKeyedArchiver.archivedData(withRootObject: fuelData.taxi, requiringSecureCoding: true)
            
            newFuelData.planReq = try NSKeyedArchiver.archivedData(withRootObject: fuelData.planReq, requiringSecureCoding: true)
            
            newFuelData.dispAdd = try NSKeyedArchiver.archivedData(withRootObject: fuelData.dispAdd, requiringSecureCoding: true)
            
            try service.container.viewContext.save()
            existDataFuelDataList = true
        } catch {
            existDataFuelDataList = false
            print("failed to fuel data save: \(error)")
        }
        
        fuelTable.forEach { item in
            let newObj = FuelTableList(context: self.service.container.viewContext)
            newObj.id = UUID()
            newObj.firstColumn = item.firstColumn
            newObj.time = item.time
            newObj.fuel = item.fuel
            newObj.policyReason = item.policy_reason
            
            service.container.viewContext.performAndWait {
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved perf weight successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to fuel table list save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
        }
        
        dataFuelTableList = readFuelTableList()
    }
    
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
    
    func initDataNotams(_ notamsData: INotamsDataResponseModel) {
        do {
            let newObj = NotamsDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.depNotams = try NSKeyedArchiver.archivedData(withRootObject: notamsData.depNotams, requiringSecureCoding: true)
            newObj.enrNotams = try NSKeyedArchiver.archivedData(withRootObject: notamsData.enrNotams, requiringSecureCoding: true)
            newObj.arrNotams = try NSKeyedArchiver.archivedData(withRootObject: notamsData.arrNotams, requiringSecureCoding: true)
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataNotams = true
            print("saved notams successfully")
        } catch {
            print("Failed to Notams save: \(error)")
            existDataNotams = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataTaf(_ metarTafData: IFlightPlanWXResponseModel) {
        do {
            let newObj = MetarTafDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.depMetar = metarTafData.depMetar
            newObj.depTaf = metarTafData.depTaf
            newObj.arrMetar = metarTafData.arrMetar
            newObj.arrTaf = metarTafData.arrTaf
            try service.container.viewContext.save()
            existDataMetarTaf = true
            print("saved Metar Taf successfully")
        } catch {
            print("Failed to Metar Taf save: \(error)")
            existDataMetarTaf = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
        
        
        
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
        }
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
                }
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
            }
            existDataDepartureAtc = true
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
                    dataDepartureAtis = item
                }
            } else {
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
                    print("saved successfully")
                } catch {
                    // Something went wrong 😭
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            existDataDepartureAtis = true
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
                }
            } else {
                let newObj = DepartureEntriesList(context: service.container.viewContext)
                newObj.entTaxi = ""
                newObj.entTakeoff = ""
                newObj.entOff = ""
                newObj.entFuelInTanks = ""
                
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
            existDataDepartureEntries = true
        } catch {
            print("Could not fetch scratch pad from Core Data.")
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
                let newObject = ArrivalATCList(context: service.container.viewContext)
                newObject.id = UUID()
                newObject.atcDest = ""
                newObject.atcArr = ""
                newObject.atcRwy = ""
                newObject.atcTransLvl = ""
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved successfully")
                } catch {
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            existDataArrivalAtc = true
        } catch {
            print("Could not fetch Arrival ATC from Core Data.")
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
                    print("saved successfully")
                } catch {
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            existDataArrivalAtis = true
        } catch {
            print("Could not fetch Arrival Atis from Core Data.")
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
                let newObject = ArrivalEntriesList(context: service.container.viewContext)
                newObject.id = UUID()
                newObject.entLdg = ""
                newObject.entOn = ""
                newObject.entFuelOnChocks = ""
                
                do {
                    // Persist the data in this managed object context to the underlying store
                    try service.container.viewContext.save()
                    print("saved successfully")
                } catch {
                    print("Failed to save: \(error)")
                    // Rollback any changes in the managed object context
                    service.container.viewContext.rollback()
                    
                }
            }
            existDataArrivalEntries = true
        } catch {
            print("Could not fetch Arrival Entries from Core Data.")
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
        var data: SummaryRouteList!
        
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
    
    func readPerfInfo() -> [PerfInfoList] {
        var data: [PerfInfoList] = []
        
        let request: NSFetchRequest<PerfInfoList> = PerfInfoList.fetchRequest()
        do {
            let response: [PerfInfoList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
                existDataPerfInfo = true
                
                // Init data performance change table
                if let item = response.first {
                    perfChangesTable = [perfChanges(zfwChange: "M1000KG BURN LESS \(item.unwrappedZfwChange)KG", lvlChange: "P2000FT BURN LESS \(item.unwrappedLvlChange)KG")]
                }
            }
        } catch {
            print("Could not fetch scratch pad from Core Data.")
        }
        
        return data
    }
    
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
    
    func readDataNotamsList() {
        let request: NSFetchRequest<NotamsDataList> = NotamsDataList.fetchRequest()
        do {
            let response: [NotamsDataList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    dataNotams = item
                    existDataNotams = true
                }
            }
        } catch {
            print("Could not fetch notams from Core Data.")
        }
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
            let actual = Double(item.unwrappedActual) ?? Double(0)
            var unwrappedPlanZFW: Double = 0
            var unwrappedZfwChange: Double = 0
            
            if let temp = Double(dataPerfData.unwrappedPlanZFW) {
                unwrappedPlanZFW = temp
            }
            
            if let temp = Double(dataPerfData.unwrappedZfwChange) {
                unwrappedZfwChange = temp
            }
            
            return Int(Double(actual - unwrappedPlanZFW) * Double(unwrappedZfwChange / 1000))
        }
        return 0
    }
}

class FuelCoreDataModelState: ObservableObject {
    var remoteService = RemoteService.shared
    let service = PersistenceController.shared
    var globalResponse = GlobalResponse.shared
    
    func checkAndSyncData() async {
        await remoteService.getFuelData(completion: { response in
            if let historicalDelays = response?.historicalDelays {
                DispatchQueue.main.async {
                    self.initHistoricalDelays(historicalDelays)
                }
            }
        })
        
        
    }
    
    func initHistoricalDelays(_ historicalDelays: IHistoricalDelaysModel) {
        do {
                let newObject = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject.id = UUID()
                newObject.delays = try NSKeyedArchiver.archivedData(withRootObject: historicalDelays.days3.delays, requiringSecureCoding: true)
                newObject.arrTimeDelay = historicalDelays.days3.arrTimeDelay
                newObject.arrTimeDelayWX = historicalDelays.days3.arrTimeDelayWX
                newObject.eta = historicalDelays.days3.eta
                newObject.ymax = historicalDelays.days3.ymax
                newObject.type = "days3"
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()

                let newObject1 = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject1.id = UUID()
                newObject1.delays = try NSKeyedArchiver.archivedData(withRootObject: historicalDelays.week1.delays, requiringSecureCoding: true)
                newObject1.arrTimeDelay = historicalDelays.week1.arrTimeDelay
                newObject1.arrTimeDelayWX = historicalDelays.week1.arrTimeDelayWX
                newObject1.eta = historicalDelays.week1.eta
                newObject1.ymax = historicalDelays.week1.ymax
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()

                let newObject2 = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject2.id = UUID()
                newObject2.delays = try NSKeyedArchiver.archivedData(withRootObject: historicalDelays.months3.delays, requiringSecureCoding: true)
                newObject2.arrTimeDelay = historicalDelays.months3.arrTimeDelay
                newObject2.arrTimeDelayWX = historicalDelays.months3.arrTimeDelayWX
                newObject2.eta = historicalDelays.months3.eta
                newObject2.ymax = historicalDelays.months3.ymax
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()


            print("saved successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save Track Miles: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
}
