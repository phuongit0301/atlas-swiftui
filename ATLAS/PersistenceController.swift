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
    
    // For Perf Info
    @Published var dataPerfInfo: [PerfInfoList] = []
    @Published var existDataPerfInfo: Bool = false
    
    @Published var perfChangesTable: [perfChanges] = []
    
    // For Perf Weight
    @Published var dataPerfWeight: [PerfWeightList] = []
    @Published var existDataPerfWeight: Bool = false
    
    // For Perf Weight
    @Published var dataFuelList: [FuelTableList] = []
    @Published var existDataFuelList: Bool = false
    
    // For Fuel Extra
    @Published var dataFuelExtra: FuelExtraList = FuelExtraList()
    @Published var existDataFuelExtra: Bool = false
    
    // For Fuel Extra
    @Published var dataAltnList: [AltnDataList] = []
    
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
        dataPerfInfo = readPerfInfo()
        dataPerfWeight = readPerfWeight()
        dataFuelExtra = readFuelExtra()
        dataAltnList = readAltnList()
    }
    
    func checkAndSyncData() async {
        let response = read()
        dataFPEnroute = readEnrouteList()
        readSummaryInfo()
        readSummaryRoute()
        readPerfInfo()
        readPerfWeight()
        dataFuelList = readFuelList()
        dataFuelExtra = readFuelExtra()
        dataAltnList = readAltnList()
        
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
        
        if !existDataPerfInfo {
            initDataPerfInfo()
        }
        
        if !existDataPerfWeight {
            initDataPerfWeight()
        }
        
        if dataFuelList.count == 0 {
            initDataFuelList()
        }
        
        if dataAltnList.count == 0 {
            initDataAltn()
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
    
    func initDataPerfInfo() {
        let newObj = PerfInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.fltRules = "RVSM"
        newObj.gndMiles = "6385"
        newObj.airMiles = "7004"
        newObj.crzComp = "M42"
        newObj.apd = "1.4"
        newObj.ci = "100"
        newObj.zfwChange = "557"
        newObj.lvlChange = "500"
        
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
    
    func initDataPerfWeight() {
        let newObj1 = PerfWeightList(context: service.container.viewContext)
        newObj1.id = UUID()
        newObj1.weight = "ZFW"
        newObj1.plan = "143416"
        newObj1.actual = ""
        newObj1.max = "161025"
        newObj1.limitation = "Structural"
        
        let newObj2 = PerfWeightList(context: service.container.viewContext)
        newObj2.id = UUID()
        newObj2.weight = "TOW"
        newObj2.plan = "227883"
        newObj2.actual = ""
        newObj2.max = "227930"
        newObj2.limitation = "Perf - Obstacle"
        
        let newObj3 = PerfWeightList(context: service.container.viewContext)
        newObj3.id = UUID()
        newObj3.weight = "LDW"
        newObj3.plan = "151726"
        newObj3.actual = ""
        newObj3.max = "172365"
        newObj3.limitation = "Structural"
        
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
    
    func initDataFuelList() {
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
        
        dataFuelList = readFuelList()
//        let newObj1 = FuelTableList(context: service.container.viewContext)
//        newObj1.id = UUID()
//        newObj1.firstColumn = "(A) Burnoff"
//        newObj1.time = fuelData.burnoff["time"]!
//        newObj1.fuel = fuelData.burnoff["fuel"]!
//        newObj1.policyReason = ""
//
//        let newObj2 = FuelTableList(context: service.container.viewContext)
//        newObj2.id = UUID()
//        newObj2.firstColumn = "(B) Contingency Fuel"
//        newObj2.time = fuelData.cont["time"]!
//        newObj2.fuel = fuelData.cont["fuel"]!
//        newObj2.policyReason = fuelData.cont["policy"]!
//
//        let newObj3 = FuelTableList(context: service.container.viewContext)
//        newObj3.id = UUID()
//        newObj3.firstColumn = "(C) Altn Fuel"
//        newObj3.time = fuelData.altn["time"]!
//        newObj3.fuel = fuelData.altn["fuel"]!
//        newObj3.policyReason = ""
//
//        let newObj4 = FuelTableList(context: service.container.viewContext)
//        newObj4.id = UUID()
//        newObj4.firstColumn = "(D) Altn Hold"
//        newObj4.time = fuelData.hold["time"]!
//        newObj4.fuel = fuelData.hold["fuel"]!
//        newObj4.policyReason = ""
//
//        let newObj5 = FuelTableList(context: service.container.viewContext)
//        newObj5.id = UUID()
//        newObj5.firstColumn = "(E) 60min Topup Fuel"
//        newObj5.time = fuelData.topup60["time"]!
//        newObj5.fuel = fuelData.topup60["fuel"]!
//        newObj5.policyReason = ""
//
//        let newObj6 = FuelTableList(context: service.container.viewContext)
//        newObj6.id = UUID()
//        newObj6.firstColumn = "(F) Taxi Fuel"
//        newObj6.time = fuelData.taxi["time"]!
//        newObj6.fuel = fuelData.taxi["fuel"]!
//        newObj6.policyReason = fuelData.taxi["policy"]!
//
//        let newObj7 = FuelTableList(context: service.container.viewContext)
//        newObj7.id = UUID()
//        newObj7.firstColumn = "(G) Flight Plan Requirement (A + B + C + D + E + F)"
//        newObj7.time = fuelData.planReq["time"]!
//        newObj7.fuel = fuelData.planReq["fuel"]!
//        newObj7.policyReason = ""
//
//        let newObj8 = FuelTableList(context: service.container.viewContext)
//        newObj8.id = UUID()
//        newObj8.firstColumn = "(H) Dispatch Additional Fuel"
//        newObj8.time = fuelData.dispAdd["time"]!
//        newObj8.fuel = fuelData.dispAdd["fuel"]!
//        newObj8.policyReason = fuelData.dispAdd["policy"]!
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
    
    func initDataAltn() {
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
    
    func readFuelList() -> [FuelTableList] {
        var data: [FuelTableList] = []
        
        let request: NSFetchRequest<FuelTableList> = FuelTableList.fetchRequest()
        do {
            let response: [FuelTableList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                data = response
                existDataFuelList = true
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
    
    func readFuelExtra() -> FuelExtraList {
        var data: FuelExtraList = FuelExtraList()
        
        let request: NSFetchRequest<FuelExtraList> = FuelExtraList.fetchRequest()
        do {
            let response: [FuelExtraList] = try service.container.viewContext.fetch(request)
            if(response.count > 0) {
                if let item = response.first {
                    data = item
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
        
        return data
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
    
    func calculatedZFWFuel(_ perfData: PerfData) -> Int {
        if let item = self.dataPerfWeight.first(where: {$0.weight == "ZFW"}) {
            let actual = Double(item.unwrappedActual) ?? Double(0)
            return Int(Double(actual - Double(perfData.planZFW)!) * Double(Double(perfData.zfwChange)! / 1000))
        }
        return 0
    }
}
