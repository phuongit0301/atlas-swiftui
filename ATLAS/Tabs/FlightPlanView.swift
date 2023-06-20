//
//  FlightPlanView.swift
//  ATLAS
//
//  Created by phuong phan on 20/05/2023.
//

import Foundation
import SwiftUI
import CoreData

// fetch flight plan data - todo replace with API / core data
func fetchFlightPlanData() -> [String: Any] {
//    let dateFormatterDate = DateFormatter()
//    let dateFormatterTime = DateFormatter()
//    dateFormatterDate.dateFormat = "ddMMyy"
//    dateFormatterTime.dateFormat = "HH:mm"
    let infoData = InfoData(planNo: "20", fltNo: "SQ123", tailNo: "9VSHM", dep: "SIN", dest: "BER", flightDate: "040723", STDUTC: "08:00", STAUTC: "17:00", STDLocal: "10:00", STALocal: "21:00")
    
    let routeData = RouteData(routeNo: "SINBER91", route: "WSSS/20L AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK G582 PUGER P574 UDULO P574 TOTOX L555 TOLDA M628 PEKEM M628 MIGMA M550 MEVDO  Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA UG33 KOROS UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI T204 NUKRO DCT EDDB/25L", depRwy: "WSSS/20L", arrRwy: "EDDB/25L", levels: "SIN/360/UDULO/380/PEKEM/390/MIGMA/400/KEA/410/KOROS/430/TEXTI/380")
    
    let perfData = PerfData(fltRules: "RVSM", gndMiles: "6385", airMiles: "7004", crzComp: "M42", apd: "1.4", ci: "100", zfwChange: "557", lvlChange: "200", planZFW: "143416", maxZFW: "161025", limZFW: "Structural", planTOW: "227883", maxTOW: "227930", limTOW: "Perf - Obstacle", planLDW: "151726", maxLDW: "172365", limLDW: "Structural")
    
    let fuelData = FuelData(burnoff: ["time": "14:21", "fuel": "076157", "unit": "100"], cont: ["time": "00:34", "fuel": "003000", "policy": "5%"], altn: ["time": "00:42", "fuel": "003279", "unit": "100"], hold: ["time": "00:30", "fuel": "002031", "unit": "100"], topup60: ["time": "00:00", "fuel": "000000"], taxi: ["time": "N.A", "fuel": "000500", "policy": "7mins std taxi time", "unit": "100"], planReq: ["time": "16:07", "fuel": "084967"], dispAdd: ["time": "00:10", "fuel": "000600", "policy": "PER COMPANY POLICY FOR SINBER FLIGHTS"])
    
    let altnData = [
        AltnData(altnRwy: "EDDH/15", rte: "EDDB SOGMA1N SOGMA M748 RARUP T909 HAM DCT", app: "VOR", minima: "670", dist: "0190", fl: "220", comp: "M015", time: "0042", fuel: "03279"),
        AltnData(altnRwy: "EDDK/32R", rte: "EDDB ODLUN1N ODLUN DCT ORTAG DCT ERSIL Y221 EBANA T841 ERNEP ERNEP1C", app: "VOR", minima: "800", dist: "0270", fl: "280", comp: "M017", time: "0055", fuel: "04269"),
        AltnData(altnRwy: "EDDL/05L", rte: "EDDB POVEL1N POVEL DCT EXOBA DCT HMM T851 HALME HALME1X", app: "VOR", minima: "550", dist: "0301", fl: "320", comp: "M018", time: "0057", fuel: "04512"),
        AltnData(altnRwy: "EDDF/25L", rte: "EDDB ODLUN1N ODLUN DCT ORTAG DCT ERSIL Y222 FUL T152 KERAX KERAX3A", app: "VOR", minima: "940", dist: "0246", fl: "280", comp: "M014", time: "0049", fuel: "03914")
        ]
    
    let atcFlightPlanData = """
    -B788/H-SSDDE1E1E2E2E3E3GGHHIIJ3J3J4J4J5J5J6J6M1M1P2P2RRWWXXYYZZ/LLB
    
    -WSSS1740
    
    -N0500F360 AKOMA DCT AKMET DCT AROSO Y513 KALIL Y504 BILIK/M085F360 G582 PUGER P574 UDULO/M085F380 P574 TOTOX/N0497F380 L555 TOLDA M628 PEKEM/N0494F390 M628 MIGMA/N0491F400 M550 MEVDO Y511 PMA V22 YEN L300 LXR P751 KATAB B12 DBA L613 TANSA UL617 KEA/N0494F410 UG33 KOROS/N0491F430 UN133 PEREN UL863 EVIVI DCT OKANA DCT TONDO DCT BEGLA DCT LOKVU DCT LEGAZ DCT BEFRE T204 TEXTI/N0495F380 T204 NUKRO DCT
    
    -EDDB1421 EDDH
    
    -PBN/A1A1B1B1C1C1D1D1L1L1O1O1S2S2 NAV/RNP2,RNP2 DAT/CPDLCX,CPDLCX SUR/RSP180,RSP180 DOF/211202 REG/9VOFH EET/WMFC0001 WIIF0037 WMFC0116 VOMF0125 VABF0412 OOMM0549 OMAE0646 OEJD0657 HECC0923 LGGG1118 LBSR1223 LYBA1236 LHCC1307 LOVV1325 LKAA1335 EDUU1352 EDWW1404 SEL/FJAQ CODE/76BCC8 OPR/TGW 65 66922602 PER/D RMK/ACASII EQUIPPED CALLSIGN SCOOTER TCAS OMAN PERMIT DATOFTGW00092021 SAUDI PERMIT 202160995TA EGYPT PERMIT CAD569817OCT21
    """
    
    let object = ["infoData": infoData, "routeData": routeData, "perfData": perfData, "fuelData": fuelData, "altnData": altnData, "atcFlightPlanData": atcFlightPlanData] as [String : Any]
    return object
}


