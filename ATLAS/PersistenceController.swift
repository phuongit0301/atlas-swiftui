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
    @Published var dataNotams: [NotamsDataList] = []
    @Published var dataNotamsRef: [NotamsDataList] = []
    @Published var existDataNotams: Bool = false
    
    // For Metar Taf
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
    
    @Published var isUpdating: Bool = false
    
    func checkAndSyncData() async {
        dataFPEnroute = readEnrouteList()
        
        if dataFPEnroute.count == 0 {
            await remoteService.getFlightPlanWX(completion: { data in
                DispatchQueue.main.async {
                    if let waypointsData = data?.waypointsData {
                        self.initDataEnroute(waypointsData)
                    }
                    
                    if let infoData = data?.infoData {
                        self.initDataSummaryInfo(infoData)
                    }
                    
                    if let routeData = data?.routeData {
                        self.initDataSummaryRoute(routeData)
                    }
                    
                    if let perfData = data?.perfData {
                        self.initDataPerfData(perfData)
                        
                        self.initDataPerfInfo(perfData)
                        
                        self.dataPerfWeight = self.readPerfWeight()
                        
                        self.initDataPerfWeight(perfData)
                    }
                    
                    if let fuelData = data?.fuelData {
                        self.initDataFuelList(fuelData)
                    }
                    
                    if let altnData = data?.altnData {
                        self.dataAltnList = self.readAltnList()
                        self.initDataAltn(altnData)
                    }
                    
                    if let notamsData = data?.notamsData {
                        self.initDataNotams(notamsData)
                    }
                    
                    if let metarTafData = data?.metarTafData {
                        self.initDataMetarTaf(metarTafData)
                        self.initDataAltnTaf(metarTafData)
                    }
                    
                    print("Fetch data")
                }
            })
        }
    }
    
    func syncDataMetarTaf() async {
        Task {
            await remoteService.getFlightPlanWX(completion: { data in
                if let metarTafData = data?.metarTafData {
                    self.updateDataMetarTaf(metarTafData)
                    self.updateDataAltnTaf(metarTafData)
                }
            })
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
        dataNotams = readDataNotamsList()
        dataNotamsRef = readDataNotamsRefList()
        readDataMetarTafList()
        dataAltnTaf = readDataAltnTafList()
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
        newObj.stdUTC = infoData.STDUTC
        newObj.staUTC = infoData.STAUTC
        newObj.stdLocal = infoData.STDLocal
        newObj.staLocal = infoData.STALocal
        newObj.blkTime = infoData.blkTime
        newObj.fltTime = infoData.fltTime
        
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
    
    func initDataPerfInfo(_ perfData: IPerfDataResponseModel) {
        let newObj = PerfInfoList(context: service.container.viewContext)
        newObj.id = UUID()
        newObj.fltRules = perfData.fltRules
        newObj.gndMiles = perfData.gndMiles
        newObj.airMiles = perfData.airMiles
        newObj.crzComp = perfData.crzComp
        newObj.apd = perfData.apd
        newObj.ci = perfData.ci
        newObj.zfwChange = "M1000KG BURN LESS \(perfData.minus_zfwChange!)KG"
        newObj.lvlChange = "P2000FT BURN LESS \(perfData.lvlChange!)KG"
        
        do {
            // Persist the data in this managed object context to the underlying store
            try service.container.viewContext.save()
            existDataPerfInfo = true
            dataPerfInfo = readPerfInfo()
            print("saved perf info successfully")
        } catch {
            print("Failed to perf info save: \(error)")
            existDataPerfInfo = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataPerfWeight(_ perfData: IPerfDataResponseModel) {
        let perfWeightsTable = [
            perfWeights(weight: "ZFW", plan: perfData.planZFW ?? "", actual: "", max: perfData.maxZFW ?? "", limitation: perfData.limZFW ?? ""),
            perfWeights(weight: "TOW", plan: perfData.planTOW ?? "", actual: "", max: perfData.maxTOW ?? "", limitation: perfData.limTOW ?? ""),
            perfWeights(weight: "LDW", plan: perfData.planLDW ?? "", actual: "", max: perfData.maxLDW ?? "", limitation: perfData.limLDW ?? ""),
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
        dataPerfWeight = readPerfWeight()
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
            readFuelDataList()
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
        readFuelExtra()
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
    
    func initDataNotams(_ notamsData: INotamsDataResponseModel) {
        do {
            notamsData.depNotams.forEach { item in
                let newObj = NotamsDataList(context: self.service.container.viewContext)
                newObj.id = UUID()
                newObj.type = "depNotams"
                newObj.notam = item.notam
                newObj.date = item.date
                newObj.rank = item.rank
                newObj.isChecked = false
                self.service.container.viewContext.performAndWait {
                    do {
                        try self.service.container.viewContext.save()
                        print("saved notams successfully")
                    } catch {
                        print("Failed to Notams depNotams save: \(error)")
                    }
                    
                }
            }
            
            notamsData.arrNotams.forEach { item in
                let newObj = NotamsDataList(context: self.service.container.viewContext)
                newObj.id = UUID()
                newObj.type = "arrNotams"
                newObj.notam = item.notam
                newObj.date = item.date
                newObj.rank = item.rank
                newObj.isChecked = false
                self.service.container.viewContext.performAndWait {
                    do {
                        try self.service.container.viewContext.save()
                        print("saved notams successfully")
                    } catch {
                        print("Failed to Notams arrNotams save: \(error)")
                    }
                    
                }
            }
            
            notamsData.enrNotams.forEach { item in
                let newObj = NotamsDataList(context: self.service.container.viewContext)
                newObj.id = UUID()
                newObj.type = "enrNotams"
                newObj.notam = item.notam
                newObj.date = item.date
                newObj.rank = item.rank
                newObj.isChecked = false
                self.service.container.viewContext.performAndWait {
                    do {
                        try self.service.container.viewContext.save()
                        print("saved notams successfully")
                    } catch {
                        print("Failed to Notams enrNotams save: \(error)")
                    }
                    
                }
            }
            dataNotams = readDataNotamsList()
        } catch {
            print("Failed to Notams save: \(error)")
            existDataNotams = false
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()
            
        }
    }
    
    func initDataMetarTaf(_ metarTafData: IFlightPlanWXResponseModel) {
        do {
            let newObj = MetarTafDataList(context: service.container.viewContext)
            newObj.id = UUID()
            newObj.depMetar = metarTafData.depMetar
            newObj.depTaf = metarTafData.depTaf
            newObj.arrMetar = metarTafData.arrMetar
            newObj.arrTaf = metarTafData.arrTaf
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
        do {
            readDataMetarTafList()
            if self.dataMetarTaf!.id != nil {
                self.dataMetarTaf.depMetar = metarTafData.depMetar
                self.dataMetarTaf.depTaf = metarTafData.depTaf
                self.dataMetarTaf.arrMetar = metarTafData.arrMetar
                self.dataMetarTaf.arrTaf = metarTafData.arrTaf
            } else {
                let newObj = MetarTafDataList(context: service.container.viewContext)
                newObj.id = UUID()
                newObj.depMetar = metarTafData.depMetar
                newObj.depTaf = metarTafData.depTaf
                newObj.arrMetar = metarTafData.arrMetar
                newObj.arrTaf = metarTafData.arrTaf
            }
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
            }
            
            dataAltnTaf = readDataAltnTafList()
            print("Delete to Altn Taf successfully")
        } catch {
            print("Failed to Altn Taf update: \(error)")
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
                    perfChangesTable = [perfChanges(zfwChange: item.unwrappedZfwChange, lvlChange: item.unwrappedLvlChange)]
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
    
//    func checkAndSyncDataFuel() async {
//        print("Sync")
//        await remoteService.getFuelData(completion: { response in
//            print("Sync=====\(response)")
//            DispatchQueue.main.async {
////                if let historicalDelays = response?.historicalDelays {
////                    self.initHistoricalDelays(historicalDelays)
////                }
//
//                if let projDelays = response?.projDelays {
//                    self.initProjDelays(projDelays)
//                }
//
////                if let taxi = response?.taxi {
////                    self.initProjTaxi(taxi)
////                }
////
////                if let trackMiles = response?.trackMiles {
////                    self.initTrackMiles(trackMiles)
////                }
////
////                if let enrWX = response?.enrWX {
////                    self.initEnrWX(enrWX)
////                }
////
////                if let flightLevel = response?.flightLevel {
////                    self.initFlightLevel(flightLevel)
////                }
////
////                if let reciprocalRwy = response?.reciprocalRwy {
////                    self.initReciprocalRwy(reciprocalRwy)
////                }
//            }
//        })
//
//
//    }
    
    func readHistoricalDelays() {
        do {
            let request: NSFetchRequest<HistoricalDelaysList> = HistoricalDelaysList.fetchRequest()
            let results = try service.container.viewContext.fetch(request)
            print("results=======\(results.count)")
            
            if let result = results.first {
                print("resultdelays=======\(result.delays?.allObjects ?? [])")
                print("resultdelays=======\((result.delays?.allObjects ?? []).count)")
            }
        } catch {
            print("Could not fetch notes from Core Data.")
        }
        
    }
    
    func initHistoricalDelays(_ historicalDelays: IHistoricalDelaysModel) {
        do {
                let newObject = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [HistorycalDelaysRefList]()
            
                historicalDelays.days3.delays.forEach { item in
                    let newObjDelay = HistorycalDelaysRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.condition = item.condition
                    newObjDelay.time = item.time
                    newObjDelay.delay = item.delay
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjDelay)
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
            
            
                // For Week1
                let newObject1 = HistoricalDelaysList(context: self.service.container.viewContext)
                newObject1.id = UUID()
                var arr1 = [HistorycalDelaysRefList]()
            
                historicalDelays.week1.delays.forEach { item in
                    let newObjDelay = HistorycalDelaysRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.condition = item.condition
                    newObjDelay.time = item.time
                    newObjDelay.delay = item.delay
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjDelay)
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
                
                newObject1.delays = NSSet(array: arr)
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
            
                historicalDelays.months3.delays.forEach { item in
                    let newObjDelay = HistorycalDelaysRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.condition = item.condition
                    newObjDelay.time = item.time
                    newObjDelay.delay = item.delay
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjDelay)
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
                
                newObject2.delays = NSSet(array: arr)
                newObject2.arrTimeDelay = historicalDelays.week1.arrTimeDelay
                newObject2.arrTimeDelayWX = historicalDelays.week1.arrTimeDelayWX
                newObject2.eta = historicalDelays.week1.eta
                newObject2.ymax = historicalDelays.week1.ymax
                newObject2.type = "months3"
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()

                print("saved successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save Historical Delays: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

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
        do {
                let newObject = ProjDelaysList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [ProjDelaysListRef]()
                
                projDelays.delays.forEach { item in
                    let newObjDelay = ProjDelaysListRef(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.time = item.time
                    newObjDelay.delay = Int(item.delay)
                    newObjDelay.mindelay = Int(item.mindelay)
                    newObjDelay.maxdelay = Int(item.maxdelay)
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjDelay)
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

            print("saved Proj Delays successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save Proj Delays: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func initProjTaxi(_ data: ITaxiModel) {
        do {
                let newObject = FuelTaxiList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [FuelTaxiRefList]()
                
                data.flights3.times.forEach { item in
                    let newObjRef = FuelTaxiRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.taxiTime = item.taxiTime
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjRef)
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
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
            
                // For week1
                let newObject1 = FuelTaxiList(context: self.service.container.viewContext)
                newObject1.id = UUID()
                var arr1 = [FuelTaxiRefList]()
                
                data.week1.times.forEach { item in
                    let newObjRef = FuelTaxiRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.taxiTime = item.taxiTime
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjRef)
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
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()
            
                
                // For Month3
                let newObject2 = FuelTaxiList(context: self.service.container.viewContext)
                newObject2.id = UUID()
                var arr2 = [FuelTaxiRefList]()
                
                data.months3.times.forEach { item in
                    let newObjRef = FuelTaxiRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.taxiTime = item.taxiTime
                    
                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjRef)
                        print("saved successfully")
                    } catch {
                        // Something went wrong 😭
                        print("Failed to save Taxi Month3: \(error)")
                        // Rollback any changes in the managed object context
                        service.container.viewContext.rollback()
                        
                    }
                }
            
                newObject.times = NSSet(array: arr2)
                newObject.aveTime = data.months3.aveTime
                newObject.aveDiff = data.months3.aveDiff
                newObject.ymax = data.months3.ymax
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()

                print("saved taxi successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to save Taxi: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func initTrackMiles(_ data: ITrackMilesModel) {
        do {
                let newObject = FuelTrackMilesList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [FuelTrackMilesRefList]()

                data.flights3.trackMiles.forEach { item in
                    let newObjDelay = FuelTrackMilesRefList(context: self.service.container.viewContext)
                    newObjDelay.id = UUID()
                    newObjDelay.phase = item.phase
                    newObjDelay.condition = item.condition
                    newObjDelay.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjDelay)
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

                data.week1.trackMiles.forEach { item in
                    let newObjRef = FuelTrackMilesRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.phase = item.phase
                    newObjRef.condition = item.condition
                    newObjRef.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjRef)
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

                data.months3.trackMiles.forEach { item in
                    let newObjRef = FuelTrackMilesRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.phase = item.phase
                    newObjRef.condition = item.condition
                    newObjRef.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjRef)
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
                newObject1.type = "months3"
                // Persist the data in this managed object context to the underlying store
                try service.container.viewContext.save()

                print("saved Track Miles Month3 successfully")
        } catch {
            // Something went wrong 😭
            print("Failed to Track Miles: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func initEnrWX(_ data: IEnrWXModel) {
        do {
                let newObject = FuelEnrWXList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [FuelEnrWXRefList]()

                data.flights3.trackMiles.forEach { item in
                    let newObjRef = FuelEnrWXRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjRef)
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

                data.week1.trackMiles.forEach { item in
                    let newObjRef = FuelEnrWXRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjRef)
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

                data.months3.trackMiles.forEach { item in
                    let newObjRef = FuelEnrWXRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjRef)
                        print("saved Enr WX Ref Month1 successfully")
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
        } catch {
            // Something went wrong 😭
            print("Failed to Track Miles: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func initFlightLevel(_ data: IFlightLevelModel) {
        do {
                let newObject = FuelFlightLevelList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [FuelFlightLevelRefList]()

                data.flights3.flightLevels.forEach { item in
                    let newObjRef = FuelFlightLevelRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.waypoint = item.waypoint
                    newObjRef.condition = item.condition
                    newObjRef.flightLevel = item.flightLevel

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjRef)
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

                data.week1.flightLevels.forEach { item in
                    let newObjRef = FuelFlightLevelRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.waypoint = item.waypoint
                    newObjRef.condition = item.condition
                    newObjRef.flightLevel = item.flightLevel

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr1.append(newObjRef)
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

                data.months3.flightLevels.forEach { item in
                    let newObjRef = FuelFlightLevelRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.waypoint = item.waypoint
                    newObjRef.condition = item.condition
                    newObjRef.flightLevel = item.flightLevel

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr2.append(newObjRef)
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
        } catch {
            print("Failed to Flight Level: \(error)")
            // Rollback any changes in the managed object context
            service.container.viewContext.rollback()

        }
    }
    
    func initReciprocalRwy(_ data: IReciprocalRwyModel) {
        do {
                let newObject = FuelReciprocalRwyList(context: self.service.container.viewContext)
                newObject.id = UUID()
                var arr = [FuelReciprocalRwyRefList]()

                data.trackMiles.forEach { item in
                    let newObjRef = FuelReciprocalRwyRefList(context: self.service.container.viewContext)
                    newObjRef.id = UUID()
                    newObjRef.date = item.date
                    newObjRef.condition = item.condition
                    newObjRef.trackMilesDiff = item.trackMilesDiff

                    do {
                        // Persist the data in this managed object context to the underlying store
                        try service.container.viewContext.save()
                        arr.append(newObjRef)
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
                "remarkArrDelays": dataFuelExtra.remarkArrDelays,
                "remarkTaxi": dataFuelExtra.remarkTaxi,
                "remarkFlightLevel": dataFuelExtra.remarkFlightLevel,
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
            isUpdating = true
            
            await self.remoteService.updateFuelData(payload, completion: { success in
                if(success) {
                    self.isUpdating = false
                }
            })
        }
    }
}