struct InfoData: Codable {
    let planNo: String
    let fltNo: String
    let tailNo: String
    let dep: String
    let dest: String
    let flightDate: String
    let STDUTC: String
    let STAUTC: String
    let STDLocal: String
    let STALocal: String
}

struct RouteData: Codable {
    let routeNo: String
    let route: String
    let depRwy: String
    let arrRwy: String
    let levels: String
}

struct PerfData: Codable {
    let fltRules: String
    let gndMiles: String
    let airMiles: String
    let crzComp: String
    let apd: String
    let ci: String
    let zfwChange: String
    let lvlChange: String
    let planZFW: String
    let maxZFW: String
    let limZFW: String
    let planTOW: String
    let maxTOW: String
    let limTOW: String
    let planLDW: String
    let maxLDW: String
    let limLDW: String
}

struct FuelData: Codable {
    let burnoff: [String : String]
    let cont: [String : String]
    let altn: [String : String]
    let hold: [String : String]
    let topup60: [String : String]
    let taxi: [String : String]
    let planReq: [String : String]
    let dispAdd: [String : String]
}

struct AltnData: Codable {
    let altnRwy: String
    let rte: String
    let app: String
    let minima: String
    let dist: String
    let fl: String
    let comp: String
    let time: String
    let fuel: String
}
//

// creating flight info table structure
struct flightInfo: Identifiable {
    let flightNo: String
    let aircraft: String
    let depDest: String
    let date: String
    let stdUTC: String
    let staUTC: String
    let stdLocal: String
    let staLocal: String
    let id = UUID()
}

// creating perf info table structure
struct perfInfo: Identifiable {
    let fltRules: String
    let gndMiles: String
    let airMiles: String
    let crzComp: String
    let apd: String
    let ci: String
    let id = UUID()
}

// creating perf changes table structure
struct perfChanges: Identifiable {
    let zfwChange: String
    let lvlChange: String
    let id = UUID()
}

// creating perf weights table structure
struct perfWeights: Identifiable {
    let weight: String
    let plan: String
    //let actual: Int
    let max: String
    let limitation: String
    let id = UUID()
}

// creating fuel info table structure
struct fuel: Identifiable {
    let firstColumn: String
    let time: String
    let fuel: String
    let policy_reason: String
    let id = UUID()
}

// creating altn table structure
struct altn: Identifiable {
    let altnRwy: String
    let rte: String
    let app: String
    let minima: String
    let dist: String
    let fl: String
    let comp: String
    let time: String
    let fuel: String
    let id = UUID()
}


struct FlightPlanView: View {
    // initialise state variables
    @ObservedObject var globalResponse = GlobalResponse.shared
    @State private var showUTC = true
    @State private var includedArrDelays = true
    @State private var includedTaxi = true
    @State private var includedFlightLevel = true
    @State private var includedTrackShortening = true
    @State private var includedEnrWx = true
    @State private var includedReciprocalRwy = true
    @State private var includedZFWchange = true
    @State private var includedOthers = true
    @State private var selectedArrDelays: Int = 0
    @State private var selectedTaxi: Int = 0
    @State private var selectedFlightLevel: Int = 0
    @State private var selectedTrackShortening: Int = 0
    @State private var selectedEnrWx: Int = 0
    @State private var selectedReciprocalRwy: Int = 0
    @State private var selectedOthers: Int = 0
    @State private var actualZFW: Int = 0

    var body: some View {
        // fetch flight plan data
        let flightPlanData: [String : Any] = fetchFlightPlanData()
        
        // fetch fuel data - todo move to core data
        let allAPIresponse = convertAllresponseFromAPI(jsonString: globalResponse.response)
        let fetchedDelays = allAPIresponse["projDelays"] as! [String : Any]
        let fetchedLevels = allAPIresponse["flightLevel"] as! [String : [String : Any]]
        let fetchedMiles = allAPIresponse["trackMiles"] as! [String : [String : Any]]
        let fetchedTimes = allAPIresponse["taxi"] as! [String : [String : Any]]
        let fetchedEnrWX = allAPIresponse["enrWX"] as! [String : [String : Any]]
        // arrival delays
        let projDelay: Int = fetchedDelays["expectedDelay"] as! Int
        // taxi
        let threeFlightsTaxi = fetchedTimes["flights3"]
        let aveDiffTaxi: Int = threeFlightsTaxi!["aveDiff"] as! Int
        // track miles
        let threeFlightsMiles = fetchedMiles["flights3"]!
        let sumMINS: Int = threeFlightsMiles["sumMINS"] as! Int
        // enroute weather
        let threeFlightsEnrWX = fetchedEnrWX["flights3"]!
        let aveDiffEnrWX: Int = threeFlightsEnrWX["aveMINS"] as! Int
        // flight level
        let threeFlightsLevels = fetchedLevels["flights3"]!
        let aveDiffLevels: Int = threeFlightsLevels["aveDiff"] as! Int
        // reciprocal rwy
        let reciprocalRwy: Int = 5  // todo add reciprocal rwy fuel data
        
        // set up flight info table data
        let flightInfoData: InfoData = flightPlanData["infoData"] as! InfoData
        @State var infoTable = [
            flightInfo(flightNo: flightInfoData.fltNo, aircraft: flightInfoData.tailNo, depDest: flightInfoData.dep+" / "+flightInfoData.dest, date: flightInfoData.flightDate, stdUTC: flightInfoData.STDUTC, staUTC: flightInfoData.STAUTC, stdLocal: flightInfoData.STDLocal, staLocal: flightInfoData.STALocal)
        ]
        
        // set up route data
        let flightRouteData: RouteData = flightPlanData["routeData"] as! RouteData
        
        // set up perf tables data
        let perfData: PerfData = flightPlanData["perfData"] as! PerfData
        @State var perfInfoTable = [
            perfInfo(fltRules: perfData.fltRules, gndMiles: perfData.gndMiles, airMiles: perfData.airMiles, crzComp: perfData.crzComp, apd: perfData.apd, ci: perfData.ci)
        ]
        @State var perfChangesTable = [
            perfChanges(zfwChange: "M1000KG BURN LESS \(perfData.zfwChange)KG", lvlChange: "P2000FT BURN LESS \(perfData.lvlChange)KG")
        ]
        @State var perfWeightsTable = [
            perfWeights(weight: "ZFW", plan: perfData.planZFW, max: perfData.maxZFW, limitation: perfData.limZFW),
            perfWeights(weight: "TOW", plan: perfData.planTOW, max: perfData.maxTOW, limitation: perfData.limTOW),
            perfWeights(weight: "LDW", plan: perfData.planLDW, max: perfData.maxLDW, limitation: perfData.limLDW),
        ]
        
        // set up fuel info table data
        let fuelData: FuelData = flightPlanData["fuelData"] as! FuelData
        @State var fuelTable = [
            fuel(firstColumn: "(A) Burnoff", time: fuelData.burnoff["time"]!, fuel: fuelData.burnoff["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(B) Contingency Fuel", time: fuelData.cont["time"]!, fuel: fuelData.cont["fuel"]!, policy_reason: fuelData.cont["policy"]!),
            fuel(firstColumn: "(C) Altn Fuel", time: fuelData.altn["time"]!, fuel: fuelData.altn["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(D) Altn Hold", time: fuelData.hold["time"]!, fuel: fuelData.hold["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(E) 60min Topup Fuel", time: fuelData.topup60["time"]!, fuel: fuelData.topup60["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(F) Taxi Fuel", time: fuelData.taxi["time"]!, fuel: fuelData.taxi["fuel"]!, policy_reason: fuelData.taxi["policy"]!),
            fuel(firstColumn: "(G) Flight Plan Requirement (A + B + C + D + E + F)", time: fuelData.planReq["time"]!, fuel: fuelData.planReq["fuel"]!, policy_reason: ""),
            fuel(firstColumn: "(H) Dispatch Additional Fuel", time: fuelData.dispAdd["time"]!, fuel: fuelData.dispAdd["fuel"]!, policy_reason: fuelData.dispAdd["policy"]!)
        ]
        // fuel calculations
        var calculatedDelayFuel: Int {
            return selectedArrDelays * Int(fuelData.hold["unit"]!)!
        }
        var calculatedTaxiFuel: Int {
            return selectedTaxi * Int(fuelData.taxi["unit"]!)!
        }
        var calculatedFlightLevelFuel: Int {
            return selectedFlightLevel * (Int(perfData.lvlChange)! / 2000)
        }
        var calculatedTrackShorteningFuel: Int {
            return selectedTrackShortening * Int(fuelData.burnoff["unit"]!)!
        }
        var calculatedEnrWxFuel: Int {
            return selectedEnrWx * Int(fuelData.burnoff["unit"]!)!
        }
        var calculatedReciprocalRwyFuel: Int {
            return selectedReciprocalRwy * Int(fuelData.altn["unit"]!)!
        }
        var calculatedZFWFuel: Int {
            return (actualZFW - Int(perfData.planZFW)!)  * (Int(perfData.zfwChange)! / 1000)  // todo change to textfield value for actualZFW
        }
        var calculatedOthersFuel: Int {
            return selectedOthers
        }
        var totalExtraFuelAmt: Int {
            return calculatedDelayFuel + calculatedTaxiFuel + calculatedFlightLevelFuel + calculatedZFWFuel + calculatedEnrWxFuel + calculatedReciprocalRwyFuel + calculatedTrackShorteningFuel + calculatedOthersFuel // todo change to 000digits in front
        }
        var totalExtraFuelTime: Int {
            return selectedArrDelays + selectedEnrWx + selectedReciprocalRwy + selectedTrackShortening  // todo change to hhmm
        }
        var totalExtraFuelRemarks: String {
            return ""  // todo set up logic
        }

        // set up altn table data
        let altnData: [AltnData] = flightPlanData["altnData"] as! [AltnData]
        @State var altnTable: [altn] = altnData.map { item in
            return altn(
                altnRwy: item.altnRwy,
                rte: item.rte,
                app: item.app,
                minima: item.minima,
                dist: item.dist,
                fl: item.fl,
                comp: item.comp,
                time: item.time,
                fuel: item.fuel
            )
        }

        // set up ATC flight plan data
        let atcFlightPlan: String = flightPlanData["atcFlightPlanData"] as! String

        VStack(alignment: .leading) {
            // fixed header section, todo clean up design
            HStack(alignment: .center) {
                Text("Summary")
                    .font(.title)
                    .padding(.leading, 30)
                Spacer()
                .frame(maxWidth: .infinity)
                Button(action: {}) {  // todo add the action here, fix design
                    Text("Sign-off")
                }
                .buttonStyle(.bordered)
                .padding(.trailing, 30)
            }
            .padding(.bottom, 10)
            Text("Plan \(flightInfoData.planNo) | Last updated 0820LT")
            .padding(.leading, 30)
            .padding(.bottom, 10)
            //scrollable outer list section
            List {
                // Flight information section
                Section(header:
                    HStack(alignment: .center) {
                        Text("FLIGHT INFORMATION")
                        .foregroundStyle(Color.black)
                        Spacer()
                        .frame(maxWidth: .infinity)  // todo fix spacing
                        Text("Local")
                        Toggle(isOn: $showUTC) {}
                        Text("UTC")
                    }) {
                    // table body
                    if showUTC {
                        Table(infoTable) {
                            TableColumn("Flight No.", value: \.flightNo)
                            TableColumn("Aircraft", value: \.aircraft)
                            TableColumn("DEP / DEST", value: \.depDest)
                            TableColumn("Date", value: \.date)
                            TableColumn("STD", value: \.stdUTC)
                            TableColumn("STA", value: \.staUTC)
                        }
                        .frame(minHeight: 65)
                    }
                    else {
                        Table(infoTable) {
                            TableColumn("Flight No.", value: \.flightNo)
                            TableColumn("Aircraft", value: \.aircraft)
                            TableColumn("DEP / DEST", value: \.depDest)
                            TableColumn("Date", value: \.date)
                            TableColumn("STD", value: \.stdLocal)
                            TableColumn("STA", value: \.staLocal)
                        }
                        .frame(minHeight: 65)
                    }
                    
                }
                
                // Route section
                Section(header: Text("ROUTE").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("Route No.")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.routeNo)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Route")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.route)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Planned Dep Rwy")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.depRwy)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Planned Arr Rwy")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.arrRwy)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                        Divider()
                            .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Planned levels")
                            .foregroundStyle(Color.blue)
                            .frame(maxWidth: 144, alignment: .leading)
                            Text(flightRouteData.levels)
                                .frame(maxWidth: 860, alignment: .leading)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .padding(.leading, 25)
                    }
                }
                
                // Performance section
                Section(header: Text("PERFORMANCE").foregroundStyle(Color.black)) {
                    // table body - first row
                    Table(perfInfoTable) {
                        TableColumn("FLT Rules", value: \.fltRules)
                        TableColumn("GND Miles", value: \.gndMiles)
                        TableColumn("AIR Miles", value: \.airMiles)
                        TableColumn("CRZ Comp", value: \.crzComp)
                        TableColumn("APD", value: \.apd)
                        TableColumn("CI", value: \.ci)
                    }
                    .frame(minHeight: 65)
                    .scrollDisabled(true)
                    // table body - changes
                    Table(perfChangesTable) {
                        TableColumn("ZFW Change", value: \.zfwChange)
                        TableColumn("FL Change", value: \.lvlChange)
                    }
                    .frame(minHeight: 65)
                    .scrollDisabled(true)
                    // table body - weights
                    Table(perfWeightsTable) {
                        TableColumn("Weight", value: \.weight)
                        TableColumn("Plan", value: \.plan)
                        TableColumn("Actual") {_ in
//                            $weight in TextField("Enter actual weight", text: $weight)
                            Text("textfield")  // todo make textfield here
                        }
                        TableColumn("Max", value: \.max)
                        TableColumn("Limitation", value: \.limitation)
                    }
                    .frame(minHeight: 185)
                    .scrollDisabled(true)
                }
                
                // Fuel section
                Section(header: Text("FUEL").foregroundStyle(Color.black)) {
                    // grouped row using hstack
                    VStack(alignment: .leading) {
                        // fuel info table body
                        Table(fuelTable) {
                            TableColumn("", value: \.firstColumn)
                            TableColumn("Time", value: \.time)
                            TableColumn("Fuel", value: \.fuel)
                            TableColumn("Policy / Reason", value: \.policy_reason)
                        }
                        .frame(minHeight: 300)
                        .scrollDisabled(true)
                        
                        // extra fuel section
                        // row I
                        HStack(alignment: .center) {
                            Text("(I) Pilot Extra Fuel")
                                .frame(maxWidth: 310, alignment: .leading)
                            Text("Confirm requirements")  // todo change to dynamic - totalExtraFuelTime
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Confirm requirements") // todo change to dynamic - totalExtraFuelAmt
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Confirm requirements") // todo change to dynamic - totalExtraFuelRemarks
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 25)
                        .background(Color.cyan)  // todo correct design
                        Divider()
                            .padding(.leading, 25)
                        // collapsible fuel calculation section -  todo correct design and make collapsible on select row I
                        Group {
                            // header row
                            HStack(alignment: .center) {
                                Text("Included")
                                    .frame(maxWidth: 70, alignment: .leading) // todo correct spacing
                                Text("Reason")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("Statistical")
                                Text(" Details")  // todo change to button link to fuel page
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                    .foregroundStyle(Color.blue)
                                Text("Pilot Requirement")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("Calculated Extra Fuel")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("Remarks")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                            }
                            .background(Color.cyan)  // todo correct design
                            Divider()
                        }
                        .padding(.leading, 25)
                        Group {
                            // delays row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedArrDelays) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Arrival Delays")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+\(String(projDelay))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedArrDelays) {
                                    ForEach(0...120, id: \.self) { number in
                                        Text("+\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedDelayFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // taxi row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedTaxi) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Additional taxi")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+\(String(aveDiffTaxi))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedTaxi) {
                                    ForEach(0...60, id: \.self) { number in
                                        Text("+\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedTaxiFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // flight level row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedFlightLevel) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Flight level deviation")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                if aveDiffLevels < 0 {
                                    Text("\(String(aveDiffLevels))ft")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                } else {
                                    Text("+\(String(aveDiffLevels))ft")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Picker("Select", selection: $selectedFlightLevel) {
                                    ForEach(0...1000, id: \.self) { number in
                                        Text("+\(number)ft")
                                    }  // todo make + / - scale in thousands
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedFlightLevelFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // track shortening row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedTrackShortening) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Track shortening savings")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("\(String(sumMINS))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedTrackShortening) {
                                    ForEach(-30...0, id: \.self) { number in
                                        Text("\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedTrackShorteningFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            .padding(.leading, 25)
                            .frame(maxWidth: .infinity)
                            Divider()
                                .padding(.leading, 25)
                            // enr wx row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedEnrWx) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Enroute weather deviation")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+\(String(aveDiffEnrWX))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedEnrWx) {
                                    ForEach(0...30, id: \.self) { number in
                                        Text("\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedEnrWxFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                        }
                        .padding(.leading, 25)
                        Group {
                            // reciprocal rwy row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedReciprocalRwy) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("Reciprocal rwy")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("+/-\(String(reciprocalRwy))mins")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Picker("Select", selection: $selectedReciprocalRwy) {
                                    ForEach(-15...15, id: \.self) { number in
                                        Text("\(number)mins")
                                    }
                                }
                                .pickerStyle(.wheel) // todo make into modal as per figma design
                                Text("\(String(calculatedReciprocalRwyFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // zfw change row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedZFWchange) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("ZFW Change")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("\(String(calculatedZFWFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                            // others row
                            HStack(alignment: .center) {
                                Toggle(isOn: $includedOthers) {}  // todo toggle logic flow
                                    .frame(maxWidth: 65, alignment: .leading)
                                Text("ZFW Change")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("N.A.")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo correct spacing
                                Text("\(String(calculatedOthersFuel))KG")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Enter remarks (optional)")
                                    .frame(maxWidth: .infinity, alignment: .leading) // todo make into textfield
                            }
                            Divider()
                        }
                        .padding(.leading, 25)
                        HStack(alignment: .center) {
                            Text("Total Extra Fuel")
                                .frame(maxWidth: 310, alignment: .leading)
                            Text("\(totalExtraFuelAmt)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.leading, 25)
                        .background(Color.cyan)  // todo correct design
                        Divider()
                            .padding(.leading, 25)
                        
                    }
                }
                
                // ALTN section
                Section(header: Text("ALTN").foregroundStyle(Color.black)) {
                    // todo - correct spacing and wrap text
                    Table(altnTable) {
                        TableColumn("ALTN / RWY", value: \.altnRwy)
                        TableColumn("RTE", value: \.rte)
                        TableColumn("APP", value: \.app)
                        TableColumn("MINIMA", value: \.minima)
                        TableColumn("DIST", value: \.dist)
                        TableColumn("FL", value: \.fl)
                        TableColumn("COMP", value: \.comp)
                        TableColumn("TIME", value: \.time)
                        TableColumn("FUEL", value: \.fuel)
                    }
                    .frame(minHeight: 250)
                    .scrollDisabled(true)
                }
                
                // ATC flight plan section
                Section(header: Text("ATC FLIGHT PLAN").foregroundStyle(Color.black)) {
                    Text("\(atcFlightPlan)")
                        .padding(.leading, 25)
                }
            }
        }
        .navigationTitle("Summary")
        .background(Color(.systemGroupedBackground))
    }
    
}
